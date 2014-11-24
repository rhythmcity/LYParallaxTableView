//
//  XJBQTableViewCell.m
//  xiangjibaqi
//
//  Created by 李言 on 14/11/8.
//  Copyright (c) 2014年 ___李言___. All rights reserved.
//

#import "XJBQTableViewCell.h"
#import "UIImageView+WebCache.h"
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
        imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        contentLabel.font = [UIFont systemFontOfSize:12];
        contentLabel.numberOfLines = 0;
        btn =[UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn addTarget: self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundColor:[UIColor greenColor]];
        [self addSubview:imageView];
        [self addSubview:contentLabel];
        [self addSubview:btn];
        
        
    }
    return  self;
}


+(CGFloat)getCellHeight:(XJBQModel *)model{
     CGSize siez = [model.text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(300, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    return 10+40+siez.height+60+10;
    
}

-(void)setModel:(XJBQModel *)model{

    _model = model;
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.imageURl]];
    imageView.frame = CGRectMake(10, 10, 40, 40);
    
    contentLabel.text =model.text;
    
    CGSize siez = [model.text sizeWithFont:contentLabel.font constrainedToSize:CGSizeMake(300, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    contentLabel.frame = CGRectMake(10, CGRectGetMaxY(imageView.frame), SCREEN_WIDTH-20, siez.height);
    
    btn.frame =CGRectMake(10, CGRectGetMaxY(contentLabel.frame), 60, 60) ;
    
    
    

}

-(void)btnClick:(UIButton *)sender{
    
    
    if (self.btnClick) {
        self.btnClick();
    }
    

   


}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
