//
//  DYUImageNameDefine.h
//  DYVideoTools
//
//  Created by qiyun on 16/8/25.
//  Copyright © 2016年 qiyun. All rights reserved.
//


#ifndef DYUImageNamesDefine_h
#define DYUImageNamesDefine_h

#pragma mark    -   notification key

static NSString * const DY_Home_camera_start = @"com.douyu.cameraStart";

#pragma mark    -   Home

static NSString * const DY_Home_tabbar_background                   = @"tab_bg";            /* 背景图 */
static NSString * const DY_Home_tabbar_camera_normal                = @"tab_room";          /* 相机未点击状态图 */
static NSString * const DY_Home_tabbar_camera_select                = @"tab_room_p";        /* 相机点击状态图 */


static NSString * const DY_Camera_tools_hiden                       = @"tab_room_p";        /* 隐藏图片 */
static NSString * const DY_camera_tools_camera                      = @"btn_record_big_a";
static NSString * const DY_camera_tools_upload                      = @"btn_del_active_a";


static NSString * const DY_camera_record_back_available             = @"btn_del_a";
static NSString * const DY_camera_record_back_unavailable           = @"btn_del_c";


static NSString * const DY_camera_record_record_start               = @"filter_mask_b";
static NSString * const DY_camera_record_record_stop                = @"icon_badge_bg_list";


static NSString * const DY_camera_record_complete_available         = @"btn_camera_done_a";
static NSString * const DY_camera_record_complete_unavailable       = @"btn_camera_done_c";


















//屏幕宽度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

//屏幕高度
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define DYImageNamed(name) [UIImage imageNamed:name]

//rgb色值
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#ifdef DEBUG
#   define DYLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DYLog(...)
#endif

#endif /* DYUImageNameDefine_h */
