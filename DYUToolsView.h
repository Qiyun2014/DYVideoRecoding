//
//  DYUToolsView.h
//  DYVideoTools
//
//  Created by qiyun on 16/8/25.
//  Copyright © 2016年 qiyun. All rights reserved.
//

#import <UIKit/UIKit.h>

/* 定义一个协议，协议为点击工具栏按钮，捕捉起对应的位置 */
@protocol DYNToolsViewDelegate <NSObject>

@optional
- (void)viewDidSelectedOfToolsIndex:(NSInteger)index;
- (void)dismisss;

@end


/* ----------------------------------------------------------------------- */

typedef void(^DYUToolsViewDismiss)(void);

@interface DYUToolsView : UIView

+ (instancetype)shareInstanceToolsView;

@property (strong, nonatomic)     NSArray *itemImages;                     /* 按钮图片集合 */
@property (strong, nonatomic)     NSArray *itemTitles;                     /* 按钮标题集合 */
@property (strong, nonatomic)   UIImageView   *bottomView;                 /* 底部按钮视图 */
@property (weak, nonatomic)     id<DYNToolsViewDelegate> delegate;
@property (copy, nonatomic)     DYUToolsViewDismiss dismissHandler;


- (void)show;
- (void)dismiss;

@end
