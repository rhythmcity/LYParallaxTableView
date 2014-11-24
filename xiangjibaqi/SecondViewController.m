//
//  SecondViewController.m
//  xiangjibaqi
//
//  Created by 李言 on 14/11/8.
//  Copyright (c) 2014年 ___李言___. All rights reserved.
//

#import "SecondViewController.h"
#import "XJBQTableViewCell.h"
#import "XJBQModel.h"
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface SecondViewController ()
{
    UITableView *_tableview ;
    
    NSMutableArray *dataArr;
    
    UIView *headerView;
    
    UIImageView *backImageView;
    CGFloat maxoffset  ;  //到大完全跟随滚动的最大值
    
    CGFloat distantY; //tableview 和 背景图片的重叠距离
    
    CGFloat coverY; // 背景图片超出屏幕距离
    
   
}
//@property (nonatomic ,strong)CIContext *context;
@property (nonatomic, strong)NSMutableArray *blurimageArr;
@end

@implementation SecondViewController


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
   
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor =[UIColor whiteColor];
    
    _tableview =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableview];
    dataArr =[[NSMutableArray alloc] init];
    
    [self getModel];
    
    
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    headerView.backgroundColor = [UIColor clearColor];
    UIImageView *headimage = [[ UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    headimage.center = CGPointMake(160, 150);
    headimage.image = [UIImage imageNamed:@"2.gif"];
    [headerView addSubview:headimage];
    _tableview.tableHeaderView =headerView;
    
    
    backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -60, 320, 360)];
    backImageView.image = [UIImage imageNamed:@"4.jpg"];
    [self.view insertSubview:backImageView atIndex:0];
    
    
    [_tableview addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
     maxoffset  =0.0f;
    
    distantY = CGRectGetMaxY(backImageView.frame)-CGRectGetMaxY(headerView.frame);
    coverY = headerView.frame.origin.y-backImageView.frame.origin.y;
    _backImage = backImageView.image;
    self.blurimageArr = [[NSMutableArray alloc] init];

    [self prepareForBlurImages];

}

/*如果实时处理模糊效果 会很卡 所以预加载*/
- (void)prepareForBlurImages
{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        CGFloat factor = 0.1;
        [self.blurimageArr addObject:_backImage];
        for (NSUInteger i = 0; i < backImageView.frame.size.height/10; i++) {
            
            [self.blurimageArr addObject:[_backImage boxblurImageWithBlur:factor]];
            factor+=0.14;
        
    }

});
}


-(void)setBackImage:(UIImage *)backImage{

    _backImage = backImage;
    backImageView.image = _backImage;
    [self.blurimageArr removeAllObjects];
    
    [self prepareForBlurImages];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (_tableview) {
        CGFloat offset =   _tableview.contentOffset.y;
        NSLog(@"offset = = = ==%f",offset);
        int  offSetint = offset;
        NSLog(@"offSetint = = = ==%d",offSetint);
        if (offset>0) {// 向上模糊效果
        
            NSInteger index = offset / 10;
            if (index < 0) {
                index = 0;
            }
            else if(index >= self.blurimageArr.count) {
                index = self.blurimageArr.count - 1;
            }
            UIImage *image = self.blurimageArr[index];
            if (backImageView.image != image) {
                [backImageView setImage:image];
                
            }
            
            backImageView.frame = CGRectMake(0,-60-offset/2, 320, backImageView.frame.size.height);
        
            
        }else{
            
            
            if (backImageView.image !=_backImage) {
                 backImageView.image = _backImage;
            }
           
        
            if (offset <-distantY) {// 跟随滚动全速
                NSLog(@"maxoffset %f",maxoffset);
                 backImageView.frame = CGRectMake(0,maxoffset-(offset+distantY), 320, backImageView.frame.size.height);
            }else{//跟随滚动 慢速
                 backImageView.frame = CGRectMake(0,-coverY-offset/2, 320, backImageView.frame.size.height);
                maxoffset  = backImageView.frame.origin.y;
            }
            
       
        }
    
    }


}



-(void)getModel{

    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (int i = 0; i<10; i++) {
            XJBQModel *model = [[XJBQModel alloc] init];
            
            model.imageURl = @"http://ishare.ol-img.com/moudlepic/545997c432a14_149.jpg";
            model.text =@"暗示法哈啥地方哈里斯可多活法拉克时间短发贺卡时间短返回拉开收到就好法拉克束带结发回啦是可点击返回暗示法哈啥地方哈里斯可多活法拉克时间短发贺卡时间短返回拉开收到就好法拉克束带结发回啦是可点击返回暗示法哈啥地方哈里斯可多活法拉克时间短发贺卡时间短返回拉开收到就好法拉克束带结发回啦是可点击返回暗示法哈啥地方哈里斯可多活法拉克时间短发贺卡时间短返回拉开收到就好法拉克束带结发回啦是可点击返回暗示法哈啥地方哈里斯可多活法拉克时间短发贺卡时间短返回拉开收到就好法拉克束带结发回啦是可点击返回暗示法哈啥地方哈里斯可多活法拉克时间短发贺卡时间短返回拉开收到就好法拉克束带结发回啦是可点击返回暗示法哈啥地方哈里斯可多活法拉克时间短发贺卡时间短返回拉开收到就好法拉克束带结发回啦是可点击返回暗示法哈啥地方哈里斯可多活法拉克时间短发贺卡时间短返回拉开收到就好法拉克束带结发回啦是可点击返回暗示法哈啥地方哈里斯可多活法拉克时间短发贺卡时间短返回拉开收到就好法拉克束带结发回啦是可点击返回暗示法哈啥地方哈里斯可多活法拉克时间短发贺卡时间短返回拉开收到就好法拉克束带结发回啦是可点击返回暗示法哈啥地方哈里斯可多活法拉克时间短发贺卡时间短返回拉开收到就好法拉克束带结发回啦是可点击返回暗示法哈啥地方哈里斯可多活法拉克时间短发贺卡时间短返回拉开收到就好法拉克束带结发回啦是可点击返回";
            model.contentUrl =@"https://itunes.apple.com/cn/app/shi-shang-nu-ren-zhi-onlylady/id592994302?mt=8";
            [dataArr addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableview reloadData];
        });
        
        
        
    });


}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return [XJBQTableViewCell getCellHeight:[dataArr objectAtIndex:indexPath.row]];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArr count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     static NSString *indefider = @"cell";
    
    XJBQTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:indefider];
    if (!cell) {
        cell=[[XJBQTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indefider];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
    }
    
    cell.model =[dataArr objectAtIndex:indexPath.row];

    
  
    __weak SecondViewController *this =self;
    

    cell.btnClick =^{
        
         [this.navigationController popToRootViewControllerAnimated:YES];
    
   
    };
    return cell;


}


-(void)dealloc{
    NSLog(@"%s",__FUNCTION__);
    [_tableview removeObserver:self forKeyPath:@"contentOffset"];
}

-(void)reverBlock{

    NSLog(@"%s",__FUNCTION__);
}
-(void)btnClicks{
    NSLog(@"%s",__FUNCTION__);
    
   

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end


@implementation UIImage (Blur)
-(UIImage *)boxblurImageWithBlur:(CGFloat)blur {
    
    NSData *imageData = UIImageJPEGRepresentation(self, 1); // convert to jpeg
    UIImage* destImage = [UIImage imageWithData:imageData];
    
    
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = destImage.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    
    vImage_Error error;
    
    void *pixelBuffer;
    
    
    //create vImage_Buffer with data from CGImageRef
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //create vImage_Buffer for output
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
        
        outBuffer.data = pixelBuffer;
        outBuffer.width = CGImageGetWidth(img);
        outBuffer.height = CGImageGetHeight(img);
        outBuffer.rowBytes = CGImageGetBytesPerRow(img);
        
        // Create a third buffer for intermediate processing
        void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
        vImage_Buffer outBuffer2;
    outBuffer2.data = pixelBuffer2;
    outBuffer2.width = CGImageGetWidth(img);
    outBuffer2.height = CGImageGetHeight(img);
    outBuffer2.rowBytes = CGImageGetBytesPerRow(img);
    
    //perform convolution
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    free(pixelBuffer2);
    CFRelease(inBitmapData);
    
    CGImageRelease(imageRef);
    
    return returnImage;
}
@end
