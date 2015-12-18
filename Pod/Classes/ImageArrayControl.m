//
//  ImageArrayControl.m
//  GZL_Store
//
//  Created by 黄江昆 on 15/7/2.
//  Copyright (c) 2015年 黄江昆. All rights reserved.
//

#import "ImageArrayControl.h"
#import "Common.h"
#import "SJAvatarBrowser.h"
#import "Common.h"
#import "UIImageView+WebCache.h"
#import "UIImageViewWithUrl.h"

@interface ImageArrayControl()<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,DelImageDelegate>

@end


@implementation ImageArrayControl

static const int HEIGHT_WIDTH =45;//图片的宽高
static const int  COUNT = 5;//上传的图片的个数
//static const int  SPACE = 5;//图片之间的间隔
static const int  HEIGHT_WIDTH_SPACE = 50;//图片的宽高加上间隔

/** 初始化控件*/

-(instancetype)initWithOrigin:(CGPoint)point
{
    self = [super init];
    if (self)
    {
        [self MyInit:point];
        [self registerBlock];
    }
    return self;
}
//带图片的初始化
-(instancetype)initWithOrigin:(CGPoint)point WithArray:(NSMutableArray *)arr
{
    self = [super init];
    if (self)
    {
        [self MyInit:point WithArray:arr];
        [self registerBlock];
    }
    return self;
}
/**
 *  初始化操作
 */
-(instancetype)MyInit:(CGPoint)point
{
    CGFloat height = HEIGHT_WIDTH;
    CGFloat width = HEIGHT_WIDTH;
    self.frame = CGRectMake(point.x, point.y,width, height);
    [self addSubview:[self Btn_Add:CGRectMake(0, 0, HEIGHT_WIDTH, HEIGHT_WIDTH)]];
    return self;
}
//待图片的初始化操作
-(instancetype)MyInit:(CGPoint)point WithArray:(NSMutableArray *)arr
{
    CGFloat height = HEIGHT_WIDTH;
    CGFloat width = HEIGHT_WIDTH;
    [self addSubview:[self Btn_Add:CGRectMake(0, 0, HEIGHT_WIDTH, HEIGHT_WIDTH)]];
    self.Btn_Add.tag = 1;
    if (arr.count>0) {
        for (int i = 0 ; i<arr.count; i++) {
            width = width + HEIGHT_WIDTH_SPACE;
            UIImageViewWithUrl * view = [[UIImageViewWithUrl alloc] init];
            [view setImageWithPath:[NSString stringWithFormat:@"%@%@",IWHttpAddress,[NSURL URLWithString:[[arr objectAtIndex:i] substringFromIndex:1]]]];
            view.urlStr = [arr objectAtIndex:i];
            [self.originalImage addObject:[arr objectAtIndex:i]];
            [self ChangeView:view];
            [self HideAddBtn];
        }
    }
    self.frame = CGRectMake(point.x, point.y,width, height);
    return self;
}
//初始化添加图片button
-(UIButton *)Btn_Add:(CGRect)frame
{
    if (!self.Btn_Add) {
        self.Btn_Add = [[UIButton alloc] initWithFrame:frame];
        self.Btn_Add.tag = 1;//设置tag
        [self.Btn_Add setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        [self.Btn_Add addTarget:self action:@selector(AddBtn_Click) forControlEvents:UIControlEventTouchDown];
    }
    return self.Btn_Add;
    
}

/**
 *  图片添加处理事件
 */
-(void)AddBtn_Click
{
    self.controller = [self getCurrentVC];
    [self openSwitch];
    
}
- (void)openSwitch
{
    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:@"选择打开方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开相册",@"打开相机", nil];
    [action showInView:self.controller.view];
}

#pragma mark - delegate
//操作方式选择
- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self openPicture];
            break;
        case 1:
            [self openCamera];
            break;
        case 2:
            break;
        default:
            break;
    }
}
//完成图片选择
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    NSData * data = UIImageJPEGRepresentation(image, 0.3f);
    UIImage * compressimage = [UIImage imageWithData:data];
   
    [picker dismissViewControllerAnimated:YES completion:nil];
    [MBProgressHUD showHUDAddedTo:self.controller.view animated:YES];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:_uid,@"uid", nil];
    [NetManager postRequestWithUrl:UploadImage_URL aDic:dic Image:compressimage Blcok:_successBlock blockFail:_responseFail blockError:_requestFailError];
    
}
#pragma mark - private
//实现删除图片方法
-(void)DeleteImage:(NSInteger)tag
{
    
    for (UIView * a in self.subviews) {
        if (a.tag==tag) {
            NSLog(@"删除成功-----%ld",(long)tag);
            [a removeFromSuperview];
             UIImageViewWithUrl * image = (UIImageViewWithUrl *)a;
            if (_isEdit) {
                if ([_originalImage containsObject:image.urlStr]) {
                    [self.originalImage removeObject:image.urlStr];
                    [self.delImage addObject:image.urlStr];
                }
                else
                {
                    [self.addImage removeObject:image.urlStr];
                }
            }
            else
            {
                [self.addImage removeObject:image.urlStr];
            }
            if ((_addImage.count+_originalImage.count)<COUNT) {
                self.Btn_Add.hidden = false;
            }
        }
        if (a.tag>tag) {
            CGRect temp = a.frame;
            temp.origin.x = temp.origin.x - HEIGHT_WIDTH_SPACE;
            a.frame = temp;
            a.tag--;
        }
    }
    
}

//打开照相机
- (void)openCamera
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    ipc.delegate = self;
    ipc.allowsEditing = YES;
    [self.controller presentViewController:ipc animated:YES completion:nil];
}
//打开相册
- (void)openPicture
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = YES;
    picker.delegate =  self;
    [self.controller presentViewController:picker animated:YES completion:nil];
}
/**
 *  改变图片显示位置
 */
-(void)ChangeView:(UIImageView *)img
{
   
    img.frame = _Btn_Add.frame;
    img.tag = self.Btn_Add.tag;
    self.Btn_Add.tag ++;
    [img setUserInteractionEnabled:YES];
    [img addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(WatchBigImage:)]];
    
    CGFloat width = HEIGHT_WIDTH_SPACE;
    CGRect temp = self.frame;
    temp.size.width = temp.size.width + width;
    self.frame = temp;
    
    CGRect temp2 = _Btn_Add.frame;
    temp2.origin.x = temp2.origin.x + width;
    _Btn_Add.frame = temp2;
    [self addSubview:img];
    
}
/**
 *  隐藏添加按钮
 */
-(void)HideAddBtn
{
    if ((_originalImage.count+_addImage.count)==COUNT) {
        _Btn_Add.hidden = true;
    }
}
/**
 *  查看大图
 */

-(void)WatchBigImage:(UITapGestureRecognizer *)gestureRecognizer
{
    UIImageView *img=(UIImageView *)[gestureRecognizer view];
    [self.brower showImage:img];
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}
//注册block
-(void)registerBlock
{
    __block ImageArrayControl * blockself = self;
    self.successBlock = ^(NSDictionary * dic)
    {
        [MBProgressHUD hideHUDForView:blockself.controller.view animated:YES];
        NSString * path = dic[@"data"];
        [blockself.addImage addObject:path];
        UIImageViewWithUrl * img = [[UIImageViewWithUrl alloc]init];
        img.urlStr = path;
        [img setImageWithPath:[NSString stringWithFormat:@"%@%@",IWHttpAddress,[path substringFromIndex:1]]];
        [blockself ChangeView:img];
        [blockself HideAddBtn];
    };
    self.responseFail = ^(NSString * dic)
    {
        [MBProgressHUD hideHUDForView:blockself.controller.view animated:YES];
        [MBProgressHUD showSuccess:@"上传失败" toView:blockself.controller.view];
    };
    self.requestFailError = ^(NSError * error)
    {
        [MBProgressHUD hideHUDForView:blockself.controller.view animated:YES];
        [MBProgressHUD showSuccess:@"无法连接网络" toView:blockself.controller.view];
    };
}

#pragma mark - getter
//原有图片
-(NSMutableArray *)originalImage
{
    if (!_originalImage) {
        _originalImage = [[NSMutableArray alloc]init];
    }
    return _originalImage;
}
//新增图片
-(NSMutableArray *)addImage
{
    if (!_addImage) {
        _addImage = [[NSMutableArray alloc] init];
    }
    return _addImage;
}
//删除图片
-(NSMutableArray *)delImage
{
    if (!_delImage) {
        _delImage = [[NSMutableArray alloc]init];
    }
    return _delImage;
}
//初始化阴影层
-(UIView *)hideview
{
    if (!_hideview) {
        _hideview = [[UIView alloc] init];
        _hideview.backgroundColor = [UIColor lightGrayColor];
        _hideview.alpha = 0.8;
    }
    return _hideview;
}
//初始化图片放大容器
-(SJAvatarBrowser *)brower
{
    if (!_brower) {
        _brower = [[SJAvatarBrowser alloc]init];
        _brower.delegate = self;
    }
    return _brower;
}
@end
