//
//  Utils.h
//  BookReader
//
//  Created by 晓军 唐 on 13-1-11.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#define REQUEST_URL @"http://127.0.0.1:9091/?parmeter="
//图录url
#define CATALOG_URL @"http://new.hosane.com/hosane/upload/catalog/%@"
//拍品url详细页
#define AUCTION_DETAIL_URL @"http://new.hosane.com/hosane/upload/pic%@/big/%@"

//拍品url大图
#define AUCTION_BIG_URL @"http://new.hosane.com/hosane/upload1/pic%@/big/%@"

//拍品列表页
#define AUCTION_LIST_URL @"http://new.hosane.com/hosane/upload/pic%@/%@"

#define IMAGESCAN_PAGE_DATA 10

#define VIEW_CELL_HEIGHT 140

#define PAGE_WIDTH 1024

#define PAGE_HEIGHT 768

@interface Utils : NSObject

@end
