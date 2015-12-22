//
//  sectionData.h
//  Telefonica
//
//  Created by Action-Item on 14/12/2015.
//  Copyright © 2015 ActionItem. All rights reserved.
//

#import <Foundation/Foundation.h>

enum
{
    cellTypeRegular,
    cellTypePhoneNumber,
    cellTypeToggle,
    cellTypeVersion,
    cellTypeAccess,
}; typedef NSInteger CellType;

@interface CellData : NSObject

- (instancetype)initWithTitle:(NSString *)title cellType:(CellType)cellType;
- (instancetype)initWithTitle:(NSString *)title cellType:(CellType)cellType detail:(NSString *)detail;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *detail;

@property (nonatomic, unsafe_unretained) CellType cellType;


@end
