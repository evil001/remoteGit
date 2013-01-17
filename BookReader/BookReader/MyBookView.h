//
//  MyBookView.h
//  BookReader
//
//  Created by 晓军 唐 on 13-1-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSBookView.h"

@interface MyBookView : UIButton<GSBookView>
{
    UIImageView *_checkedImageView;
}

@property (nonatomic,strong) NSString *reuseIdentifier;
@property (nonatomic,assign) BOOL selected;
@property (nonatomic,assign) NSInteger index;
@end
