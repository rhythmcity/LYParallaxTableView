//
//  LYTool.h
//  xiangjibaqi
//
//  Created by 李言 on 14/12/3.
//  Copyright (c) 2014年 ___李言___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYTool : NSObject

@end

@interface NSString (md5)

/*!
 *	@brief	计算md5值
 *
 *	@return	md5字符串
 */
-(NSString *) md5HexDigest;
@end