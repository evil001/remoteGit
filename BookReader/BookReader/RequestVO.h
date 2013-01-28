//
//  RequestVO.h
//  IpadLisShow
//  封装请求对象
//  Created by Dwen on 13-1-23.
//  Copyright (c) 2013年 Dwen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestVO : NSObject
//类名
@property(strong,nonatomic) NSString *className;
//方法名
@property(strong,nonatomic) NSString *methodName;
//场次号
@property(strong,nonatomic) NSString *specialCode;
//分页开始
@property(strong,nonatomic) NSString *start;
//分页结束
@property(strong,nonatomic) NSString *end;
@end
