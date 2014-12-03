//
//  XJBQTableViewCell.h
//  xiangjibaqi
//
//  Created by 李言 on 14/11/8.
//  Copyright (c) 2014年 ___李言___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XJBQModel.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AVPlayerView.h"
#import "AFNetworking.h"
typedef void(^finsh)(NSString *name , int  age);
@interface XJBQTableViewCell : UITableViewCell
{

    UIImageView *imageView;
    
    UILabel *contentLabel;
    
    UIButton *btn;
    
    AVPlayerView *playview;
    MPMoviePlayerViewController *moviePlayerView;
    
    AFHTTPRequestOperationManager *manager;
 
}

@property (nonatomic,strong)XJBQModel *model;

@property (nonatomic,strong)void(^btnClick)();

+(CGFloat)getCellHeight:(XJBQModel *)model;
//-(void)refresh:(finsh)finshblock;


@end



