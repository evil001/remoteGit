//
//  MyBookView.m
//  BookReader
//
//  Created by 晓军 唐 on 13-1-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "MyBookView.h"

@implementation MyBookView

@synthesize reuseIdentifier;
@synthesize selected = _selected;
@synthesize index = _index;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _checkedImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"BookViewChecked.png"]];
        [_checkedImageView setHidden:YES];
        [self addSubview:_checkedImageView];
        [self addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setSelected:(BOOL)selected{
    _selected = selected;
    if (_selected) {
        [_checkedImageView setHidden:NO];
    }else {
        [_checkedImageView setHidden:YES];
    }
}

- (void)buttonClicked:(id)sender{
    [self setSelected:_selected?NO:YES];
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
