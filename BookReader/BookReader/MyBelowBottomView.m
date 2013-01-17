//
//  MyBelowBottomView.m
//  BookReader
//
//  Created by 晓军 唐 on 13-1-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "MyBelowBottomView.h"
#import "MyCellView.h"
@implementation MyBelowBottomView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        MyCellView *cell1 = [[MyCellView alloc]initWithFrame:CGRectMake(0, 0, 320, 140)];
        MyCellView *cell2 = [[MyCellView alloc]initWithFrame:CGRectMake(0, 140, 320, 140)];
        
        [self addSubview:cell1];
        [self addSubview:cell2];
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
