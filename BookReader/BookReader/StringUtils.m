//
//  StringUtils.m
//  BookReader
//
//  Created by Dwen on 13-2-1.
//
//

#import "StringUtils.h"

@implementation StringUtils

+ (NSString *)substringTo : (NSString *)string : (int)to{
    if (nil == string) {
        return @" ";
    }
    if ([string length]>to) {
        return [NSString stringWithFormat:@"%@...",[string substringToIndex:to]];
    }else{
        return string;
    }
}

+ (NSString *)substringFrom : (NSString *)string : (int)from{
    if (nil == string) {
        return @" ";
    }
    if ([string length]>from) {
        return [NSString stringWithFormat:@"%@...",[string substringFromIndex:from]];
    }else{
        return string;
    }
}
@end
