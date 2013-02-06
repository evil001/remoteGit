//
//  StringUtils.h
//  BookReader
//  字符串工具类
//  Created by Dwen on 13-2-1.
//
//

#import <Foundation/Foundation.h>

@interface StringUtils : NSObject

//从开始位截取
//参数:{string:字符串，to:位置}
//eg.
//NSString *test = [StringUtils substringTo:@"abcd":2];
//test = @"abc";
+ (NSString *)substringTo : (NSString *)string : (int)to;

//从from位截取
//参数:{string:字符串，from:位置}
//eg.
//NSString *test = [StringUtils substringFrom:@"abcd":2];
//test = @"cd";
+ (NSString *)substringFrom : (NSString *)string : (int)from;
@end
