//
//  DYUToolsView.m
//  DYVideoTools
//
//  Created by qiyun on 16/8/25.
//  Copyright © 2016年 qiyun. All rights reserved.
//

#import "DYUToolsView.h"
#import "DYUBaseViewController.h"


@interface DYUToolsView ()

@property (strong, nonatomic) UILabel  *dismissLabel;

@end

@implementation DYUToolsView{
    
    @private
    NSInteger       index;
}

static DYUToolsView *toolsView = NULL;
+ (instancetype)shareInstanceToolsView{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        toolsView = [[DYUToolsView alloc] init];
    });
    return toolsView;
}


#pragma mark    ----- lift cycle -----

- (id)init{
    
    self = [super init];
    
    if (self) {

        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
        //self.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.95];
        //[self addBlurView];
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.bottomView];
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
}


#pragma mark    ----- set/get -----

- (void)setItemImages:(NSArray *)itemImages{
    
    _itemImages = itemImages;
}

- (void)setItemTitles:(NSArray *)itemTitles{
    
    _itemTitles = itemTitles;
}

- (UIImageView *)bottomView{
    
    if (!_bottomView) {
        
        _bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
        [_bottomView setUserInteractionEnabled:YES];
        [_bottomView setBackgroundColor:[UIColor redColor]];
        [_bottomView setOpaque:YES];
        [_bottomView addSubview:self.dismissLabel];
    }
    return _bottomView;
}


- (UILabel *)dismissLabel{
    
    if (!_dismissLabel) {
        
        _dismissLabel = [[UILabel alloc] init];
        [_dismissLabel setText:@"+"];
        [_dismissLabel setFont:[UIFont systemFontOfSize:50]];
        [_dismissLabel setTextAlignment:NSTextAlignmentCenter];
        [_dismissLabel setFrame:CGRectMake((SCREEN_WIDTH/2 - 20), 5, 40, 40)];
        [_dismissLabel setTextColor:[UIColor blackColor]];
        _dismissLabel.alpha = .0f;
        _dismissLabel.layer.cornerRadius = CGRectGetWidth(_dismissLabel.frame)/2;
        _dismissLabel.clipsToBounds = YES;
    }
    return _dismissLabel;
}


#pragma mark    ----- private/ public method -----

- (void)addBlurView{
    
    UIBlurEffect *beffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *view = [[UIVisualEffectView alloc] initWithEffect:beffect];
    view.frame = self.bounds;
    [self addSubview:view];
}


- (void)show{
    
    index = 0;
    self.frame = [UIScreen mainScreen].bounds;

    [UIView animateWithDuration:0.25 animations:^{
        
        [self.dismissLabel setTransform:CGAffineTransformMakeRotation(M_PI/4)];
        _dismissLabel.alpha = 1.0f;
        
        [self stackFlowPresentationOfAnnimations];
    }];
}


- (void)dismiss{
    
    if ([self.delegate respondsToSelector:@selector(dismiss)]) {
        
        [self.delegate dismisss];
    }
    
    [self stackFlowDismissOfAnimations];
}

/* 显示多个按钮 */
- (void)stackFlowPresentationOfAnnimations{
    
    if (index < _itemImages.count) {
        
        CGFloat itemWidth = SCREEN_WIDTH * 0.3;
        CGFloat whiteSpace = SCREEN_WIDTH * 0.1 / 4;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:_itemImages[index] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(whiteSpace + (index * (itemWidth + whiteSpace)), SCREEN_HEIGHT, itemWidth, itemWidth)];
        button.alpha = .0f;
        button.tag = 10 + index;
        [button addTarget:self action:@selector(tapButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        [UIView animateWithDuration:0.25
                              delay:0
             usingSpringWithDamping:0.4
              initialSpringVelocity:0.0
                            options:UIViewAnimationOptionTransitionFlipFromBottom
                         animations:^{
            
                             button.alpha = 1.0f;
                             CGRect rect = button.frame;
                             rect.origin.y = itemWidth * 0.1 + SCREEN_HEIGHT/2;
                             button.frame = rect;
            
        } completion:^(BOOL finished) {
            
            index ++;
            [self stackFlowPresentationOfAnnimations];
        }];
    }
}

/* 隐藏多个按钮 */
- (void)stackFlowDismissOfAnimations{
    
    UIButton *button = [self viewWithTag:index + 9];

    if (index >= 0 && button) {
     
        [UIView animateWithDuration:0.15
                              delay:0
             usingSpringWithDamping:0.4
              initialSpringVelocity:0.0
                            options:UIViewAnimationOptionTransitionFlipFromTop
                         animations:^{
                             
                             button.alpha = .0f;
                             CGRect rect = button.frame;
                             rect.origin.y = SCREEN_HEIGHT;
                             button.frame = rect;
                             
                         } completion:^(BOOL finished) {
                             
                             index --;
                             [button removeFromSuperview];
                             [self stackFlowDismissOfAnimations];
                         }];
        
        if (index == 1) {
            
            [UIView animateWithDuration:0.25
                                  delay:0
                 usingSpringWithDamping:0.4
                  initialSpringVelocity:0.0
                                options:UIViewAnimationOptionTransitionFlipFromBottom
                             animations:^{
                                 
                                 [self.dismissLabel setTransform:CGAffineTransformMakeRotation(M_PI/2)];
                                 _dismissLabel.alpha = .0f;
                                 
                             } completion:^(BOOL finished) {
                                 
                                 self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
                                 [self.superview removeFromSuperview];
                                 [self removeFromSuperview];
                                 
                                 if (self.dismissHandler) self.dismissHandler();

                             }];
        }
    }
}


- (void)tapButtonEvent:(UIButton *)sender{
    
    if ([self.delegate respondsToSelector:@selector(viewDidSelectedOfToolsIndex:)]) {
        
        [self.delegate viewDidSelectedOfToolsIndex:sender.tag - 10];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self dismiss];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    
}


@end
