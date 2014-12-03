//
//  AVPlayerView.m
//  xiangjibaqi
//
//  Created by 李言 on 14/11/28.
//  Copyright (c) 2014年 ___李言___. All rights reserved.
//

#import "AVPlayerView.h"

@implementation AVPlayerView



-(id)initWithFrame:(CGRect)frame playerItem:(AVPlayerItem*)playerItem
{
    self = [super initWithFrame:frame];
    if (self) {
        self.moviePlayer = [AVPlayer playerWithPlayerItem:playerItem];
        
        playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.moviePlayer];
        [playerLayer setFrame:frame];
        [self.moviePlayer seekToTime:kCMTimeZero];
        [self.layer addSublayer:playerLayer];
        self.contentURL = nil;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerFinishedPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
        
    }
    return self;
}



- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
  
//        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:contentURL];
//        self.moviePlayer= [[AVPlayer alloc] initWithPlayerItem:playerItem];
        
        
        playerLayer = [[AVPlayerLayer alloc] init];
//        playerLayer.player = self.moviePlayer;
        [playerLayer setFrame:frame];
        [self.layer addSublayer:playerLayer];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerFinishedPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerLayer.player];
    }


    return self;
}




-(void)playerFinishedPlaying:(NSNotification *)notify
{
    NSLog(@"%@",notify.object);
   AVPlayerItem *playeritem  = notify.object;
    if (playerLayer.player.currentItem == playeritem){
    
    [playerLayer.player pause];
    self.isPlaying = NO;
    [playerLayer.player seekToTime:kCMTimeZero];
    [playerLayer.player play];
    }

}

-(void)setMoviePlayer:(AVPlayer *)moviePlayer{
    _moviePlayer = moviePlayer;
    
     playerLayer.player  = self.moviePlayer;
    


}

-(void)setContentURL:(NSURL *)contentURL{
    _contentURL = contentURL;
    
    
    
   


}

-(void)stop{

    [self.moviePlayer pause];
     [self.moviePlayer seekToTime:kCMTimeZero];
    
    self.isPlaying = NO;
}
-(void)pause{
     self.isPlaying = NO;
[self.moviePlayer pause];

}

-(void)play{
 self.isPlaying = YES;
    [self.moviePlayer play];

}
-(void)dealloc
{
  //  [self.moviePlayer removeTimeObserver:playbackObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
