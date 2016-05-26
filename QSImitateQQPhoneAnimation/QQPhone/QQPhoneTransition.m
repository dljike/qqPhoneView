//
//  QQPhoneTransition.m
//  QSImitateQQPhoneAnimation
//
//  Created by JosQiao on 16/5/19.
//  Copyright © 2016年 QiaoShi. All rights reserved.
//

#import "QQPhoneTransition.h"
#import "QQPhoneViewController.h"

@interface QQPhoneTransition ()

/** transitionContext */
@property(nonatomic,strong)id <UIViewControllerContextTransitioning>tstContext;

/** 消失的试图控制器 */
@property(nonatomic,strong)UIViewController *fromVC;

/** 显示的视图控制器 */
@property(nonatomic,strong)UIViewController *toVC;

@end

@implementation QQPhoneTransition


+ (instancetype)transitionWithQSTransitionType:(QSTransitionType)transitionType
{
    QQPhoneTransition *transiton = [[self alloc] init];
    if (transiton) {
        transiton.transitionType = transitionType;
    }
    return transiton;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.endRect = CGRectMake(100, 100, 100, 100);
        self.lastPoint = CGPointMake([UIScreen mainScreen].bounds.size.width - 50, [UIScreen mainScreen].bounds.size.height - 90);
        self.controlPoint = CGPointMake(self.lastPoint.x , self.endRect.origin.y + self.endRect.size.height);
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 2.0;
}
// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    
    switch (self.transitionType) {
        case QSTransitionTypeDismiss:
        {
            [self animateDismissTransition:transitionContext];
        }
            break;
        case QSTransitionTypePresent:
        {
            [self animatePresentTransition:transitionContext];
        }
            break;
            
        default:
            break;
    }
    

    
}


#pragma mark - 显示和消失动画
- (void)animatePresentTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    
    self.tstContext = transitionContext;
    
    self.toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UINavigationController *fromVC = (UINavigationController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    QQPhoneViewController *temp = fromVC.viewControllers.lastObject;
    self.fromVC = temp;
    
    // 把新的试图控制器试图添加
    UIView *cView = [transitionContext containerView];
    [cView addSubview:_toVC.view];
    
    // 先隐藏新试图
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = CGRectMake(0, 0, 0, 0);
    _toVC.view.layer.mask = maskLayer;
    
    
    CGPoint starPoint = self.lastPoint;
    CGPoint endPoint  = temp.firstCenter;
    UIBezierPath *animPath = [[UIBezierPath alloc] init];
    [animPath moveToPoint:starPoint];
    [animPath addQuadCurveToPoint:endPoint controlPoint:self.controlPoint];
    
//    CAShapeLayer *layer = [CAShapeLayer layer];
//    layer.path = animPath.CGPath;
//    layer.fillColor = [UIColor clearColor].CGColor;
//    layer.strokeColor = [UIColor redColor].CGColor;
//    [temp.view.layer addSublayer:layer];

    CAAnimationGroup *groupAnim = [self groupAnimationWithPath:animPath transform:CATransform3DMakeScale(2, 2, 1) duratio:1.0];
    
    groupAnim.removedOnCompletion = NO;
    groupAnim.fillMode = kCAFillModeForwards;
    groupAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [groupAnim setValue:self.tstContext forKey:@"transitionContext"];
    
    [temp.btnOnLinePhone.layer addAnimation:groupAnim forKey:@"keyAnim"];

    
}



- (void)animateDismissTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    self.tstContext = transitionContext;
    self.fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UINavigationController *toVC = (UINavigationController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    QQPhoneViewController *temp = toVC.viewControllers.lastObject;
    self.toVC = temp;
    
    // 把电话按钮添加到 控制器
    [temp.view addSubview:temp.btnOnLinePhone];
    self.endRect = temp.btnOnLinePhone.frame;
    
    UIView *containerView = [transitionContext containerView];
    
    /**
     * 画两个圆路径
     */
    
    // 对角线的一半作为半径
    CGFloat radius = sqrtf(containerView.frame.size.height * containerView.frame.size.height + containerView.frame.size.width * containerView.frame.size.width) / 2;
    
    UIBezierPath *startCycle = [UIBezierPath bezierPathWithArcCenter:containerView.center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    UIBezierPath *endCycle =  [UIBezierPath bezierPathWithOvalInRect:self.endRect];
    
    //创建CAShapeLayer进行遮盖
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.fillColor = [UIColor greenColor].CGColor;
    maskLayer.path = endCycle.CGPath;
    self.fromVC.view.layer.mask = maskLayer;
    
    //创建路径动画
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.fromValue = (__bridge id)(startCycle.CGPath);
    maskLayerAnimation.toValue = (__bridge id)((endCycle.CGPath));
    maskLayerAnimation.duration = 1.0;//[self transitionDuration:transitionContext];
    maskLayerAnimation.delegate = self;
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
//    maskLayerAnimation.removedOnCompletion = NO;
//    maskLayerAnimation.fillMode = kCAFillModeForwards;
    
    [maskLayerAnimation setValue:transitionContext forKey:@"transitionContext"];
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];

}



#pragma mark - 显示和消失状态 动画结束


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    
    switch (self.transitionType) {
            
        case QSTransitionTypeDismiss:
        {
            [self animationDismissDidStop:anim finished:flag];
        }
            break;
        case QSTransitionTypePresent:
        {
            [self animationPresentDidStop:anim finished:flag];
        }
            break;
            
        default:
            break;
    }
    
}


- (void)animationDismissDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    // 如果是第一段动画
    if ([anim valueForKey:@"transitionContext"] == self.tstContext) {
        
        [self.tstContext completeTransition:YES];
        [self.tstContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
        
        // 再
        QQPhoneViewController *temp = (QQPhoneViewController *)self.toVC;
        
        
        CGPoint starPoint = CGPointMake(self.endRect.origin.x + self.endRect.size.width / 2.0, self.endRect.origin.y + self.endRect.size.height / 2.0);
        
        starPoint = temp.firstCenter;
        UIBezierPath *animPath = [[UIBezierPath alloc] init];
        [animPath moveToPoint:starPoint];
        [animPath addQuadCurveToPoint:self.lastPoint controlPoint:self.controlPoint];
        
        CAAnimationGroup *groupAnim = [self groupAnimationWithPath:animPath transform:CATransform3DMakeScale(1.0, 1.0, 1) duratio:1.0];
        
        groupAnim.removedOnCompletion = NO;
        groupAnim.fillMode = kCAFillModeForwards;
        
        [temp.btnOnLinePhone.layer addAnimation:groupAnim forKey:@"keyAnim"];
        
    }else {
        
        QQPhoneViewController *temp = (QQPhoneViewController *)self.toVC;
        
        [temp.btnOnLinePhone.layer removeAllAnimations];
        
        temp.btnOnLinePhone.center = self.lastPoint;
        temp.btnOnLinePhone.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1);
    }
}


- (void)animationPresentDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
 
    // 如果是第一段动画
    if ([anim valueForKey:@"transitionContext"] == self.tstContext) {
        
        QQPhoneViewController *temp = (QQPhoneViewController *)self.fromVC;
        
        
        temp.btnOnLinePhone.layer.transform =  CATransform3DMakeScale(2, 2, 1);
        temp.btnOnLinePhone.center = temp.firstCenter;
        [temp.btnOnLinePhone.layer removeAllAnimations];
        
        UIView *containerView = [self.tstContext containerView];
        
        /**
         * 画两个圆路径
         */
        // 对角线的一半作为半径
        CGFloat radius = sqrtf(containerView.frame.size.height * containerView.frame.size.height + containerView.frame.size.width * containerView.frame.size.width) / 2;
        
        UIBezierPath *endCycle = [UIBezierPath bezierPathWithArcCenter:containerView.center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
        
        UIBezierPath *starCycle =  [UIBezierPath bezierPathWithOvalInRect:temp.btnOnLinePhone.frame];
        
        //创建CAShapeLayer进行遮盖
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.fillColor = [UIColor greenColor].CGColor;
        maskLayer.path = endCycle.CGPath;
        self.toVC.view.layer.mask = maskLayer;
        
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
        animation.duration = 1.0;
        animation.fromValue = (__bridge id)starCycle.CGPath;
        animation.toValue   = (__bridge id)endCycle.CGPath;
        animation.delegate = self;
        
        [maskLayer addAnimation:animation forKey:@"path"];
        
    }else {
        
        [self.tstContext completeTransition:YES];
        self.toVC.view.layer.mask = nil;
    }
    
}


- (CAAnimationGroup *)groupAnimationWithPath:(UIBezierPath *)path transform:(CATransform3D)transform duratio:(CFTimeInterval)duration
{

    /*
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = animPath.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor redColor].CGColor;
    */
     
     
    // 关键路径动画
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyAnimation.path = path.CGPath;
    
    //keyAnimation.delegate = self;
    //keyAnimation.rotationMode
    //keyAnimation.duration = 1.0;
    
    
    // 尺寸动画
    CABasicAnimation *rotationAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
    rotationAnim.toValue = [NSValue valueWithCATransform3D:transform];
    
    
    // 动画组
    CAAnimationGroup *groupAnim = [CAAnimationGroup animation];
    groupAnim.animations = @[keyAnimation,rotationAnim];
    
    groupAnim.delegate = self;
    groupAnim.duration = duration;
    
    groupAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];

    return groupAnim;
}








/*
 UIView *fromView = [self.tstContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
 
 CGFloat topDistance = fromView.center.y - self.endRect.origin.y + self.endRect.size.height/2;
 CGFloat leftDistance = fromView.center.x - self.endRect.origin.x + self.endRect.size.width/2;
 
 CGPoint endPoint = CGPointMake(self.lastRect.origin.x + self.lastRect.size.width/2 + leftDistance, topDistance + self.lastRect.origin.y + self.lastRect.size.height/2 );
 
 fromView.center = endPoint;
 */

/*
 id<UIViewControllerContextTransitioning> transitionContext = [anim valueForKey:@"transitionContext"];
 
 [transitionContext completeTransition:YES];
 
 [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
 */


@end
