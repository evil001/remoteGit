//
//  ImageViewController.h
//  BookReader
//
//  Created by 晓军 唐 on 13-1-8.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "Utilities.h"
#import "LeavesViewController.h"

@interface ImageViewController : LeavesViewController
{
    NSArray *images;
    NSString *imageUrl;
}

@property NSString *imageUrl;
@end
