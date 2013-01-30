//
//  Utils.h
//  BookReader
//
//  Created by 晓军 唐 on 13-1-11.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#pragma url地址
#define REQUEST_URL @"http://192.168.6.148:9091/?parmeter="
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

#pragma 排序
#define CLOSE_COST_ASC @"成交价从低到高"
#define CLOSE_COST_DESC @"成交价从高到低"
#define LOT_ASC @"图录号从小到大"
#define LOT_DESC @"图录号从大到小"
//成交价排序
#define CLOSE_COST_TYPE @"closeCost"
//lot号排序
#define LOT_TYPE @"lot"
//升序
#define ASC @"asc"
//降序
#define DESC @"desc"

@interface Utils : NSObject

@end
