//
//  AFXJBQClient.h
//  xiangjibaqi
//
//  Created by 李言 on 14/11/8.
//  Copyright (c) 2014年 ___李言___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"
@interface AFXJBQClient : AFHTTPClient
+ (AFXJBQClient *)sharedClient;
@end
