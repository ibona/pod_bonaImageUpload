//
//  ImageArrayControl.h
//  GZL_Store
//
//  Created by 黄江昆 on 15/7/2.
//  Copyright (c) 2015年 黄江昆. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJAvatarBrowser.h"

@interface ImageArrayControl : UIView

@property (nonatomic,strong) NSMutableArray * ImageArray;//图片集合

@property (nonatomic,strong) NSMutableArray * IdArray;//图片id的集合

@property (nonatomic,strong) UIButton * Btn_Add;//添加图片控件

@property (nonatomic,strong) UIViewController * controller;//使用控件的controller

@property (nonatomic,strong) UIView * hideview;//模糊层

@property (nonatomic,strong) SJAvatarBrowser * brower;//图片放大容器

-(instancetype)initWithOrigin:(CGPoint)point;//初始化控件
-(instancetype)initWithOrigin:(CGPoint)point WithArray:(NSMutableArray *)arr;//初始化控件
//-(UIButton *)GetAddBtn:(CGRect)rame;//初始化控件

@end
