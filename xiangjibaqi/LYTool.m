//
//  LYTool.m
//  xiangjibaqi
//
//  Created by 李言 on 14/12/3.
//  Copyright (c) 2014年 ___李言___. All rights reserved.
//

#import "LYTool.h"

#import <CommonCrypto/CommonDigest.h>
@implementation LYTool

@end

@implementation NSString (md5)
-(NSString *) md5HexDigest{//计算string的MD5
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
    return nil;
}
@end