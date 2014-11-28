//
//  AVPlayerView.h
//  xiangjibaqi
//
//  Created by 李言 on 14/11/28.
//  Copyright (c) 2014年 ___李言___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface AVPlayerView : UIView

{
   AVPlayerLayer *playerLayer;

}
@property (strong, nonatomic) NSURL *contentURL;
@property (nonatomic, strong)AVPlayer *moviePlayer;
@property (nonatomic, assign)BOOL  isPlaying;
- (id)initWithFrame:(CGRect)frame contentURL:(NSURL*)contentURL;

-(id)initWithFrame:(CGRect)frame playerItem:(AVPlayerItem*)playerItem;
-(void)play;
-(void)pause;
-(void)stop;
@end
