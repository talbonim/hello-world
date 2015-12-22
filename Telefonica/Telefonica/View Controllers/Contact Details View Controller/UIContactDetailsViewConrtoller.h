//
//  UIContactDetailsViewConrtoller.h
//  ContainersApp
//
//  Created by Action-Item on 03/12/2015.
//  Copyright © 2015 ActionItem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Contacts/Contacts.h>
#import "UIContactImageView.h"

enum
{
    cellTypeHeader,
    cellTypePhone,
    cellTypeEmail
}; typedef NSInteger CellType;

@interface UIContactDetailsViewConrtoller : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) CNContact *contact;

@end