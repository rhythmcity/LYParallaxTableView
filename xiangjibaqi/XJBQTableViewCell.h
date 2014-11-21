//
//  XJBQTableViewCell.h
//  xiangjibaqi
//
//  Created by 李言 on 14/11/8.
//  Copyright (c) 2014年 ___李言___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XJBQModel.h"
@protocol tViewDelegete <NSObject>

-(void)btnClicks;

@end

typedef void(^finsh)(NSString *name , int  age);
@interface XJBQTableViewCell : UITableViewCell
{

    UIImageView *imageView;
    
    UILabel *contentLabel;
    
    UIButton *btn;


}

@property (nonatomic,strong)XJBQModel *model;
@property (nonatomic,weak)id<tViewDelegete>delegate;

@property (nonatomic,strong)void(^btnClick)();

+(CGFloat)getCellHeight:(XJBQModel *)model;
-(void)refresh:(finsh)finshblock;


@end


