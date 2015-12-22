//
//  ViewController.m
//  Telefonica
//
//  Created by Action-Item on 13/12/2015.
//  Copyright © 2015 ActionItem. All rights reserved.
//

#import "UIMoreViewController.h"

@interface UIMoreViewController ()
{
    __weak IBOutlet UITableView *_mainTableView;
    
    UIHeaderView *_headerView;
    NSDictionary *_tableData;
}
@end

@implementation UIMoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _headerView = [[[NSBundle mainBundle] loadNibNamed:@"UIHeaderView" owner:self options:nil] firstObject];
    _mainTableView.tableHeaderView = _headerView;
    
    [self initiateData];
}

#pragma mark - Private Methods

- (void)initiateData
{
    CellData *callrate = [[CellData alloc] initWithTitle:@"Call Rates" cellType:cellTypeAccess];
    CellData *autoTopUp = [[CellData alloc] initWithTitle:@"Enable auto top up" cellType:cellTypeToggle];
    CellData *removeCardInfo = [[CellData alloc] initWithTitle:@"Remove saved card info" cellType:cellTypeRegular];
    NSArray *paymentSection = [NSArray arrayWithObjects: callrate, autoTopUp, removeCardInfo, nil];
    
    CellData *phoneNumber = [[CellData alloc] initWithTitle:@"Phone number" cellType:cellTypePhoneNumber detail:@"+972-54-7728-941"];
    CellData *callUs = [[CellData alloc] initWithTitle:@"Call Us for help" cellType:cellTypeRegular];
    CellData *deleteAccount = [[CellData alloc] initWithTitle:@"Delete Account" cellType:cellTypeRegular];
    CellData *signOut = [[CellData alloc] initWithTitle:@"Sign out" cellType:cellTypeRegular];
    NSArray *accountSection = [NSArray arrayWithObjects: phoneNumber, callUs, deleteAccount, signOut, nil];
    
    CellData *terms = [[CellData alloc] initWithTitle:@"Terms and conditions" cellType:cellTypeAccess];
    CellData *privacyPolicy = [[CellData alloc] initWithTitle:@"Privacy Policy" cellType:cellTypeAccess];
    CellData *tour = [[CellData alloc] initWithTitle:@"Take a tour" cellType:cellTypeRegular];
    CellData *version = [[CellData alloc] initWithTitle:@"Version" cellType:cellTypeVersion detail:@"1.2.2"];
    NSArray *aboutSection = [NSArray arrayWithObjects: terms, privacyPolicy, tour, version, nil];
    
    
    _tableData = [[NSDictionary alloc] initWithObjectsAndKeys:paymentSection, @"SectionPaymentSettings",
                                                              accountSection, @"SectionAccount",
                                                              aboutSection, @"SectionAbout",
                                                              nil];
}

- (void)alertForHeaderButton:(NSInteger)headerButton
{
    NSString *clickedButton;
    
    switch (headerButton)
    {
        case HeaderButtonFacebook:
        {
            clickedButton = @"Facebook";
            break;
        }
        case HeaderButtonTwitter:
        {
            clickedButton = @"Twitter";
            break;
        }
        case HeaderButtonSMS:
        {
            clickedButton = @"SMS";
            break;
        }
        case HeaderButtonEmail:
        {
            clickedButton = @"Email";
            break;
        }
        default:
        {
            clickedButton = @"Facebook";
            break;
        }
    }
    
    UIAlertController *actionAlert = [UIAlertController
                                      alertControllerWithTitle:@"Telefonica"
                                      message:clickedButton
                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [actionAlert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    [actionAlert addAction:ok];
    
    [self presentViewController:actionAlert animated:YES completion:nil];
}

#pragma mark - Actions

- (IBAction)HeaderButtonClicked:(UIButton *)sender
{
    [self alertForHeaderButton:sender.tag];
    [UIColor colorWithRed:0.2 green:0.8 blue:0.25 alpha:1.0];
}

#pragma mark UITableViewController Delegates

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionData;
    
    switch (section)
    {
        case SectionPaymentSettings:
        {
            sectionData = [_tableData objectForKey:@"SectionPaymentSettings"];
            
            return sectionData.count;
            break;
        }
        case SectionAccount:
        {
            sectionData = [_tableData objectForKey:@"SectionAccount"];
            
            return sectionData.count;
            break;

        }
        case SectionAbout:
        {
            
            sectionData = [_tableData objectForKey:@"SectionAbout"];
            
            return sectionData.count;
            break;
        }
        default:
        {
            return 0;
            break;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return SectionTotalSections;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:tableView.bounds];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, tableView.bounds.size.width, 44)];
    
    NSString *headerSectionTitle;
    switch (section)
    {
        case SectionPaymentSettings:
        {
            headerSectionTitle = @"Payment Settings";
            break;
        }
        
        case SectionAccount:
        {
            headerSectionTitle = @"Account";
            break;
        }
        case SectionAbout:
        {
            headerSectionTitle = @"About";
            break;
        }
            
        default:
            break;
    }
    
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0f];
    label.textColor = [UIColor colorWithRed:81/255.0 green:81/255.0 blue:81/255.0 alpha:1.0];
    label.text = headerSectionTitle;
    [label sizeToFit];
    
    [view addSubview:label];
    view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:248/255.0 alpha:1.0];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sectionKey;
    switch (indexPath.section)
    {
        case SectionPaymentSettings:
        {
            sectionKey = @"SectionPaymentSettings";
            break;
        }
            
        case SectionAccount:
        {
            sectionKey = @"SectionAccount";
            break;
        }
        case SectionAbout:
        {
            sectionKey= @"SectionAbout";
            break;
        }
            
        default:
            break;
    }
    
    NSArray *sectionArray = [_tableData objectForKey:sectionKey];
    CellData *cellData = [sectionArray objectAtIndex:indexPath.row];
    CellType cellType = cellData.cellType;
    
    switch (cellType)
    {
        case cellTypeRegular:
        {
            UITableViewCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"CellTypeRegular"];
            
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellTypeRegular"];
            }
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = cellData.title;
            
            return cell;
            break;
        }
        case cellTypeToggle:
        {
            UITableViewCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"CellTypeToggle"];
            
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellTypeToggle"];
                UISwitch *autoTopUpSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
                autoTopUpSwitch.onTintColor = [UIColor colorWithRed:43.0/255.0 green:152.0/255.0 blue:206.0/255.0 alpha:1.0];
                cell.accessoryView = autoTopUpSwitch;
            }

            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = cellData.title;
            
            return cell;
            break;
        }
        case cellTypePhoneNumber:
        {
            UITableViewCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"CellTypePhoneNumber"];
            
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
                cell.detailTextLabel.textColor = [UIColor colorWithRed:176.0/255.0 green:176.0/255.0 blue:176.0/255.0 alpha:1.0];
                cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = cellData.title;
            cell.detailTextLabel.text =cellData.detail;

            return cell;
            break;
        }
        case cellTypeAccess:
        {
            UITableViewCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"CellTypeAccess"];
            
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellTypeAccess"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            cell.textLabel.text = cellData.title;

            return cell;
            break;
        }
        case cellTypeVersion:
        {
            UITableViewCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"CellTypeVersion"];
            UILabel *appVersionLabel;
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellTypeVersion"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                if (!appVersionLabel)
                    appVersionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
                
                appVersionLabel.textColor = [UIColor colorWithRed:176.0/255.0 green:176.0/255.0 blue:176.0/255.0 alpha:1.0];
                appVersionLabel.adjustsFontSizeToFitWidth = YES;
                cell.accessoryView = appVersionLabel;
            }
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = cellData.title;
            appVersionLabel.text = cellData.detail;
            
            return cell;
            break;
        }
        default:
        {
            UITableViewCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"CellTypeRegular"];
            
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellTypeRegular"];
            }
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = cellData.title;
            
            return cell;
            break;
        }
    }
}

@end