//
//  DYUVideoCollectionViewController.m
//  DYVideoTools
//
//  Created by qiyun on 16/8/26.
//  Copyright © 2016年 qiyun. All rights reserved.
//

#import "DYUVideoCollectionViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/PHAssetChangeRequest.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVKit/AVPlayerViewController.h>

@class DYUVideoRecordImageView;
@interface DYUVideoCollectionViewController ()<AVCaptureFileOutputRecordingDelegate,UIVideoEditorControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) AVCaptureMovieFileOutput  *videoOutput;
@property (nonatomic, strong) UIImageView   *toolImageView;
@property (nonatomic, strong) AVPlayerViewController    *avMoviePlayer;
@property (nonatomic, strong) DYUVideoRecordImageView   *recordImageView;
@end

@implementation DYUVideoCollectionViewController

#pragma mark    -   set/get method

#pragma mark    -   video play

/**
 *  AVPlayerViewController视频播放器
 *
 *  @discussion AVPlayerViewController不支持编辑模式，可以自定制的空间很少；如果自定义的话，需要针对player层进行设置；
 *
 *  --->        iOS9之后MPMoviePlayer已经被此控制器替代，这是苹果目前为止唯一兼容ios9之后的播放器，缺陷是最低支持iOS8
 */
- (AVPlayerViewController *)avMoviePlayer{
    
    if (!_avMoviePlayer) {
        
        _avMoviePlayer = [[AVPlayerViewController alloc] init];
        _avMoviePlayer.view.frame = CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT/2);
        _avMoviePlayer.player = [AVPlayer playerWithURL:
                                 [NSURL fileURLWithPath:[[self createFile]
                                                         stringByAppendingString:[NSString stringWithFormat:@"/%@.mp4",@"我的视频"]]]];
        
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    return _avMoviePlayer;
}

#pragma mark    -   video recording

/**
 *  视频录制（视频图像捕捉）
 *
 *  @discussion 需要创建视频捕捉器的对象，及截取容器（视、音频输入，视、音频输出）,然后对图像进行输出保存
 *
 *  保存后的文件可以自定义视频格式，进行读取操作
 */
- (AVCaptureMovieFileOutput *)videoOutput{
    
    if (!_videoOutput) {
        
        _videoOutput = [[AVCaptureMovieFileOutput alloc] init];
        
        AVCaptureSession *session = [[AVCaptureSession alloc] init];
        AVCaptureDevice *device;    /* ios9之后，次对象不支持实例化，只做对象申请地址空间，不做引用 */
        AVCaptureStillImageOutput *imageOutput = [[AVCaptureStillImageOutput alloc] init];
        
        NSArray *devices = [AVCaptureDevice devices];
        NSArray *audioCaptureDevice = [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio];  /* 媒体类型 */
        AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioCaptureDevice.firstObject error:nil]; /* 视频输出类型实例化 */
        
        for (AVCaptureDevice *aDevice in devices){
            
            if (aDevice.position == AVCaptureDevicePositionBack) {
                device = aDevice;
            }
        }
        
        AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        [session addInput:videoInput];
        [session addInput:audioInput];
        [session addOutput:imageOutput];    /* save images */
        [session addOutput:_videoOutput];
        
        AVCaptureVideoPreviewLayer *videoPlayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
        videoPlayer.frame = CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT* 0.6);
        videoPlayer.videoGravity = AVLayerVideoGravityResizeAspectFill; /* 视频边界 */
        [self.view.layer addSublayer:videoPlayer];
        
        [session startRunning];
    }
    return _videoOutput;
}

- (DYUVideoRecordImageView *)recordImageView{
    
    if (!_recordImageView) {
        
        _recordImageView = [[DYUVideoRecordImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT * 0.6 , SCREEN_WIDTH, SCREEN_HEIGHT * 0.3)];
        [_recordImageView setUserInteractionEnabled:YES];
        
        typeof(DYUVideoCollectionViewController) *weakSelf = self;
        _recordImageView.rStatus = ^(BOOL status){
            
            __strong DYUVideoCollectionViewController *strongSelf = weakSelf;
            DYLog(@"录制-->%@",status?@"开始":@"结束");
            
            if (status) {
                
                NSString *fileName = [[weakSelf createFile] stringByAppendingString:[NSString stringWithFormat:@"/%@.mp4",[[NSDate date] description]]];
                [strongSelf.videoOutput startRecordingToOutputFileURL:[NSURL fileURLWithPath:fileName] recordingDelegate:strongSelf];
            }
            else{
                [strongSelf.videoOutput stopRecording];
            }
        };
    }
    return _recordImageView;
}

- (NSArray *)toolContents{
    
    return @[@"⚔",@"👩",@"⚡️",@"📸"];
}

- (UIImageView *)toolImageView{
    
    if (!_toolImageView) {
        
        CGFloat space = (SCREEN_WIDTH - (44 * [self toolContents].count))/3;
        
        _toolImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 44)];
        [_toolImageView setUserInteractionEnabled:YES];
        
        [[self toolContents] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:obj forState:UIControlStateNormal];
            button.frame = CGRectMake(10 + (44 + space) * idx , 10, 24, 24);
            button.tag = 10 + idx;
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            [button addTarget:self action:@selector(tapEvent:) forControlEvents:UIControlEventTouchUpInside];
            [_toolImageView addSubview:button];
        }];
    }
    return _toolImageView;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
}

- (BOOL)prefersStatusBarHidden
{
    return YES; // 返回NO表示要显示，返回YES将hiden
}



#pragma mark    -   private method

- (NSString *)createFile{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testDirectory = [documentsDirectory stringByAppendingPathComponent:@"test"];
    
    //创建目录
    BOOL success = [fileManager createDirectoryAtPath:testDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    NSLog(@"success = %@",success?@"创建成功":@"创建失败");
    return testDirectory;
}

- (void)tapEvent:(UIButton *)sender{
    
    switch (sender.tag) {
        case 10:
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark    -   system delegate


- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections{
    
    NSLog(@"didStartRecordingToOutputFileAtURL");
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error{
    
#if 0
    [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:outputFileURL];
#else
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc]init];
    [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:outputFileURL completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error) {
            DYLog(@"保存视频到相簿过程中发生错误，错误信息：%@",error.localizedDescription);
        }
        
        DYLog(@"成功保存视频到相簿.");
    }];
#endif
}


- (void)videoEditorController:(UIVideoEditorController *)editor didSaveEditedVideoToPath:(NSString *)editedVideoPath // edited video is saved to a path in app's temporary directory
{
    /* mov格式 */
    DYLog(@"视频保存的路径  %@",editedVideoPath);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)videoEditorController:(UIVideoEditorController *)editor didFailWithError:(NSError *)error{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)videoEditorControllerDidCancel:(UIVideoEditorController *)editor{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark    -   life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.toolImageView];
    
    [self addChildViewController:self.avMoviePlayer];
    [self.view addSubview:self.avMoviePlayer.view];
    
    [self.view addSubview:self.recordImageView];
    
    
    NSString * mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied) {
        
        DYLog(@"摄像头访问受限");
        
    }else{
        
        //NSString *fileName = [[self createFile] stringByAppendingString:[NSString stringWithFormat:@"/%@.mp4",[[NSDate date] description]]];
        //[self.videoOutput startRecordingToOutputFileURL:[NSURL fileURLWithPath:fileName] recordingDelegate:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


#pragma mark    -   DYUVideoRecordImageView

/**!
 *  @discussion 默认情况下，只显示录制按钮
 *  1.当按下录制按钮后，撤销按钮出现，同时显示录制时长，并在本地保存录制的视频片段
 *  2.按下录制的过程中，将撤销按钮置灰，并因此导航栏的工具试图
 *  3.录制时长达到3s(精确到毫秒)后，显示录制完成的按钮，在录制过程中置灰，松开录制按钮后点亮
 *  4.录制视频限时为5min，并在录制的时长进行进度显示
 */

@interface DYUVideoRecordImageView ()

@property (nonatomic, strong) NSTimer   *timer;

@end

@implementation DYUVideoRecordImageView{
    
    @protected
    BOOL    isRecording;    /*  是否正在录制 */
}

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.frame = frame;
        //self.backgroundColor = [UIColor redColor];
        
        [self addSubview:self.durationLabel];
        [self addSubview:self.backButton];
        [self addSubview:self.recordButton];
        [self addSubview:self.completeButton];
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    UIImage *recordImage = DYImageNamed(DY_camera_record_record_start);
    CGFloat recordOrigin_y = CGRectGetHeight(self.durationLabel.frame) + 70;
    [self.recordButton setFrame:CGRectMake(SCREEN_WIDTH/2 - recordImage.size.width/2, recordOrigin_y, recordImage.size.width, recordImage.size.height)];
    
    self.backButton.frame = CGRectOffset(self.recordButton.frame, - CGRectGetWidth(self.recordButton.frame) - 40, 0);
    self.completeButton.frame = CGRectOffset(self.recordButton.frame, CGRectGetWidth(self.recordButton.frame) + 40, 0);
    
    self.backButton.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.completeButton.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.recordButton.transform = CGAffineTransformMakeScale(1.2, 1.2);
}


#pragma mark    -   private method

- (void)backAction:(UIButton *)sender{
    
    DYLog(@"撤销。。。");
}


- (void)completeAction:(UIButton *)sender{
    
    DYLog(@"完成。。。");
}


- (void)buttonDidPress:(NSTimer *)timer{
    
    DYLog(@"录制。。。");
}


- (void)buttonDidLongPress:(UILongPressGestureRecognizer*)gesture
{
    switch (gesture.state) {
            
        case UIGestureRecognizerStateBegan:
        {
            self.timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(buttonDidPress:) userInfo:nil repeats:YES];
            
            NSRunLoop * theRunLoop = [NSRunLoop currentRunLoop];
            [theRunLoop addTimer:self.timer forMode:NSDefaultRunLoopMode];
            
            isRecording = YES;
            
            /* 将按钮置为可用状态 */
            [self.backButton setHidden:NO];
            if ([self.durationLabel.text floatValue] >= 3.0f) [self.completeButton setHidden:NO];
            if (self.rStatus) self.rStatus(YES);
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [self.timer invalidate];
            self.timer = nil;
            
            isRecording = NO;
            if (self.rStatus) self.rStatus(NO);
        }
            break;
        default:
            break;
    }
}


#pragma mark    -   set/get method

- (UILabel *)durationLabel{
    
    if (!_durationLabel) {
        
        _durationLabel = [[UILabel alloc] init];
        _durationLabel.text = @"3.4";
        _durationLabel.textAlignment = NSTextAlignmentCenter;
        _durationLabel.frame = CGRectMake(SCREEN_WIDTH/2 - 60, 20, 120, 30);
        _durationLabel.font = [UIFont systemFontOfSize:14];
        _durationLabel.textColor = [UIColor grayColor];
    }
    return _durationLabel;
}

- (UIButton *)backButton{
    
    if (!_backButton) {
        
        _backButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _backButton.hidden = YES;
        [_backButton setImage:DYImageNamed(DY_camera_record_record_start) forState:UIControlStateNormal];
        [_backButton setImage:DYImageNamed(DY_camera_record_back_unavailable) forState:UIControlStateDisabled];
        
        [_backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIButton *)recordButton{
    
    if (!_recordButton) {
        
        _recordButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_recordButton setBackgroundImage:DYImageNamed(DY_camera_record_record_start) forState:UIControlStateNormal];
        [_recordButton setBackgroundImage:DYImageNamed(DY_camera_record_record_stop) forState:UIControlStateDisabled];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(buttonDidLongPress:)];
        [_recordButton addGestureRecognizer:longPress];
    }
    return _recordButton;
}

- (UIButton *)completeButton{
    
    if (!_completeButton) {
        
        _completeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _completeButton.hidden = YES;
        [_completeButton setBackgroundImage:DYImageNamed(DY_camera_record_complete_available) forState:UIControlStateNormal];
        [_completeButton setBackgroundImage:DYImageNamed(DY_camera_record_complete_unavailable) forState:UIControlStateDisabled];
        
        [_completeButton addTarget:self action:@selector(completeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _completeButton;
}

@end
