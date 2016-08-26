//
//  DYUToolViewController.m
//  DYVideoTools
//
//  Created by qiyun on 16/8/26.
//  Copyright © 2016年 qiyun. All rights reserved.
//

#import "DYUToolViewController.h"
#import "DYUVideoCollectionViewController.h"

@interface DYUToolViewController ()

@end

@implementation DYUToolViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    typeof(DYUToolViewController) *weakSelf = self;
    
    self.clickIndex = ^(NSInteger value){
        
        switch (value) {
            case 0:
            {
                DYUVideoCollectionViewController *collectionVC = [[DYUVideoCollectionViewController alloc] init];
                collectionVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                [weakSelf presentViewController:collectionVC animated:YES completion:nil];
            }
                break;
                
            default:
                break;
        }
    };
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
