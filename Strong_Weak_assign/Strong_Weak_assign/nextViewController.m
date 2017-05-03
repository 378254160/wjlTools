//
//  nextViewController.m
//  Strong_Weak_assign
//
//  Created by 王剑亮 on 2017/3/27.
//  Copyright © 2017年 王剑亮. All rights reserved.
//

#import "nextViewController.h"
#import "myView.h"
@interface nextViewController ()
{
    //第一个自定义的指针 对象  相当于强指针
    
    myView  *_myViewFirst;
    
}

//strong weak assign
@property (nonatomic,strong)  myView * myViewSecond;
@property (nonatomic,weak)    myView * myViewThird;
@property (nonatomic,assign)  myView * myViewQuarter;
@end

@implementation nextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    //默认的私有变量 强指针  但是没有 getter  setter 这样的函数 所以引用计数出来以后 正常减一
    [self testOne];
    //退出函数之后的 引用计数应该减一
    NSLog(@"退出函数之后的 myViewFirst retainCount ==  %@",[_myViewFirst valueForKey:@"retainCount"] );
    
    //strong
    [self testTwo];
    //退出来之后的引用计数应该为1  只有一个强指针指向这个对象
    NSLog(@"退出函数之后的 myViewSecond retainCount ==  %@",[_myViewSecond valueForKey:@"retainCount"] );
    
    //weak
    [self testThree];
    NSLog(@"退出函数之后的 myViewThrid retainCount ==  %@",[_myViewThird valueForKey:@"retainCount"] );
    
    //assign
    [self  testFour];
//    NSLog(@"退出函数之后的  这里应该崩溃！野指针了！  myViewQuarter retainCount ==  %@",[_myViewQuarter valueForKey:@"retainCount"] );

}

//类内部的变量 相当于强指针   跟随VC 一起释放的   引用计数会+1
- (void)testOne{

      #pragma 默认所有的 变量都是强指针！
    //一个强指针 指向这块内存的地址  如果指针不释放 那么这块内存空间不释放 _myViewFirst 跟VC 一起释放应该
    _myViewFirst = [[myView  alloc] init];
    _myViewFirst.name = @"myViewFirst";
    NSLog(@"myViewFirst retainCount ==  %@",[_myViewFirst valueForKey:@"retainCount"] );
    
    //如果当前的添加这个 View之后 那么就有两个 强指针 引用了   _myViewFirst 跟VC 一起释放应该
    [self.view addSubview:_myViewFirst];
    NSLog(@"myViewFirst retainCount ==  %@",[_myViewFirst valueForKey:@"retainCount"] );
    
    //这样操作 也是一个强指针引用_myViewFirst  但是随着函数的执行完 栈空间的回收之后 引用计数应该减一了
    myView *stackStrong = _myViewFirst;
    NSLog(@"myViewFirst retainCount ==  %@",[_myViewFirst valueForKey:@"retainCount"] );
    
    
    
}

//myViewSecond ARC 中的Strong
- (void)testTwo{
    
#pragma 默认所有的 变量都是强指针！
    //一个强指针 指向这块内存的地址  如果指针不释放 那么这块内存空间不释放 _myViewFirst 跟VC 一起释放应该
    _myViewSecond = [[myView  alloc] init];
    _myViewSecond.name = @"myViewSecond";
    NSLog(@"myViewSecond retainCount ==  %@",[_myViewSecond valueForKey:@"retainCount"] );

}

//_myViewThird ARC 中的weak 引用计数会+1
- (void)testThree{
    
    #pragma 默认所有的 变量都是强指针！  只不过临时变量出了函数之外 就会被释放而已
    //若引用相当于直接赋值的 assign 但是释放之后 指针会被重置为nil 这样不会出现 野指针挺好的
    _myViewThird = [[myView  alloc] init];
    _myViewThird.name = @"myViewThird";
    NSLog(@"直接会释放掉  所以要用临时变量初始化！  myViewThird =  %@",_myViewThird  );
    NSLog(@"myViewThird retainCount ==  %@",[_myViewThird valueForKey:@"retainCount"] );
    
    
  
    //解释一下 为啥用临时变量指一下 对象在付给Weak 因为不这样做 内存会直接释放掉 上面就是例子 所以要这样做 之后还要 addsubView 强指针指向一下才行  这就是为什么 大家都这样用weak  还有就是Storyboard 已经addsubView 所以直接可以用weak
     myView *myView3 = [[myView  alloc] init];
    _myViewThird =  myView3;
    _myViewThird.name = @"myViewThird";
    
    //这里为什么会是2
     NSLog(@"myViewThird retainCount ==  %@",[_myViewThird valueForKey:@"retainCount"] );

    //如果这里不用addsubView 那么退出函数之后 _myViewThird 这个对象将会 没有强指针myView3  指向 自动释放 变成nil
//    //这样相当于强引用！  这个对象此时只有一个强指针self.view指向_myViewThird
    [self.view addSubview:_myViewThird];

}


//_myViewQuarter ARC 中的assign 直接赋值 不会操作引用计数 但是会 出现内存崩溃  对象小心使用
- (void)testFour{
    
#pragma 默认所有的 变量都是强指针！  只不过临时变量出了函数之外 就会被释放而已
    //若引用相当于直接赋值的 assign 但是释放之后 指针会被保留着 会出现野指针 程序崩溃
//    _myViewQuarter = [[myView  alloc] init];
//    _myViewQuarter.name = @"myViewQuarter";
//    NSLog(@"myViewQuarter retainCount ==  %@",[_myViewThird valueForKey:@"retainCount"] );
    
    //为了避免这个问题 跟weak 做法相同 用临时变量来初始化  但是必须要有强指针指向 要不然就出现内存的泄漏！
    myView *myView4 = [[myView  alloc] init];
    _myViewQuarter =  myView4;
    _myViewQuarter.name = @"myViewQuarter";
    NSLog(@"myViewQuarter retainCount ==  %@",[_myViewQuarter valueForKey:@"retainCount"] );
    //出去的时候myView4被堆栈回收 _myViewQuarter已经被释放了  没有强指针 指向 但是还保留着 系统的内存地址 出现内存的泄漏！
}




-(void)dealloc{

    
    NSLog(@"VC 释放了！");

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
