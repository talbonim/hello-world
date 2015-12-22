//
//  ViewController.h
//  Telefonica
//
//  Created by Action-Item on 13/12/2015.
//  Copyright © 2015 ActionItem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIHeaderView.h"
#import "CellData.h"

enum
{
    SectionPaymentSettings,
    SectionAccount,
    SectionAbout,
    SectionTotalSections
}; typedef NSInteger SectionName;

@interface UIMoreViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>


@end

