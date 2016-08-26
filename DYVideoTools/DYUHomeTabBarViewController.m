//
//  DYUHomeTabBarViewController.m
//  DYVideoTools
//
//  Created by qiyun on 16/8/26.
//  Copyright © 2016年 qiyun. All rights reserved.
//

#import "DYUHomeTabBarViewController.h"
#import "DYUHomeViewController.h"
#import "DYUHomeNavigationController.h"
#import "DYUToolsView.h"
#import "DYUToolViewController.h"

@interface DYUHomeTabBarViewController ()

 <UITabBarControllerDelegate,DYNToolsViewDelegate>

@property (nonatomic,weak) UIViewController *lastViewController;
@property (nonatomic,strong) DYUToolsView *toolsView;
@property (nonatomic,strong) DYUToolViewController *toolVC;

@end

@implementation DYUHomeTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 添加所有的子控制器
    [self setupAllViewController];

    // 设置tabBar上按钮的内容
    [self setupAllTabBarButton];
    
    // 添加视频采集按钮
    [self addCameraButton];
    
    // 设置顶部tabBar背景图片
    [self setupTabBarBackgroundImage];
    
    // 设置代理 监听tabBar上按钮点击
    self.delegate = self;
    
    _lastViewController = self.childViewControllers.firstObject;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (DYUToolsView *)toolsView{
    
    if (!_toolsView) {
        
        _toolsView = [[DYUToolsView alloc] init];
        _toolsView.itemImages = @[[UIImage imageNamed:DY_camera_tools_camera],[UIImage imageNamed:DY_camera_tools_upload]];
        _toolsView.delegate = self;
    }
    return _toolsView;
}



#pragma mark ---- <点击了CameraBtn>
- (void)clickCameraBtn {
    
    _toolVC = [[DYUToolViewController alloc] init];
    
    UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *view = [[UIVisualEffectView alloc] initWithEffect:beffect];
    view.frame = _toolVC.view.bounds;
    [_toolVC.view addSubview:view];
    
    [_toolVC.view addSubview:self.toolsView];
    
    //__unsafe_unretained DYUToolViewController *weakSelf = _toolVC;
    self.toolsView.dismissHandler = ^(){
        
        //[weakSelf dismissViewControllerAnimated:NO completion:nil];
        
        DYUHomeTabBarViewController *homeVC = [[DYUHomeTabBarViewController alloc] init];
        UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        window.rootViewController = homeVC;
    };

    [self presentViewController:_toolVC animated:NO completion:^{
        
        [self.toolsView show];
    }];
}


#pragma mark ---- <设置tabBar背景图片>

- (void)setupTabBarBackgroundImage {
    
    UIImage *image = [UIImage imageNamed:DY_Home_tabbar_background];
    
    CGFloat top = 40; // 顶端盖高度
    CGFloat bottom = 40 ; // 底端盖高度
    CGFloat left = 100; // 左端盖宽度
    CGFloat right = 100; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    
    // 指定为拉伸模式，伸缩后重新赋值
    UIImage *TabBgImage = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    self.tabBar.backgroundImage = TabBgImage;
    
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
}


#pragma mark ---- <添加视频采集按钮>
- (void)addCameraButton {
    
    UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [cameraBtn setImage:[UIImage imageNamed:DY_Home_tabbar_camera_normal] forState:UIControlStateNormal];
    [cameraBtn setImage:[UIImage imageNamed:DY_Home_tabbar_camera_select] forState:UIControlStateHighlighted];
    
    // 自适应,自动根据按钮图片和文字计算按钮尺寸
    [cameraBtn sizeToFit];
    
    cameraBtn.center = CGPointMake(self.tabBar.frame.size.width * 0.5, self.tabBar.frame.size.height * 0.5 + 5);
    [cameraBtn addTarget:self action:@selector(clickCameraBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tabBar addSubview:cameraBtn];
    
}

#pragma mark ---- <设置tabBar上按钮的内容>
- (void)setupAllTabBarButton {
    
    DYUHomeViewController *cameraVc = self.childViewControllers[0];
    cameraVc.tabBarItem.enabled = NO;
    UIEdgeInsets cameraInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    cameraVc.tabBarItem.imageInsets = cameraInsets;
    
    //隐藏阴影线
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
}



//自定义TabBar高度
- (void)viewWillLayoutSubviews {
    
    CGRect tabFrame = self.tabBar.frame;
    tabFrame.size.height = 55;
    tabFrame.origin.y = self.view.frame.size.height - 55;
    self.tabBar.frame = tabFrame;
}

#pragma mark ---- <添加所有的子控制>
- (void)setupAllViewController {

    DYUHomeViewController *cameraVc = [[DYUHomeViewController alloc] init];    
    DYUHomeNavigationController *cameraNav = [[DYUHomeNavigationController alloc] initWithRootViewController:cameraVc];
    
    [self addChildViewController:cameraNav];
}


#pragma mark    -   delegate    

- (void)viewDidSelectedOfToolsIndex:(NSInteger)index{
    
    DYLog(@"点击下标。。。 %ld",(long)index);
    
    if (_toolVC) _toolVC.clickIndex(index);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
