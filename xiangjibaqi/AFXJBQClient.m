//
//  AFXJBQClient.m
//  xiangjibaqi
//
//  Created by 李言 on 14/11/8.
//  Copyright (c) 2014年 ___李言___. All rights reserved.
//

#import "AFXJBQClient.h"
#define kAFUrl @"http://www.yueying.net/action/api/"
@implementation AFXJBQClient
+ (AFXJBQClient *)sharedClient {
    static AFXJBQClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFXJBQClient alloc] initWithBaseURL:[NSURL URLWithString:kAFUrl]];
       // [_sharedClient setDefaultHeader:@"User-Agent" value:[NSString stringWithFormat:@;
    });
    
    return _sharedClient;
}
@end
