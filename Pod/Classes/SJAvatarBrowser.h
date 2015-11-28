//
//  SJAvatarBrowser.h
//  GZL_Store
//
//  Created by 黄江昆 on 15/7/6.
//  Copyright (c) 2015年 黄江昆. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@protocol DelImageDelegate <NSObject>

-(void)DeleteImage:(NSInteger)tag;

@end



@interface SJAvatarBrowser : NSObject



@property (nonatomic,strong) UITapGestureRecognizer * tap;//手势

/**
 
 *	@brief	浏览头像
 
 *
 
 *	@param oldImageView 头像所在的imageView
 
 */

-(void)showImage:(UIImageView *)avatarImageView;



@property (nonatomic,weak) id<DelImageDelegate> delegate;



@end