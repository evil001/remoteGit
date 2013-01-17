//
//  ViewController.h
//  BookReader
//
//  Created by 晓军 唐 on 13-1-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSBookShelfView.h"
#import "ASIHTTPRequest.h"
#import "SDWebImage/UIImageView+WebCache.h"

@class MyBelowBottomView;

typedef enum {
    BOOK_UNSELECTED,
    BOOK_SELECTED
}BookStatus;

@interface ViewController : UIViewController<SDWebImageManagerDelegate,GSBookShelfViewDelegate,GSBookShelfViewDataSource>{
    GSBookShelfView *_bookShelfView;
    
    NSMutableArray *_bookArray;
    NSMutableArray *_bookStatus;
    
    NSMutableIndexSet *_booksIndexsToBeRemoved;
    
    BOOL _editMode;
    
    UIBarButtonItem *_editBarButton;
    UIBarButtonItem *_cancleBarButton;
    UIBarButtonItem *_trashBarButton;
    UIBarButtonItem *_addBarButton;
    
    MyBelowBottomView *_belowBottomView;
    UISearchBar *_searchBar;
    
}

@end
