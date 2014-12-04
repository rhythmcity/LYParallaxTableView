//
//  LYAVPlayer.m
//  xiangjibaqi
//
//  Created by 李言 on 14/12/4.
//  Copyright (c) 2014年 ___李言___. All rights reserved.
//

#import "LYAVPlayer.h"

@implementation LYAVPlayer

+(instancetype)sharePlayer{


    static LYAVPlayer *player = nil;
    static dispatch_once_t oncetoken;
    
    dispatch_once(&oncetoken,^{
    
        player = [[LYAVPlayer alloc] init];
    });
    
    return player;

}


//-(id)init{
//
//    self= [super init];
//    
//    if (self) {
//        
//    }
//    
//    return self;
//
//}
@end
