//
//  ViewController.m
//  Strong_Weak_assign
//
//  Created by 王剑亮 on 2017/3/27.
//  Copyright © 2017年 王剑亮. All rights reserved.
//

#import "ViewController.h"
#import "nextViewController.h"
#import "SCPickerView.h"
@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    //UIButton
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 100, 50);
    [btn setTitle:@"下一页" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor greenColor];
    [btn addTarget:self action:@selector(clicked) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btn];
    
    
    SCPickerView *scPickerView = [[SCPickerView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 200)];
    
    [self.view addSubview:scPickerView];
    
    
}

- (void)clicked{

//    nextViewController *myVC = [[nextViewController alloc] init];
//    //创建动画
//    CATransition *animation = [CATransition animation];
//    //设置运动轨迹的速度
//    animation.timingFunction = UIViewAnimationCurveEaseInOut;
//    //设置动画类型为立方体动画
//    animation.type = @"cube";
//    //设置动画时长
//    animation.duration =0.5f;
//    //设置运动的方向
//    animation.subtype =kCATransitionFromRight;
//    //控制器间跳转动画
//    [[UIApplication sharedApplication].keyWindow.layer addAnimation:animation forKey:nil];
//    [self.navigationController pushViewController:myVC animated:NO];
    
//        nextViewController *myVC = [[nextViewController alloc] init];
//    //模仿网易的那个效果
//    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
//    view.backgroundColor = [UIColor greenColor];
//    [self.view addSubview:view];
//    
//      [UIView transitionFromView:view toView:myVC.view duration:2.0 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
//          
//      }];
    

    nextViewController *myVC = [[nextViewController alloc] init];
    //创建动画
    CATransition *animation = [CATransition animation];
    //设置运动轨迹的速度
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    //设置动画类型为立方体动画
    animation.type = @"oglFlip";
    //设置动画时长
    animation.duration =0.5f;
    //设置运动的方向
    animation.subtype =kCATransitionFromRight;
    //控制器间跳转动画
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:animation forKey:nil];
    [self presentViewController:myVC animated:NO completion:nil];

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
