//
//  LYPopAnimation.m
//  xiangjibaqi
//
//  Created by 李言 on 14/11/24.
//  Copyright (c) 2014年 ___李言___. All rights reserved.
//

#import "LYPopAnimation.h"
#import "AppDelegate.h"
@implementation LYPopAnimation


-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.45;
}


-(UIImage *)getimage:(UIViewController *)viewcontroller{
    
    UIView *subView = viewcontroller.view;
    NSInteger index = 0;//用来给保存的png命名
    
    //支持retina高分的关键
    if(UIGraphicsBeginImageContextWithOptions != NULL)
    {
        UIGraphicsBeginImageContextWithOptions(subView.frame.size, NO, 0.0);
    } else {
        
        UIGraphicsBeginImageContext(subView.frame.size);
    }
    
    //获取图像
    [subView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //保存图像
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/%ld.png",(long)index];
    if ([UIImagePNGRepresentation(image) writeToFile:path atomically:YES]) {
        index += 1;
        NSLog(@"Succeeded! %@",path);
    }
    else {
        NSLog(@"Failed!");
    }
    
    
    
    return image;
    
    
    
}
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    NSLog(@"Hello2");
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    [[transitionContext containerView] addSubview:toViewController.view];
    toViewController.view.alpha = 0;
    UIApplication * app = [UIApplication sharedApplication];
    AppDelegate * appDel = app.delegate;
    appDel.touchImageView.image = [self getimage:fromViewController];
      toViewController.view.alpha = 1;
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
       // fromViewController.view.transform = CGAffineTransformMakeScale(0, 0);
//        toViewController.view.transform = CGAffineTransformMakeScale(1, 1);
        
      
        appDel.touchImageView.frame = appDel.touchFrame;
    } completion:^(BOOL finished) {
        fromViewController.view.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
      
        [appDel.touchImageView removeFromSuperview];
        
    }];
}
@end
