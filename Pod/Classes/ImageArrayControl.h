//
//  ImageArrayControl.h
//  GZL_Store
//
//  Created by 黄江昆 on 15/7/2.
//  Copyright (c) 2015年 黄江昆. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJAvatarBrowser.h"
#import "IPAddress.h"
#import "NetManager.h"
#import "UIImageView+ADD.h"
#import "MBProgressHUD+Add.h"



@interface ImageArrayControl : UIView


@property (nonatomic,strong) NSMutableArray * originalImage;//原有的图片
@property (nonatomic,strong) NSMutableArray * addImage;//添加的图片
@property (nonatomic,strong) NSMutableArray * delImage;//添加的图片
@property (nonatomic,assign) BOOL isEdit;//是否编辑
@property (nonatomic,strong) NSString * uid;//用户id

@property (nonatomic,strong) UIButton * Btn_Add;//添加图片控件

@property (nonatomic,strong) UIViewController * controller;//使用控件的controller

@property (nonatomic,strong) UIView * hideview;//模糊层

@property (nonatomic,strong) SJAvatarBrowser * brower;//图片放大容器

-(instancetype)initWithOrigin:(CGPoint)point;//初始化控件
-(instancetype)initWithOrigin:(CGPoint)point WithArray:(NSMutableArray *)arr;//初始化控件
@property (nonatomic,strong) void(^successBlock)(NSDictionary * dic);//上传图片成功block
@property (nonatomic, strong) void (^responseFail)(NSString *str);//上传图片失败
@property (nonatomic, strong) void (^requestFailError)(NSError *error);//没有网络情况
//-(UIButton *)GetAddBtn:(CGRect)rame;//初始化控件

@end
