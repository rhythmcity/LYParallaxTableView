//
//  LYNavgation.m
//  xiangjibaqi
//
//  Created by 李言 on 14/11/24.
//  Copyright (c) 2014年 ___李言___. All rights reserved.
//

#import "LYNavgation.h"
#import "LYNavanimation.h"
#import "LYPopAnimation.h"
@interface LYNavgation ()
@property (nonatomic,strong)LYNavanimation *pushAnimation;
@property (nonatomic,strong)LYPopAnimation *popAnimation;
@end

@implementation LYNavgation



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.navigationBarHidden = YES;
        self.delegate =self;
        self.pushAnimation = [[LYNavanimation alloc] init];
        self.popAnimation = [[LYPopAnimation alloc] init];
    }
    return self;
}



-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPush) {
        return self.pushAnimation;
    }
    if (operation == UINavigationControllerOperationPop){
        return self.popAnimation;
    }
    return nil;
}

//-(id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
//    return self.interactionController;
//}
@end
