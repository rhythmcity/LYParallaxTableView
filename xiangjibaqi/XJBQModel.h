//
//  XJBQModel.h
//  xiangjibaqi
//
//  Created by 李言 on 14/11/8.
//  Copyright (c) 2014年 ___李言___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
@interface XJBQModel : NSObject
@property (nonatomic,strong)NSString *imageURl;
@property (nonatomic,strong)NSString *text;
@property (nonatomic,strong)NSString *contentUrl;
@property (nonatomic,strong)AVPlayer *moviePlayer;
@property (nonatomic,strong)NSString *localUrl;
@end
