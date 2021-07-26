//
//  ViewController.m
//  CAAnimation-Demo
//
//  Created by 谢跃聪 on 2021/7/26.
//

#import "ViewController.h"

/**
 https://www.jianshu.com/p/3f48fabaca19
 【动画的继承结构】
 CAAnimation{
      CAPropertyAnimation{
             CABasicAnimation{
                     CASpringAnimation
             }
             CAKeyframeAnimation
      }
      CATransition
      CAAnimationGroup
 }
 
 【CAAnimation】动画根类，不直接使用，主要属性如下：
 delegate(id)：包含animationDidStart、animationDidStop两个方法
 removedOnCompletion(BOOL)：动画完成后是否移除动画(默认YES)，为YES时，fillMode属性不可用
 timingFunction(CAMediaTimingFunction)：动画的动作规则，如下
 <1>kCAMediaTimingFunctionLinear匀速
 <2>kCAMediaTimingFunctionEaseIn慢进快出
 <3>kCAMediaTimingFunctionEaseOut快进慢出
 <4>kCAMediaTimingFunctionEaseInEaseOut慢进慢出，中间加速
 <5>kCAMediaTimingFunctionDefault默认
 
 beginTime(CFTimeInterval)：开始时间，一般用法CACurrentMediaTime()+x，x是延迟时间
 duration(CFTimeInterval)：执行时间，此属性和speed有关系，speed默认为1.0，如果speed设置为2.0，那么动画执行时间则为duration*(1.0/2.0)
 speed(float)：执行速度
 timeOffset(CFTimeInterval)：时间偏移量，默认为0。假设有个5s的动画，正常执行是1->2->3->4->5，如果设置该值为2s，则变成3->4->5->1->2
 repeatCount(float)：重复执行次数
 repeatDuration(CFTimeInterval)：重复执行时间，优先级大于repeatCount
 autoreverses(BOOL)：是否自动翻转动画，默认NO，为YES时执行效果为A->B->A
 fillMode(NSString)：动画的填充方式，如下
 <1>kCAFillModeForwards动画结束后回到准备状态
 <2>kCAFillModeBackwards动画结束后保持最后状态
 <3>kCAFillModeBoth动画结束后回到准备状态，并保持最后状态
 <4>kCAFillModeRemoved执行完成移除动画(默认)
 
 【CAPropertyAnimation】属性动画，针对属性才可以做的动画。抽象类，不能直接使用
 keyPath(NSString)：需要做动画的属性值
 additive(BOOL)：属性动画是否以当前动画效果为基础，默认为NO
 cumulative(BOOL)：指定动画是否为累加效果，默认为NO
 valueFunction(CAValueFunction)：此属性相当于CALayer中的transform属性(rotation旋转、scale缩放、translation平移)
 可设置属性动画的属性如下：
 CATransform3D{
     transform.rotation.x
     transform.rotation.y
     transform.rotation.z
     transform.scale.x
     transform.scale.y
     transform.scale.z
     transform.translation.x
     transform.translation.y
     transform.translation.z
 }
 CGPoint{
     position
     position.x
     position.y
 }
 CGRect{
     bounds
     bounds.size
     bounds.size.width
     bounds.size.height

     bounds.origin
     bounds.origin.x
     bounds.origin.y
 }
 property{
     opacity
     backgroundColor
     cornerRadius
     borderWidth
     contents
     Shadow{
         shadowColor
         shadowOffset
         shadowOpacity
         shadowRadius
     }
 }

 【CABasicAnimation】基本动画
 fromValue(id)：开始值
 toValue(id)：结束值
 byValue(id)：相对值
 这三个值规则如下：
 <1>fromValue和toValue不为空，动画的效果会从fromValue的值变化到toValue.
 <2>fromValue和byValue都不为空，动画的效果将会从fromValue变化到fromValue+byValue
 <3>byValue和toValue都不为空，动画的效果将会从toValue-byValue变化到toValue
 <4>只有fromValue的值不为空，动画的效果将会从fromValue的值变化到当前的状态
 <5>只有toValue的值不为空，动画的效果将会从当前状态的值变化到toValue的值
 <6>只有byValue的值不为空，动画的效果将会从当前的值变化到(当前状态的值+byValue)的值

 【CASpringAnimation】弹性动画(iOS9新增)
 mass(CGFloat)：质量，振幅和质量成反比
 stiffness(CGFloat)：刚度系数(劲度系数/弹性系数)，刚度系数越大，形变产生的力就越大，运动越快
 damping(CGFloat)：阻尼系数，阻止弹簧伸缩的系数，阻尼系数越大，停止越快，可以认为它是阻力系数
 initialVelocity(CGFloat)：初始速率，动画视图的初始速度大小速率为正数时，速度方向与运动方向一致；速率为负数时，速度方向与运动方向相反
 settlingDuration(CFTimeInterval)：结算时间(只读).返回弹簧动画到停止时的估算时间，根据当前的动画参数估算通常弹簧动画的时间使用结算时间比较准确
 
 【CAKeyframeAnimation】关键帧动画
 values(NSArray)：关键帧值数组，一组变化值
 path(CGPathRef)：关键帧帧路径，优先级比values大
 keyTimes(NSArray)：每一帧对应的时间，时间可以控制速度.它和每一个帧相对应，取值为0.0-1.0，不设则每一帧时间相等
 timingFunctions(NSArray)：每一帧对应的时间曲线函数，也就是每一帧的运动节奏
 calculationMode(NSString)：动画的计算模式，如下
 <1>kCAAnimationLinear关键帧为座标点的时候，关键帧之间直接直线相连进行插值计算(默认)
 <2>kCAAnimationDiscrete离散的，也就是没有补间动画
 <3>kCAAnimationPaced平均，keyTimes跟timeFunctions失效
 <4>kCAAnimationCubic对关键帧为座标点的关键帧进行圆滑曲线相连后插值计算，对于曲线的形状还可以通过tensionValues、continuityValues、biasValues来进行调整自定义，keyTimes跟timeFunctions失效
 <5>kCAAnimationCubicPaced在kCAAnimationCubic的基础上使得动画运行变得均匀，就是系统时间内运动的距离相同，keyTimes跟timeFunctions失效
 tensionValues(NSArray)：动画的张力，当动画为立方计算模式的时候此属性提供了控制插值，因为每个关键帧都可能有张力所以连续性会有所偏差它的范围为[-1,1].同样是此作用
 continuityValues(NSArray)：动画的连续性值
 biasValues(NSArray)：动画的偏斜率
 rotationMode(NSString)：动画沿路径旋转方式，默认为nil，如下
 <1>kCAAnimationRotateAuto自动旋转
 <2>kCAAnimationRotateAutoReverse自动翻转
 
 【CAAnimationGroup】动画组
 animations(NSArray)：数组中接受CAAnimation元素，可以包含多个动画，让多个动画同时进行
 
 
 
 */
@interface ViewController ()<CAAnimationDelegate>

@property (nonatomic,strong)UIView *demoView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self doBasicAnimation];
//    [self doSpringAnimation];
//    [self doKeyframeAnimation];
//    [self doAnimationGroup];
}

#pragma mark - CABasicAnimation
- (void)doBasicAnimation {
    NSArray *titles = @[@"淡入淡出",@"缩放",@"旋转",@"平移"];
    for (int i = 0; i < titles.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.view addSubview:btn];
        btn.backgroundColor = [UIColor brownColor];
        btn.tag = i;
        btn.frame = CGRectMake(10, 50 + 80 * i, 100, 60);
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(basicAnimationBegin:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    view.backgroundColor = [UIColor redColor];
    view.center = self.view.center;
    self.demoView = view;
    [self.view addSubview:self.demoView];
}

- (void)basicAnimationBegin:(UIButton *)btn {
    CABasicAnimation *animation = nil;
    switch (btn.tag) {
        case 0:
            //淡如淡出
            animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            [animation setFromValue:@1.0]; //设置起始值
            [animation setToValue:@0.1]; //设置目标值
            break;
        case 1:
            //缩放
            animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            [animation setFromValue:@1.0];
            [animation setToValue:@0.1];
            break;
        case 2:
            //旋转
            animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
            [animation setToValue:@(M_PI)]; // 只设置toValue，从当前状态开始变化
            break;
        case 3:
            //平移
            animation = [CABasicAnimation animationWithKeyPath:@"position"];
            [animation setToValue:[NSValue valueWithCGPoint:CGPointMake(self.view.center.x, self.view.center.y + 200)]];
            break;
    }
    [animation setDelegate:self];//代理回调
    [animation setDuration:0.25];//设置动画时间，单次动画时间
    [animation setRemovedOnCompletion:NO];//默认为YES,设置为NO时setFillMode有效
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]]; // 设置动画的动作规则
    [animation setAutoreverses:YES];
    [animation setFillMode:kCAFillModeBoth];
    [self.demoView.layer addAnimation:animation forKey:@"baseanimation"];
}

#pragma mark - CASpringAnimation
- (void)doSpringAnimation {
    NSArray *titles = @[@"Spring弹性动画"];
    for (int i = 0; i < titles.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.view addSubview:btn];
        btn.backgroundColor = [UIColor brownColor];
        btn.tag = i;
        btn.frame = CGRectMake(10, 50 + 80 * i, 100, 60);
        btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(springAnimationBegin:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    view.backgroundColor = [UIColor redColor];
    view.center = self.view.center;
    view.center = CGPointMake(self.view.center.x + 120, self.view.center.y - 120);
    self.demoView = view;
    [self.view addSubview:self.demoView];
}

-(void)springAnimationBegin:(UIButton *)btn {
    CASpringAnimation *spring = nil;
    switch (btn.tag) {
        case 0:
            spring = [CASpringAnimation animationWithKeyPath:@"position.y"];
            spring.damping = 5;
            spring.stiffness = 100;
            spring.mass = 1;
            spring.initialVelocity = 0;
            spring.duration = spring.settlingDuration;
            spring.fromValue = @(self.demoView.center.y);
            spring.toValue = @(self.demoView.center.y + (btn.selected?+200:-200));
            spring.fillMode = kCAFillModeForwards;
            [self.demoView.layer addAnimation:spring forKey:nil];
            break;
    }
    btn.selected = !btn.selected;
}

#pragma mark - CAKeyframeAnimation
- (void)doKeyframeAnimation {
    NSArray *titles = @[@"path椭圆", @"贝塞尔矩形", @"贝塞尔抛物线", @"贝塞尔s曲线", @"贝塞尔圆", @"弹力仿真", @"自晃动", @"指定点平移"];
    for (int i = 0; i < titles.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.view addSubview:btn];
        btn.backgroundColor = [UIColor brownColor];
        btn.tag = i;
        btn.frame = CGRectMake(10, 50 + 35 * i, 100, 30);
        btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(keyframeAnimationBegin:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    view.backgroundColor = [UIColor redColor];
    view.center = self.view.center;
    view.center = CGPointMake(self.view.center.x, 10);
    self.demoView = view;
    [self.view addSubview:self.demoView];
}

- (void)keyframeAnimationBegin:(UIButton *)btn {
    switch (btn.tag) {
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
            [self path:btn.tag];
            break;
        case 6:
        case 7:
            [self values:btn.tag];
            break;
    }
}

- (void)path:(NSInteger)tag {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    switch (tag) {
        case 0:{ // 椭圆
            CGMutablePathRef path = CGPathCreateMutable();//创建可变路径
            CGPathAddEllipseInRect(path, NULL, CGRectMake(0, 0, 320, 500));
            [animation setPath:path];
            CGPathRelease(path);
            animation.rotationMode = kCAAnimationRotateAuto;
        } break;
        case 1:{ // 贝塞尔矩形
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 320, 320)];
            [animation setPath:path.CGPath];
        } break;
        case 2:{ // 贝塞尔抛物线
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:self.demoView.center];
            [path addQuadCurveToPoint:CGPointMake(0, 568) controlPoint:CGPointMake(400, 100)];
            [animation setPath:path.CGPath];
        } break;
        case 3:{ // 贝塞尔s形曲线
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointZero];
            [path addCurveToPoint:self.demoView.center controlPoint1:CGPointMake(320, 100) controlPoint2:CGPointMake(  0, 400)];
            [animation setPath:path.CGPath];
        } break;
        case 4:{ // 贝塞尔圆形
            UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.view.center
                                                                 radius:150
                                                             startAngle:- M_PI * 0.5
                                                               endAngle:M_PI * 2
                                                              clockwise:YES];
            [animation setPath:path.CGPath];
        } break;
        case 5:{
            CGPoint point = CGPointMake(self.view.center.x, 400);
            CGFloat xlength = point.x - self.demoView.center.x;
            CGFloat ylength = point.y - self.demoView.center.y;
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path, NULL, self.demoView.center.x, self.demoView.center.y); //移动到目标点
            CGPathAddLineToPoint(path, NULL, point.x, point.y); //将目标点的坐标添加到路径中
            CGFloat offsetDivider = 5.0f; //设置弹力因子
            BOOL stopBounciong = NO;
            while (stopBounciong == NO) {
                CGPathAddLineToPoint(path, NULL, point.x + xlength / offsetDivider, point.y + ylength / offsetDivider);
                CGPathAddLineToPoint(path, NULL, point.x, point.y);
                offsetDivider += 6.0;
                //当视图的当前位置距离目标点足够小我们就退出循环
                if ((ABS(xlength / offsetDivider) < 10.0f) && (ABS(ylength / offsetDivider) < 10.0f)) break;
            }
            [animation setPath:path];
        } break;
    }
    
    [animation setDuration:0.5];
    [animation setRemovedOnCompletion:NO];
    [animation setFillMode:kCAFillModeBoth];
    [self.demoView.layer addAnimation:animation forKey:nil];
}

- (void)values:(NSInteger)tag {
    CAKeyframeAnimation *animation = nil;
    switch (tag) {
        case 6:{
            animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
            CGFloat angle = M_PI_4 * 0.5;
            NSArray *values = @[@(angle),@(-angle),@(angle)];
            [animation setValues:values];
            [animation setRepeatCount:3];
            [animation setDuration:0.5];
        } break;
        case 7:{
            animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            NSValue *p1 = [NSValue valueWithCGPoint:self.demoView.center];
            NSValue *p2 = [NSValue valueWithCGPoint:CGPointMake(self.view.center.x + 100, 200)];
            NSValue *p3 = [NSValue valueWithCGPoint:CGPointMake(self.view.center.x, 300)];
            //设置关键帧的值
            [animation setValues:@[p1,p2,p3]];
            [animation setDuration:0.5];
        } break;
    }
    UIGraphicsBeginImageContext(self.view.frame.size);
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [animation setRemovedOnCompletion:NO];
    [animation setFillMode:kCAFillModeBoth];
    [self.demoView.layer addAnimation:animation forKey:nil];
}

#pragma mark - CAAnimationGroup
- (void)doAnimationGroup {
    NSArray *titles = @[@"动画组演示"];
    for (int i = 0; i < titles.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.view addSubview:btn];
        btn.backgroundColor = [UIColor brownColor];
        btn.tag = i;
        btn.frame = CGRectMake(10, 50 + 80 * i, 100, 60);;
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(animationGroupBegin:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    view.backgroundColor = [UIColor redColor];
    view.center = self.view.center;
    view.center = CGPointMake(self.view.center.x + 120, self.view.center.y - 120);
    self.demoView = view;
    [self.view addSubview:self.demoView];
}

- (void)animationGroupBegin:(UIButton *)btn {
    [self groupAnimation:nil];
}

- (void)groupAnimation:(NSSet<UITouch *> *)touches {
    CAAnimationGroup *group = [CAAnimationGroup animation];
    CAKeyframeAnimation *position = [self moveAnimation:touches]; // 移动
    CAKeyframeAnimation *shake = [self shakeAnimation:touches]; // 摇晃
    CABasicAnimation *alpha = [self alphaAnimation:touches]; // 透明度
    [group setDuration:3.0]; // 设置动画组的时间，这个时间表示动画组的总时间，它的子动画的时间和这个时间没有关系
    [group setAnimations:@[position,shake,alpha]];
    [self.demoView.layer addAnimation:group forKey:nil];
}

- (CAKeyframeAnimation *)moveAnimation:(NSSet<UITouch *> *)touches {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    // 设置路径，按圆运动
    CGMutablePathRef path = CGPathCreateMutable();//CG是C语言的框架，需要直接写语法
    CGPathAddEllipseInRect(path, NULL, CGRectMake(0, 0, 320, 320));
    [animation setPath:path]; //把路径给动画
    CGPathRelease(path); //释放路径
    [animation setDuration:3];
    [animation setRemovedOnCompletion:NO];
    [animation setFillMode:kCAFillModeForwards];
    return animation;
}

- (CAKeyframeAnimation *)shakeAnimation:(NSSet<UITouch *> *)touches {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    // 设置路径，贝塞尔路径
    CGFloat angle = M_PI_4 * 0.1;
    NSArray *values = @[@(angle),@(-angle),@(angle)];
    [animation setValues:values];
    [animation setRepeatCount:10];
    [animation setDuration:0.25];
    return animation;
}

- (CABasicAnimation *)alphaAnimation:(NSSet<UITouch *> *)touches {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [animation setDuration:1.0];
    [animation setRepeatCount:3];
    [animation setAutoreverses:YES];
    [animation setFromValue:@1.0];
    [animation setDelegate:self];
    [animation setToValue:@0.1];
    return animation;
}

#pragma mark - <CAAnimationDelegate>
- (void)animationDidStart:(CAAnimation *)anim{
    NSLog(@"动画开始------：%@",    NSStringFromCGPoint(self.demoView.center));
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    NSLog(@"动画结束------：%@",    NSStringFromCGPoint(self.demoView.center));
}
@end
