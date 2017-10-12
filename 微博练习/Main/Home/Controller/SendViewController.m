//
//  SendViewController.m
//  微博练习
//
//  Created by Silver on 15/4/16.
//  Copyright (c) 2015年 Silver. All rights reserved.
//

#import "SendViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "ThemeButton.h"
#import "MyDataService.h"
#import "AFHTTPRequestOperation.h"

@interface SendViewController ()
{
    UITextView *_textView;
    UIView *_editorView;
    
    //选择发送图片的缩略图
    ZoomingImgView *_zoomImage;    
    //要发送的微博图片
    UIImage *_sendImg;
    
    //加载位置
    UIActivityIndicatorView *_activityView;
    UILabel *_locationLabel;
    CLLocationManager *_locatioManager;
    CLLocation *_location;
}

@end

@implementation SendViewController

- (void)dealloc
{
    NSLog(@"SendViewController 销毁了");
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        //监听键盘弹出的通知：通知名：UIKeyboardWillShowNotification
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //弹出键盘
    [_textView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //收起键盘
    [_textView resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _creatNavgationView];
    
    [self _loadEditorView];
}

//1.创建导航栏上的视图
- (void)_creatNavgationView{
    
    //取消按钮
    ThemeButton *closeButton = [[ThemeButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    closeButton.normalImageName = @"button_icon_close.png";
    [closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    [self.navigationItem setLeftBarButtonItem:closeItem];
    
    //发送按钮
    ThemeButton *sendButton = [[ThemeButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    sendButton.normalImageName = @"button_icon_ok.png";
    [sendButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *sendItem = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
    [self.navigationItem setRightBarButtonItem:sendItem];

}

//2.创建编辑工具栏的视图
- (void)_loadEditorView{
    
    //设置self.view视图的起点位置，UIRectEdgeNone 从导航栏下沿开始
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //1.创建输入框视图
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    _textView.font = [UIFont systemFontOfSize:16.0f];
    _textView.backgroundColor = [UIColor orangeColor];
    _textView.editable = YES;
    _textView.returnKeyType = UIReturnKeySend;
    //弹出键盘
    [_textView becomeFirstResponder];
    _textView.delegate = self;
    [self.view addSubview:_textView];
    
    //2.创建编辑工具栏
    _editorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 55)];
    _editorView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_editorView];
    
    //3.创建编辑按钮
    NSArray *imgs = @[
                      @"compose_toolbar_1.png",
                      @"compose_toolbar_4.png",
                      @"compose_toolbar_3.png",
                      @"compose_toolbar_5.png",
                      @"compose_toolbar_6.png"
                      ];
    
    CGFloat itemWidth = kScreenWidth/5;
    for (int i=0; i<imgs.count; i++) {
        
        ThemeButton *button = [[ThemeButton alloc] initWithFrame:CGRectMake(15+itemWidth*i, 20, 40, 33)];
        button.normalImageName = imgs[i];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 10+i;
        [_editorView addSubview:button];
    }

}

//请求网络，发送微博
- (void)sendWeibo:(NSString *)text{
    
    [self closeAction];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:text forKey:@"status"];
    __weak typeof(self) weakSelf = self;
    
    //判断是否定位
    if (_location != nil) {
        CLLocationCoordinate2D coordinate = _location.coordinate;
        NSString *lat = [@(coordinate.latitude) stringValue];
        NSString *lon = [NSString stringWithFormat:@"%f",coordinate.longitude];
        
        [params setObject:lat forKey:@"lat"];
        [params setObject:lon forKey:@"long"];
    }
    
    
    //取得选中的照片数据
    if (_sendImg != nil) {
        
//        //UIImage ---> NSData
//        NSData *sendData = UIImageJPEGRepresentation(_sendImg, 1);
//        NSDictionary *fileDatas = @{@"pic":sendData};
//
//        
//        //block-->self--->view
//        //带图片
//       [MyDataService requestURL:@"statuses/upload.json" httpMethod:@"POST" params:params fileDatas:fileDatas completion:^(id result) {
//            
////            [self showStatusTip:@"发送成功" show:NO operation:nil];
//            
//        }];
//        
//        //提示正在发送
////        [super showStatusTip:@"正在发送..." show:YES operation:operation];
        
        
        
    } else {
        //不带图片
        
        [MyDataService requestURL:@"statuses/update.json" httpMethod:@"POST" params:params fileDatas:nil completion:^(id result) {
            
            [weakSelf hideHUD:@"发送成功"];
            [weakSelf performSelector:@selector(closeAction) withObject:nil afterDelay:1.5];
            
        }];
    }
}

//关闭当前控制器
- (void)closeAction {
    
    //NSLog(@"%@",self.mm_drawerController);
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        //关闭之后，让MMDrawer显示中间控制器
        //NSLog(@"%@",self.mm_drawerController);
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if ([window.rootViewController isKindOfClass:[MMDrawerController class]]) {
            
            MMDrawerController *mmDrawer = (MMDrawerController *)window.rootViewController;
            
            //关闭右滑
            [mmDrawer closeDrawerAnimated:YES completion:NULL];
            
        }
    }];
    
}

- (void)sendAction{
    
    NSString *text = _textView.text;
    
    NSString *error = nil;
    if (text.length == 0) {
        error = @"微博内容为空";
    }
    else if(text.length > 140) {
        error = @"微博内容大于140字符";
    }
    
    if (error != nil) {
        
        [[[UIAlertView alloc] initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    
    
    [self sendWeibo:text];

}

- (void)buttonAction:(ThemeButton *)button{
    
    if (button.tag == 10) {  //选择照片
        [self selectImage];
    }
    else if(button.tag == 11) {  //选择话题
        
    }
    //...
    else if(button.tag == 13) {  //定位
        [self location];
    }

}


//选择照片
- (void)selectImage {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    [actionSheet showInView:self.view];
    
}



- (void)location {
    
    if (_activityView == nil) {
        //1.创建视图
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityView.frame = CGRectMake(10, 0, 15, 15);
        [_editorView addSubview:_activityView];
        
        //显示位置的Label
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(_activityView.right+5, 0, kScreenWidth-20, 15)];
        _locationLabel.backgroundColor = [UIColor clearColor];
        _locationLabel.font = [UIFont systemFontOfSize:14];
        [_editorView addSubview:_locationLabel];
    }
    
    //2.开始定位
    //iOS8 之后定位：
    //1.[_locatioManager requestWhenInUseAuthorization]; //请求授权
    //2.在Info.plist文件还要加上NSLocationWhenInUseUsageDescription这个key,Value可以为空
    
    if (_locatioManager == nil) {
        _locatioManager = [[CLLocationManager alloc] init];
        
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            [_locatioManager requestWhenInUseAuthorization];
        }
        
        
        //设置定位的精准度
        [_locatioManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
        _locatioManager.delegate = self;
    }
    
    //开始定位
    [_locatioManager startUpdatingLocation];
    //显示正在定位的加载
    [_activityView startAnimating];
    
}

#pragma mark - UIActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    UIImagePickerControllerSourceType sourceType;
    
    if (buttonIndex == 0) {  //拍照
        
        BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (!isCamera) {
            
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"此设备没有摄像头" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            return;
        }
        
        sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else if(buttonIndex == 1) {  //选择相册
        sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
    }
    else {
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = sourceType;
    imagePicker.delegate = self;
    
    [self presentViewController:imagePicker animated:YES completion:NULL];
    
}

#pragma mark - UIImagePickerController delegate
//选择、拍照 完成的协议方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    //1.关闭模态控制器
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    //2.取得选中的照片
    //    NSLog(@"%@",info);
    UIImage *img = info[UIImagePickerControllerOriginalImage];
    
    if (_zoomImage == nil) {
        _zoomImage = [[ZoomingImgView alloc] initWithFrame:CGRectMake(10, 20, 30, 30)];
        _zoomImage.delegate = self;
        [_editorView addSubview:_zoomImage];
        
        //4.挪动编辑按钮的位置
        for (int i=0; i<4; i++) {
            
            NSInteger tag = 10+i;
            UIButton *button = (UIButton *)[_editorView viewWithTag:tag];
            
            int x = 30 - i*5;
            
            button.transform = CGAffineTransformTranslate(button.transform, x, 0);
            
        }
    }
    
    _zoomImage.image = img;
    _sendImg = img;
}

#pragma mark - ZoomingImgView delegate
//缩略图将要放大
- (void)imageWillZoomIn:(ZoomingImgView *)imageView {
    
    //收起键盘
    [_textView resignFirstResponder];
    
}

- (void)imageWillZoomOut:(ZoomingImgView *)imageView {
    [_textView becomeFirstResponder];
}

#pragma mark - 键盘弹出的通知
- (void)keyboardWillShow:(NSNotification *)notification {
    
    //    NSLog(@"%@",notification.userInfo);
    
    NSValue *bounds = notification.userInfo[@"UIKeyboardBoundsUserInfoKey"];
    //    NSLog(@"%@",UIKeyboardBoundsUserInfoKey);
    
    CGRect boundRect = [bounds CGRectValue];
    
    //取得键盘的高度
    CGFloat height = CGRectGetHeight(boundRect);
    
    //重新布局视图垂直方向的frame
    _textView.height = kScreenHeight-64-_editorView.height-height;
    _editorView.top = _textView.bottom;
    
}


@end
