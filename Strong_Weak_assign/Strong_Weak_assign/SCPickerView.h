//
//  SCPickerView.h
//  Strong_Weak_assign
//
//  Created by 王剑亮 on 2017/3/30.
//  Copyright © 2017年 王剑亮. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SCDateTimeDelegate <NSObject>
//更改高度
-(void)oneTimeCellHeightChange:(BOOL)ifChosen;
//更改内容
-(void)oneTimePickerValueChanged:(NSString *)dateString;

@end

@interface SCPickerView : UIView
@property BOOL ifChosen;
@property (assign, nonatomic) id<SCDateTimeDelegate> delegate;

-(void)reloadWithDate:(NSString *)dateString;
-(void)pickerViewSetDate:(NSDate *)date;
-(void)grayViewAnimation;
-(void)showPickerViewAnimation;
-(void)fadePickerViewAnimation;

@end
