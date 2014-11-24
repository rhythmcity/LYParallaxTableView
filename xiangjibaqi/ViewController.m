//
//  ViewController.m
//  xiangjibaqi
//
//  Created by 李言 on 14/11/8.
//  Copyright (c) 2014年 ___李言___. All rights reserved.
//

#import "ViewController.h"
#import "JSONKit.h"
#import "UIImageView+WebCache.h"
#import "SecondViewController.h"
@interface ViewController ()
{
    UIImageView *icon;
    
    UILabel *namelbl ;

}
@property (nonatomic, strong) CAShapeLayer *shape;
@end

@implementation ViewController



- (CABasicAnimation *)animateKeyPath:(NSString *)keyPath fromValue:(id)from toValue:(id)to timing:(NSString *)timing
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    animation.fromValue = from;
    animation.toValue = to;
    animation.repeatCount = 0.3;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:timing];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.duration = 1;
    animation.delegate = self;
    return animation;
}


-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [self.shape removeAllAnimations];
    [self.shape removeFromSuperlayer];
  
    
  
  
    //[self presentViewController:second animated:NO completion:nil];


}

-(void)animationdo{

    self.shape.transform = CATransform3DMakeScale(0.0, 0.0, 0.0);
    // self.layer.borderWidth = 0;
    
    CABasicAnimation *scaleAnimation = [self animateKeyPath:@"transform.scale"
                                                  fromValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]
                                                    toValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(20.0, 20.0, 20.0)]
                                                     timing:kCAMediaTimingFunctionEaseIn];
    
    
    [self.shape addAnimation:scaleAnimation forKey:@"scaleUp"];
}



-(void)goSecond:(UITapGestureRecognizer *)tap{
   
   
  

    UIView *view = tap.view;
    self.touchView = view;
    SecondViewController *second = [[SecondViewController alloc] init];
    
    [self.navigationController pushViewController:second animated:YES];
    
   // [self animationdo];
    
    //    CATransition *transition = [CATransition animation];
    //    transition.duration = 1;
    //    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //    transition.type = kCATransitionFade;
    //    transition.delegate  =self;
    
//    [self.view.layer addAnimation:transition forKey:@"transiton"];


}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
 
    icon =  [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    icon.backgroundColor = [UIColor clearColor];
    icon.userInteractionEnabled =YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goSecond:)];
    
    [icon addGestureRecognizer:tap];
    
    
    [self.view addSubview:icon];
    
    
    UIImageView *imagev = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 60, 60)];
    [imagev setBackgroundColor:[UIColor redColor]];
    imagev.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goSecond:)];
    [imagev addGestureRecognizer:tap1];
    [self.view addSubview:imagev];
    
    
    namelbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 200, 40)];
    
    [self.view addSubview:namelbl];
    [[AFXJBQClient sharedClient] getPath:@"http://olshow.onlylady.com/index.php?c=LookAPI&a=Default&rd=518" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject =  =%@",[responseObject objectFromJSONData]);
        NSDictionary *dic = [responseObject objectFromJSONData];
        NSDictionary *dedic = [dic objectForKey:@"de"];
        NSArray *apops = [dedic objectForKey:@"apps"];
        for (NSDictionary *di in apops) {
            NSString *image = [di objectForKey:@"aimg"];
            NSString *aintro = [di objectForKey:@"aintro"];
            NSString *name = [di objectForKey:@"aname"];
            NSLog(@"image====%@, intro =====%@, name=====%@",image ,aintro ,name);
            
            
            [icon sd_setImageWithURL:[NSURL URLWithString:image] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                NSLog(@"%@",error);
            }];
            namelbl.text = name;
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
// [self creatShapeLayer];
   
    
//    NSLog(@"%f,%@",self.radius, NSStringFromCGRect(self.shape.frame));
   
}

-(void)creatShapeLayer{

    self.shape = [CAShapeLayer layer];
    self.shape.fillColor =  [UIColor blueColor].CGColor;
   // self.shape.transform = CATransform3DMakeScale(0.0001, 0.0001, 0.0001);
    
    [self.view.layer insertSublayer:self.shape below:icon.layer];
    self.shape.frame = CGRectMake(10, 10, 60, 60);
    self.shape.anchorPoint = CGPointMake(0.5, 0.5);
    self.shape.path = [UIBezierPath bezierPathWithOvalInRect:(CGRect){0, 0, 60 , 60 }].CGPath;
}



-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"%s",__FUNCTION__);

}


-(void)viewWillAppear:(BOOL)animated{

   NSLog(@"%s",__FUNCTION__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
    
}


@end
