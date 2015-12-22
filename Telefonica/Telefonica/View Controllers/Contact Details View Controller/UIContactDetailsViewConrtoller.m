//
//  UIContactDetailsViewConrtoller.m
//  ContainersApp
//
//  Created by Action-Item on 03/12/2015.
//  Copyright © 2015 ActionItem. All rights reserved.
//

#import "UIContactDetailsViewConrtoller.h"

@implementation UIContactDetailsViewConrtoller
{
    UIImage *_contactProfileImage;
    UITableView *_contactDetailsTableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self layoutData];
}

#pragma mark - Private Method

- (void)layoutData
{
    _contactDetailsTableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                            style:UITableViewStylePlain];
    _contactDetailsTableView.backgroundColor = [UIColor whiteColor];
    
    _contactDetailsTableView.delegate = self;
    _contactDetailsTableView.dataSource = self;
    
    [self.view addSubview:_contactDetailsTableView];
}

- (NSString *)cellTypeForSection:(NSInteger)section
{
    switch (section)
    {
        case cellTypeHeader:
        {
            return @" ";
            break;
        }
        case cellTypePhone:
        {
            return @"mobile";
            break;
        }
        case cellTypeEmail:
        {
            return @"email";
            break;
        }
        default:
        {
            return @"";
            break;
        }
    }
}

#pragma mark - UITableView Delegates & dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return  5.0;
    
    return 20.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @" ";
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *contactDetailsHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)] ;
    contactDetailsHeaderView.backgroundColor = [UIColor whiteColor];
    
    UILabel *contactDetailsLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,0,contactDetailsHeaderView.bounds.size.width,contactDetailsHeaderView.bounds.size.height)];
    contactDetailsLabel.font = [UIFont fontWithName:@"Helvetica" size:11.0];
    contactDetailsLabel.font = [UIFont boldSystemFontOfSize:11.0];
    contactDetailsLabel.textColor = [UIColor blueColor];
    contactDetailsLabel.text = [self cellTypeForSection:section];
    [contactDetailsHeaderView addSubview:contactDetailsLabel];
    
    return contactDetailsHeaderView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case cellTypeHeader:
        {
            UITableViewCell *cell = [_contactDetailsTableView dequeueReusableCellWithIdentifier:@"cellTypeHeader"];
            UIImage *contactProileImage;
            UIContactImageView * contactImageView;
            CNContactFormatter *formatter;
            
            if(!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellTypeHeader"];
                contactImageView = [[UIContactImageView alloc] initWithFrame:CGRectMake(10, 0, cell.frame.size.height, cell.frame.size.height)];
                cell.indentationLevel = 5;
                
                formatter = [[CNContactFormatter alloc] init];
            }
            
            cell.textLabel.text = nil;
            
            if (_contact.imageData)
                contactProileImage = [UIImage imageWithData:_contact.imageData];
            else
                contactProileImage = [UIImage imageNamed:@"default-contact"];
            
            contactImageView.image = contactProileImage;
    
            [cell.contentView addSubview:contactImageView];
            NSString *contactFullName = [formatter stringFromContact:_contact];
            cell.textLabel.text = contactFullName;
            
            return cell;
            break;
        }
        case cellTypePhone:
        {
            UITableViewCell *cell = [_contactDetailsTableView dequeueReusableCellWithIdentifier:@"cellTypePhone"];
            
            if(!cell)
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellTypePhone"];
            
            cell.textLabel.text = nil;
            cell.imageView.image = nil;
            
            NSString *contactPhoneNumber = _contact.phoneNumbers.firstObject.value.stringValue;
            if (contactPhoneNumber)
                cell.textLabel.text = contactPhoneNumber;
            
            return cell;
            break;
        }
        case cellTypeEmail:
        {
            UITableViewCell *cell = [_contactDetailsTableView dequeueReusableCellWithIdentifier:@"cellTypeEmail"];
            
            if(!cell)
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellTypeEmail"];
            
            cell.imageView.image = nil;
            cell.textLabel.text = nil;
            
            NSString *contactEmail = _contact.emailAddresses.firstObject.value;
            if (contactEmail)
                cell.textLabel.text = contactEmail;
            
            return cell;
            break;
        }
        default:
        {
            UITableViewCell *cell = [_contactDetailsTableView dequeueReusableCellWithIdentifier:@"cell"];

            if(!cell)
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            
            cell.textLabel.text = nil;
            cell.imageView.image = nil;
            
            return cell;
            break;
        }
    }
}

@end