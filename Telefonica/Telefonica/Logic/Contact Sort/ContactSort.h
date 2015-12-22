//
//  MergeManager.h
//  Contacts
//
//  Created by Action-Item on 25/11/2015.
//  Copyright © 2015 ActionItem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Contacts/Contacts.h>


#define START_SORTING_NOTIFICATION    @"start_sorting_notification"
#define FINISH_SORTING_NOTIFICATION   @"finish_sorting_notfication"

@class ContactSort;

@protocol ContactSortDelegate <NSObject>

@optional

- (void)contactSortDidStartSortingContacts:(ContactSort *)contactSort;
- (void)contactSortDidFinishSortingContacts:(ContactSort *)contactSort sortedContacts:(NSMutableArray *)sortedContacts error:(NSError *)error; //error 100:No access granted, User denied it, error 200: user cancel manually
@end

@interface ContactSort : NSObject
{
    NSThread *_sortContactsThread;
    CNContactStore *_contactStore;
    NSInteger _contactsCount;
}

- (void)startSortingContacts;
- (void)stopSortingContacts;

@property (nonatomic, unsafe_unretained) NSInteger sortType;
@property (nonatomic, weak) id<ContactSortDelegate> delegate;

@end