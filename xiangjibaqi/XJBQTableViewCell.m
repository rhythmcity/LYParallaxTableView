//
//  XJBQTableViewCell.m
//  xiangjibaqi
//
//  Created by 李言 on 14/11/8.
//  Copyright (c) 2014年 ___李言___. All rights reserved.
//

#import "XJBQTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "LYTool.h"
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height


@implementation XJBQTableViewCell

- (void)awakeFromNib {
    // Initialization code
}



-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier

{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
//        self.backgroundColor = [UIColor blackColor];
        
//        self.contentView.backgroundColor = [UIColor blackColor];
        
       
        playview = [[AVPlayerView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
        [self.contentView addSubview:playview];
        playview.tintColor = [UIColor blackColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playViewTap:)];
        [playview addGestureRecognizer:tap];
        
        contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 320, 320, 80)];
        
        contentLabel.text = @"这是一段视频";
        
        [self.contentView addSubview:contentLabel];
        
        
        
    }
    return  self;
}





-(void)setModel:(XJBQModel *)model{
    
    
    [playview.moviePlayer pause];

    playview.moviePlayer = model.moviePlayer;
    
    [playview.moviePlayer play];
    
}


-(void)playViewTap:(UITapGestureRecognizer *)tap{

    
    if (playview.isPlaying) {
        [playview pause];
    }else{
        [playview play];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
