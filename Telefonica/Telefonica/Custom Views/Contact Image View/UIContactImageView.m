//
//  UIContactImageView.m
//  ContainersApp
//
//  Created by Action-Item on 03/12/2015.
//  Copyright © 2015 ActionItem. All rights reserved.
//

#import "UIContactImageView.h"

@implementation UIContactImageView
{
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = self.frame.size.width / 2;
        self.clipsToBounds = YES;
    }
    
    return self;
}

@end