//
//  SJAvatarBrowser.m
//  GZL_Store
//
//  Created by 黄江昆 on 15/7/6.
//  Copyright (c) 2015年 黄江昆. All rights reserved.
//

#import "SJAvatarBrowser.h"

#import <UIKit/UIKit.h>

#import "Common.h"

static CGRect oldframe;

@implementation SJAvatarBrowser

-(void)showImage:(UIImageView *)avatarImageView{
    
    UIImage *image=avatarImageView.image;
    
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    oldframe=[avatarImageView convertRect:avatarImageView.bounds toView:window];
    
    backgroundView.backgroundColor=[UIColor blackColor];
    
    backgroundView.alpha=0;
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:oldframe];
    
    imageView.image=image;
    
    imageView.tag=1;
    
    
    
    //添加删除按钮
    
    UIButton *btn = [[UIButton alloc] init];
    
    
    
    CGRect rect;
    
    rect.size.height = 40;
    
    rect.size.width = 40;
    
    rect.origin.y = ScreenHeight-40;
    
    rect.origin.x = (ScreenWidth-40)/2;
    
    
    
    btn.frame = rect;
    
//    [btn setBackgroundColor:[UIColor whiteColor]];
//    
//    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    
    btn.tag = avatarImageView.tag;
    
    [btn addTarget:self action:@selector(delImage:) forControlEvents:UIControlEventTouchDown];//添加删除事件
    
    
    
    [backgroundView addSubview:imageView];
    
    [backgroundView addSubview:btn];
    
    [window addSubview:backgroundView];
    
    
    
    self.tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    
    [backgroundView addGestureRecognizer: self.tap];
    
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        
        backgroundView.alpha=1;
        
    } completion:^(BOOL finished) {
        
        
        
    }];
    
}

-(void)hideImage:(UITapGestureRecognizer*)tap{
    
    UIView *backgroundView=tap.view;
    
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        imageView.frame=oldframe;
        
        backgroundView.alpha=0;
        
    } completion:^(BOOL finished) {
        
        [backgroundView removeFromSuperview];
        
    }];
    
}

/**
 
 *  删除图片
 
 */

-(void)delImage:(UIButton *)btn

{
    
    [self.delegate DeleteImage:btn.tag];
    
    [self hideImage:self.tap];
    
}

@end
