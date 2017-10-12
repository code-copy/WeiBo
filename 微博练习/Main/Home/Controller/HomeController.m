//
//  HomeController.m
//  微博练习
//
//  Created by Silver on 15/4/2.
//  Copyright (c) 2015年 Silver. All rights reserved.
//

#import "HomeController.h"
#import "AppDelegate.h"
#import "WeiboModel.h"
#import "WeiboTableView.h"
#import "MJRefresh.h"
#import "ThemeImageView.h"
#import "ThemeLable.h"
#import "ThemeManager.h"
#import <AudioToolbox/AudioToolbox.h>
#import "UIViewController+MMDrawerController.h"


@interface HomeController ()
{
    WeiboTableView *_tableView;
}

@end

@implementation HomeController

-(void)dealloc{
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//当前控制器视图不显示
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //关闭
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    
}

//当前控制器视图即将显示
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //打开
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[WeiboTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 49) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];

    __weak typeof(self) weakSelf = self;
    
    //2.下拉刷新 播放Gif动画
    [_tableView addGifHeaderWithRefreshingBlock:^{
        [weakSelf _loadNewWeibo];
    }];
    
    NSMutableArray *imgs = [NSMutableArray array];
    for (int i=0; i<6; i++) {
        NSString *imgName = [NSString stringWithFormat:@"%d.jpg",i+1];
        UIImage *img = [UIImage imageNamed:imgName];
        [imgs addObject:img];
    }
    
    //设置闲置状态显示的图片
    NSArray *firstImg = [imgs subarrayWithRange:NSMakeRange(0, 1)];
    [_tableView.gifHeader setImages:firstImg forState:MJRefreshHeaderStateIdle];
    
    //设置正在刷新播放的图片
    [_tableView.gifHeader setImages:imgs forState:MJRefreshHeaderStateRefreshing];
    
    SinaWeibo *sinaweibo = [self sinaweibo];
   
    //判断是否授权
    if (!sinaweibo.isAuthValid) {
        //没有授权则登陆
        [sinaweibo logIn];
    } else {

        //开始下拉刷新
        //[self.tableView.gifHeader beginRefreshing];
        
        _tableView.hidden = YES;
        
        //        [self showLoading:YES];
        [super showHUD:@"正在加载..."];
        [self _loadNewWeibo];

    }
    
    //3.上拉刷新，加载下一页
    [_tableView addLegendFooterWithRefreshingBlock:^{
        
        //NSLog(@"上拉...");
        [weakSelf _loadMoreWeiData];
        
    }];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WeiboLogOut) name:@"weiboLogOut" object:nil];
}

//1.加载新微博数据
- (void)_loadNewWeibo {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:@"25" forKey:@"count"];
    
    //1.取得第一条微博ID，用于加载未读微博数据
    WeiboModel *topWeibo = [self.data firstObject];
    
    NSString *weiboID = [topWeibo.weiboId stringValue];
    
    if (weiboID.length != 0) {
        /**
         *  since_id	false	int64	若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
         */
        [params setObject:weiboID forKey:@"since_id"];
    }
    
    SinaWeiboRequest *request = [self.sinaweibo requestWithURL:@"statuses/home_timeline.json"
                                                        params:params
                                                    httpMethod:@"GET"
                                                      delegate:self];
    request.tag = 100;
}

- (void)_loadMoreWeiData {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:@"25" forKey:@"count"];
    
    WeiboModel *lastWeibo = [self.data lastObject];
    if (lastWeibo == nil) {
        return;
    }
    
    /*
     max_id	false	int64	若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
     */
    NSString *lastID = [lastWeibo.weiboId stringValue];
    [params setObject:lastID forKey:@"max_id"];
    
    
    SinaWeiboRequest *request = [self.sinaweibo requestWithURL:@"statuses/home_timeline.json"
                                                        params:params
                                                    httpMethod:@"GET"
                                                      delegate:self];
    request.tag = 200;
}

//显示加载新微博的数量
- (void)_showNewWeiboCount:(NSInteger)count {
    
    //1.创建视图
    ThemeImageView *bageImg = (ThemeImageView *)[self.view viewWithTag:100];
    if (bageImg == nil) {
        bageImg = [[ThemeImageView alloc] initWithFrame:CGRectMake(5, -40, kScreenWidth-10, 40)];
        bageImg.imageName = @"timeline_notify.png";
        bageImg.tag = 100;
        [self.view addSubview:bageImg];
        
      
        ThemeLable *bageLabel = [[ThemeLable alloc] initWithFrame:bageImg.bounds];
        bageLabel.backgroundColor = [UIColor clearColor];
        bageLabel.textAlignment = NSTextAlignmentCenter;
        bageLabel.colorName = @"Timeline_Notice_color";
        bageLabel.tag = 200;
        [bageImg addSubview:bageLabel];
    }
    
    //2.显示数据
    ThemeLable *bageLabel = (ThemeLable *)[bageImg viewWithTag:200];
    NSString *bageText = nil;
    if (count > 0) {
        bageText = [NSString stringWithFormat:@"%ld条新微博",count];
    } else {
        bageText = @"没有新微博数据";
    }
    bageLabel.text = bageText;
    
    //3.显示动画
    [UIView animateWithDuration:0.6 animations:^{
        
        //动画1：向下移动
        bageImg.transform = CGAffineTransformMakeTranslation(0, 40+64+5);
        
    } completion:^(BOOL finished) {
        
        //动画2：向下移动
        [UIView animateWithDuration:0.6 animations:^{
            
            //设置延迟执行的动画时间
            [UIView setAnimationDelay:1];
            
            bageImg.transform = CGAffineTransformIdentity;
        }];
    }];
    
    //4.播放提示声音
    if (count > 0) {
        
        NSString *filepath = [[NSBundle mainBundle] pathForResource:@"msgcome" ofType:@"wav"];
        NSURL *url = [NSURL fileURLWithPath:filepath];
        
        //1.将声音文件注册成系统声音
        SystemSoundID soundID;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
        
        //2.播放系统声音
        AudioServicesPlaySystemSound(soundID);
    }
}

- (SinaWeibo *)sinaweibo{
    
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return appdelegate.sinaWeibo;
}

//数据请求失败
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error{
    
    NSLog(@"网络接口请求失败：request error = %@",error);
}
//数据请求成功
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result{
    
    NSArray *statuses = [result objectForKey:@"statuses"];

    NSMutableArray *weibos = [NSMutableArray arrayWithCapacity:statuses.count];
    
    for (NSDictionary *weiboJson in statuses) {
        
        WeiboModel *weiboModel = [[WeiboModel alloc] initWithDataDic:weiboJson];
        
        [weibos addObject:weiboModel];

    }
    
    if (request.tag == 100) {  //1.下拉刷新的数据
        //        [self showLoading:NO];
        
        [self hideHUD:@"加载完成"];
        //        [self hideHUD:nil];
        _tableView.hidden = NO;
        
        //        NSLog(@"下拉加载...");
        
        [weibos addObjectsFromArray:self.data];
        self.data = weibos;
        
        //将weibos数组数据交给UITableView展示数据
        _tableView.data = self.data;
        [_tableView reloadData];
        
        //结束下拉刷新
        [_tableView.header endRefreshing];
        
        //显示加载新微博数量的提示
        [self _showNewWeiboCount:statuses.count];
        
        //隐藏未读数图标
        //    [对象 功能];
        //[self.tabBarController 隐藏未读图片]
        
//        MainController *mainCtrl = (MainController *)self.tabBarController;
//        [mainCtrl hideBadge];
        
    } else if(request.tag == 200){  //2.上拉刷新的数据
        if (weibos.count > 0) {
            [weibos removeObjectAtIndex:0];
        }
        
        [self.data addObjectsFromArray:weibos];
        _tableView.data = self.data;
        [_tableView reloadData];
        
        //停止上拉刷新
        [_tableView.footer endRefreshing];
        if (weibos.count == 0) {
            //没有更多数据，隐藏上拉视图
            _tableView.footer.hidden = YES;
        }
    }
}

//登出按钮
- (IBAction)sinaLogOut:(UIButton *)sender {
    
    //[self.sinaweibo logOut];
}
//登录按钮
- (IBAction)sinaLogIn:(UIButton *)sender {
        
    [self.sinaweibo logIn];
}
//登出按钮
- (void)WeiboLogOut{
    //[self.sinaweibo logOut];
}
@end
