//
//  MyCellView.h
//  BookReader
//
//  Created by 晓军 唐 on 13-1-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSBookShelfCell.h"

@interface MyCellView : UIView<GSBookShelfCell>

@property (nonatomic,strong) NSString *reuseIdentifier;
@end
