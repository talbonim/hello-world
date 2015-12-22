//
//  sectionData.m
//  Telefonica
//
//  Created by Action-Item on 14/12/2015.
//  Copyright © 2015 ActionItem. All rights reserved.
//

#import "CellData.h"

@implementation CellData

- (instancetype)init
{
    if (self = [super init])
    {
        _title = @"";
        _cellType = cellTypeRegular;
    }
    
    return self;
}

- (instancetype)initWithTitle:(NSString *)title cellType:(CellType)cellType
{
    if (self = [super init])
    {
        if (title)
            _title = title;
        else
            _title = @"";
        
        if (cellType)
            _cellType = cellType;
        else
            _cellType = cellTypeRegular;
    }
    
    return self;
}

- (instancetype)initWithTitle:(NSString *)title cellType:(CellType)cellType detail:(NSString *)detail
{
    if (self = [super init])
    {
        if (title)
            _title = title;
        else
            _title = @"";
        
        if (cellType)
            _cellType = cellType;
        else
            _cellType = cellTypeRegular;
        
        if (detail)
            _detail = detail;
        else
            _detail = @"";
    }
    
    return self;
}

- (NSString *)description
{
    NSString *cellDataDescription = [NSString stringWithFormat:@"Title: %@ \n Cell type: %ld", _title, _cellType];
    return cellDataDescription;
}

@end
