//
//  myView.m
//  Strong_Weak_assign
//
//  Created by 王剑亮 on 2017/3/27.
//  Copyright © 2017年 王剑亮. All rights reserved.
//

#import "myView.h"

@implementation myView



- (void)dealloc{

    NSLog(@"%@被释放了!", self.name);

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
