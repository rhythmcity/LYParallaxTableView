//
//  LYNavanimation.m
//  xiangjibaqi
//
//  Created by 李言 on 14/11/24.
//  Copyright (c) 2014年 ___李言___. All rights reserved.
//

#import "LYNavanimation.h"
#import "ViewController.h"
#import "AppDelegate.h"
@implementation LYNavanimation
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.35;
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
    NSLog(@"Hello1");
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    ViewController* fromViewController = (ViewController *) [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [[transitionContext containerView] addSubview:toViewController.view];
    toViewController.view.alpha = 1;   // 用于截图
    
    
    UIApplication *application = [UIApplication sharedApplication];
    AppDelegate  *appdeal = application.delegate;
    UIImageView  *imageview = [[UIImageView alloc] init];
    appdeal.touchImageView = imageview;
    appdeal.touchImageView.image  = [self getimage:toViewController];
    appdeal.touchImageView.frame = fromViewController.touchView.frame;
    appdeal.touchFrame = fromViewController.touchView.frame;
    [fromViewController.view addSubview:appdeal.touchImageView];
    
     toViewController.view.alpha = 0;   // 隐藏负责无动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        imageview.frame = toViewController.view.bounds;
        toViewController.view.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        fromViewController.view.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
         toViewController.view.alpha = 1;
         //[appdeal.touchImageView removeFromSuperview];
    }];
    
}
@end
