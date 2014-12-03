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
#import "LYTool.h"
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>
#import "AFDownloadRequestOperation.h"
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
    
    
    AFHTTPRequestOperationManager *manager;
    
    
    NSMutableSet *downloadset;
    
   
}
//@property (nonatomic ,strong)CIContext *context;
@property (nonatomic, strong)NSMutableArray *blurimageArr;
@end

@implementation SecondViewController


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
        
        manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.baidu.com"]];
        
        downloadset = [[NSMutableSet alloc] init];
   
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
    
//        int  offSetint = offset;
    
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



-(void)downloadvideo:(NSString *)url andfinsh:(void(^)(NSString *path))finshblock{

    
    
    if ([downloadset containsObject:url]) {
        return;
    }
    
    [downloadset  addObject:url];
    
    NSString *cachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Cache"];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:cachePath])
    {
        [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
     NSString *path = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",[url md5HexDigest]]];
    if ([fileManager fileExistsAtPath:path]) {
        finshblock (path);
        return;
    }
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    AFDownloadRequestOperation * operation = [[AFDownloadRequestOperation alloc] initWithRequest:request targetPath:path shouldResume:YES];
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        NSLog(@"%f",(float)totalBytesRead/totalBytesExpectedToRead);
        NSLog(@"totalBytesExpectedToRead %lld" ,totalBytesExpectedToRead);
        
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        finshblock(path);
        
        [downloadset removeObject:url];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [fileManager removeItemAtPath:[cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",[url md5HexDigest]]] error:nil];
        
    }];
    [manager.operationQueue addOperation:operation];
}

-(void)getModel{
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"Sydney-iPhone" ofType:@"m4v"];
    
    NSArray *arr  =[NSArray arrayWithObjects:@"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4",@"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4", nil];
  
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (int i = 0; i<arr.count; i++) {
            XJBQModel *model = [[XJBQModel alloc] init];
            model.contentUrl = [arr objectAtIndex:i];
        
            [dataArr addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableview reloadData];
        });
        
        
        
    });


}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 405;
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
    
    
    XJBQModel *model = [dataArr objectAtIndex:indexPath.row];
    
    [self downloadvideo:model.contentUrl andfinsh:^(NSString *path) {
        
        model.localUrl = path;
        if (!model.moviePlayer) {
            AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:model.localUrl]];
            AVPlayer *player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
            model.moviePlayer = player;
        }
        
           cell.model = model;
    
    }];
    
    
  

    

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

