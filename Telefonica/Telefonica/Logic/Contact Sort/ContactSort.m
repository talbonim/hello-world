//
//  MergeManager.m
//  Contacts
//
//  Created by Action-Item on 25/11/2015.
//  Copyright © 2015 ActionItem. All rights reserved.
//

#import "ContactSort.h"

@implementation ContactSort

- (void)dealloc
{
    [self stopSortingContactsThread];
}

#pragma mark - Override

- (NSString *)description
{
    NSString *sortingOrder = [self sortingType];
    BOOL isFetchingContacts = NO;
    if (_sortContactsThread)
        isFetchingContacts = YES;
    
    return [NSString stringWithFormat:@"Sorting contact by %@.\n Number of sorted contacts: %ld.\n Sorting in progress: %@", sortingOrder, _contactsCount, (isFetchingContacts) ? @"Yes" : @"NO"];
}

- (NSString *)sortingType
{
    NSString *sortingOrder;
    switch (_sortType)
    {
        case CNContactSortOrderNone:
        {
            sortingOrder = @"None";
            break;
        }
        case CNContactSortOrderUserDefault:
        {
            sortingOrder = @"User Default";
            break;
        }
        case CNContactSortOrderGivenName:
        {
            sortingOrder = @"Given Name";
            break;
        }
        case CNContactSortOrderFamilyName:
        {
            sortingOrder = @"Family Name";
            break;
        }
        default:
        {
            sortingOrder = @"Unknown";
            break;
        }
    }
    
    return sortingOrder;
}

- (void)stopSortingContactsThread
{
    if ([_sortContactsThread isFinished])
        _contactStore = nil;
    _sortContactsThread = nil;
    _contactsCount = 0;
}

- (void)startSortingContacts
{
    if ([_sortContactsThread isExecuting])
    {
        [_sortContactsThread cancel];
        while ([_sortContactsThread isExecuting])
        {
            [[NSRunLoop currentRunLoop ] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
        }
        
        NSError *error = [[NSError alloc] initWithDomain:@"Executing new contacts sort" code:400 userInfo:nil];
        [self notifySortingFinish:nil error:error];
    }
    
    if (!_contactStore) {
        _contactStore = [[CNContactStore alloc] init];
    }
    
    _contactsCount = 0;
    
    [self notifySortingStart];
    [self contactsAccessGrantedWithCompletion:^(NSError *error, BOOL granted) {
        
        if (granted)
        {
            _sortContactsThread = [[NSThread alloc] initWithTarget:self
                                                    selector:@selector(sortContacts)
                                                    object:nil];
            [_sortContactsThread start];
        }
        else
        {
            NSError *error = [[NSError alloc] initWithDomain:@"No access granted" code:100 userInfo:nil];
            _sortContactsThread = nil;
            [self notifySortingFinish:nil error:error];
        }
    }];
}

- (void)stopSortingContacts
{
    [_sortContactsThread cancel];
    [self stopSortingContactsThread];
}

- (void)sortContacts
{
    @autoreleasepool
    {
        NSMutableArray *contacts = [[NSMutableArray alloc] init];
        NSError *fetchError = nil;
        
        CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:@[CNContactIdentifierKey, CNContactPhoneNumbersKey,CNContactImageDataKey,CNContactEmailAddressesKey,[CNContactFormatter descriptorForRequiredKeysForStyle:CNContactFormatterStyleFullName]]];
        request.sortOrder = _sortType;

        BOOL success = [_contactStore enumerateContactsWithFetchRequest:request error:&fetchError usingBlock:^(CNContact *contact, BOOL *stop){
            
            if ([[NSThread currentThread] isCancelled])
            {
                NSError *error = [[NSError alloc] initWithDomain:@"User canceled manually" code:200 userInfo:nil];
                [self notifySortingFinish:nil error:error];
                [self stopSortingContactsThread];
                
                return;
            }
            
            [contacts addObject:contact];
        }];
        if (!success)
        {
            [self stopSortingContactsThread];
            [self notifySortingFinish:nil error:fetchError];
            
            return;
        }
        
        _contactsCount = contacts.count;
        _sortContactsThread = nil;
        [self notifySortingFinish:contacts error:nil];
    }
}

#pragma mark - Ask user for contact access

- (void)contactsAccessGrantedWithCompletion:(void(^)(NSError *error, BOOL granted))callback
{
    CNAuthorizationStatus accessContactsStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (accessContactsStatus == CNAuthorizationStatusDenied)
    {
        if (callback)
        {
            NSError *error = [[NSError alloc] initWithDomain:@"No access granted" code:100 userInfo:nil];
            callback(error, NO);
        }
        
        return;
    }
    if (accessContactsStatus == CNAuthorizationStatusAuthorized)
    {
        if (callback)
            callback(nil, YES);
        
        return;
    }
    if (!_contactStore) {
        return;
    }
    [_contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
        if (callback)
            callback(error, granted);
        
        return ;
    }];
}

#pragma mark - Private notifications

- (void)notifySortingStart
{
    dispatch_async(dispatch_get_main_queue(), ^(){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:START_SORTING_NOTIFICATION object:self userInfo:nil];
    });
}

- (void)notifySortingFinish:(NSArray *)contacts error:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^(){
        
        NSDictionary *userInfo = nil;
        NSMutableDictionary *mutableUserInfo = [NSMutableDictionary dictionary];
        
        if (contacts)
            [mutableUserInfo setObject:contacts forKey:@"contactList"];
        if (error)
            [mutableUserInfo setObject:error forKey:@"error"];
        
        userInfo = mutableUserInfo;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:FINISH_SORTING_NOTIFICATION object:self userInfo:userInfo];
    });
}

@end