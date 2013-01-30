//
//  MyCellView.m
//  BookReader
//
//  Created by 晓军 唐 on 13-1-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "MyCellView.h"

@implementation MyCellView
@synthesize reuseIdentifier;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView;
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        if (orientation == UIInterfaceOrientationPortrait) {
                    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 768, 180)];
        }else {
            imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1024, 180)];
        }

        [imageView setImage:[UIImage imageNamed:@"HBookShelfCell.jpg"]];
        [self addSubview:imageView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
