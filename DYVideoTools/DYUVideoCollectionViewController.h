//
//  DYUVideoCollectionViewController.h
//  DYVideoTools
//
//  Created by qiyun on 16/8/26.
//  Copyright © 2016年 qiyun. All rights reserved.
//

#import "DYUBaseViewController.h"

typedef void(^DYUVideoRecordingStatus)(BOOL isStart);

@interface DYUVideoCollectionViewController : DYUBaseViewController

@end


@interface DYUVideoRecordImageView : UIImageView

@property (nonatomic, strong) UILabel   *durationLabel;     /* 录制时长 */
@property (nonatomic, strong) UIButton  *backButton;        /* 撤销上一步 */
@property (nonatomic, strong) UIButton  *recordButton;      /* 开始／暂停 */
@property (nonatomic, strong) UIButton  *completeButton;    /* 完成 */

@property (nonatomic, copy) DYUVideoRecordingStatus rStatus;

@end
