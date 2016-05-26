//
//  QQPhoneOnLineViewController.m
//  QSImitateQQPhoneAnimation
//
//  Created by JosQiao on 16/5/19.
//  Copyright © 2016年 QiaoShi. All rights reserved.
//

#import "QQPhoneOnLineViewController.h"
#import "QQPhoneTransition.h"

@interface QQPhoneOnLineViewController ()<UIViewControllerTransitioningDelegate>

@end

@implementation QQPhoneOnLineViewController

- (void)dealloc
{
    NSLog(@"销毁");
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor cyanColor];
    
    self.view.layer.contents = (__bridge id)[UIImage imageNamed:@"11.png"].CGImage;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [QQPhoneTransition transitionWithQSTransitionType:QSTransitionTypeDismiss];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [QQPhoneTransition transitionWithQSTransitionType:QSTransitionTypePresent];
}

@end
