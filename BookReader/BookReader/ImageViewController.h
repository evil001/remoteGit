//
//  ImageViewController.h
//  BookReader
//
//  Created by 晓军 唐 on 13-1-8.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "Utilities.h"

@interface ImageViewController 
{
    NSArray *images;
    NSString *imageUrl;
}

@property NSUInteger imagesArr_index;
@property NSString *imageUrl;
@property (strong,nonatomic) UISlider *slider;

@end
