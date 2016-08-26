//
//  DYUToolViewController.h
//  DYVideoTools
//
//  Created by qiyun on 16/8/26.
//  Copyright © 2016年 qiyun. All rights reserved.
//

#import "DYUBaseViewController.h"

typedef void(^DYToolsOfClickIndex)(NSInteger);

@interface DYUToolViewController : DYUBaseViewController

@property (copy, nonatomic) DYToolsOfClickIndex clickIndex;

@end
