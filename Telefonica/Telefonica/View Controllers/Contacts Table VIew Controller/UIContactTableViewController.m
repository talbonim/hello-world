//
//  UIContactTableViewController.m
//  ContainersApp
//
//  Created by Action-Item on 02/12/2015.
//  Copyright © 2015 ActionItem. All rights reserved.
//

#import "UIContactTableViewController.h"
#import "ContactSort.h"


@implementation UIContactTableViewController
{
    UIActivityIndicatorView *_sortingInProgressIndicator;
    BOOL _toggleContactSortButton;
    
    NSArray *_contacts;
    NSInteger _contactIndex;
    ContactSort *_contactSort;
    
    __weak IBOutlet UITableView *_contactsTableView;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _contactSort = [[ContactSort alloc] init];
    _contactSort.sortType = CNContactSortOrderGivenName;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contactSortDidStartSortingContacts)
                                                 name:START_SORTING_NOTIFICATION
                                               object:_contactSort];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contactSortDidFinishSortingContactsWithSortedContacts:)
                                                 name:FINISH_SORTING_NOTIFICATION
                                               object:_contactSort];
    [self layoutData];
}

#pragma mark - Private methods

- (void)layoutData
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self getSortedContactsList];
}

- (void)getSortedContactsList
{
    _toggleContactSortButton = !_toggleContactSortButton;
    if (_toggleContactSortButton)
    {
        [_sortingInProgressIndicator startAnimating];
        [_contactSort startSortingContacts];
        [_sortingInProgressIndicator stopAnimating];
        
        _toggleContactSortButton = !_toggleContactSortButton;
    }
    else
    {
        [_sortingInProgressIndicator stopAnimating];
        [_contactSort stopSortingContacts];
        
        _toggleContactSortButton = !_toggleContactSortButton;
    }
}

#pragma mark - Events

- (void)handleRefresh:(UIRefreshControl *)refreshControl
{
    [self getSortedContactsList];
    [refreshControl endRefreshing];
}

#pragma mark - ContactSort notifications implemitation

- (void)contactSortDidStartSortingContacts
{
    NSLog(@"Did Start Sorting Contacts");
}

- (void)contactSortDidFinishSortingContactsWithSortedContacts:(NSNotification *)notification
{
    NSError *error = notification.userInfo[@"error"];
    
    if (!error)
    {
        NSArray *contacts = notification.userInfo[@"contactList"];
        
        if (contacts.count)
        {
            _contacts =contacts;
            [_contactsTableView reloadData];
            NSLog(@"Did Finish sort Contacts.\n");
        }
    }
    else
        NSLog(@"%@", error.domain);
}

#pragma mark - UITableVeiw Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *contactCell = [_contactsTableView dequeueReusableCellWithIdentifier:@"ContactCell"];;
   
    CNContactFormatter *formatter = [[CNContactFormatter alloc] init];
    CNContact *contact = [_contacts objectAtIndex:indexPath.row];
    
    NSString *contactFullName = [formatter stringFromContact:contact];
    NSString *contactPhoneNumber = contact.phoneNumbers.firstObject.value.stringValue;
    UIImage *contactProileImage = [UIImage imageWithData:contact.imageData];
    
    contactCell.imageView.image = contactProileImage;
    contactCell.textLabel.text = contactFullName;
    contactCell.detailTextLabel.text = contactPhoneNumber;
    
    return contactCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _contactIndex = indexPath.row;
    [self performSegueWithIdentifier:@"ContactDetails" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIContactTableViewController *)sender
{
    if ([[segue identifier] isEqualToString:@"ContactDetails"])
    {
        UIContactDetailsViewConrtoller *contactDetailsViewController = (UIContactDetailsViewConrtoller *)[segue destinationViewController];
        CNContact *contact = [_contacts objectAtIndex:_contactIndex];
        contactDetailsViewController.contact = contact;
    }
}

@end