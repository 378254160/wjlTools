//
//  SCPickerView.m
//  Strong_Weak_assign
//
//  Created by 王剑亮 on 2017/3/30.
//  Copyright © 2017年 王剑亮. All rights reserved.
//

#import "SCPickerView.h"

@interface SCPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (strong, nonatomic) NSString *timeString;
@property (strong, nonatomic) NSString *dateString;

@property (strong,nonatomic) NSDateFormatter *myFomatter;
@property (strong,nonatomic) NSCalendar *calendar;
//显示的date用于显示出来星期
@property (strong,nonatomic) NSDate *weekdayDate;
@property (strong,nonatomic) NSDate *selectedDate;
@property (strong,nonatomic) NSDate *pickerStartDate;
@property (strong,nonatomic) NSDate *pickEndDate;
@property (strong,nonatomic) NSDateComponents *selectedComponents;
@property (strong,nonatomic) UIPickerView *datePickerView;
@property NSInteger unitFlags;

@end

@implementation SCPickerView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.datePickerView = [[UIPickerView alloc]initWithFrame:self.bounds];
        [self addSubview:_datePickerView];
        self.datePickerView.hidden = NO;
        self.datePickerView.delegate = self;
        self.datePickerView.dataSource = self;
        
        [self setDefaultDate];
        [self pickerViewSetDate:self.selectedDate];
    }
    
    return self;
}
- (void)setDefaultDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    self.timeString = [formatter stringFromDate:[NSDate date]];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    self.dateString = [formatter stringFromDate:[NSDate date]];
    [self reloadWithDate:self.timeString];
    

}
#pragma mark SubView Methods
-(void)reloadWithDate:(NSString *)dateString{
    [self setFomatter];
    self.selectedDate = [self.myFomatter dateFromString:dateString];
    self.selectedComponents = [self.calendar components:self.unitFlags fromDate:self.selectedDate];
}

#pragma mark Private Methods
-(void)setFomatter{
    self.myFomatter = [[NSDateFormatter alloc]init];
    [self.myFomatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    self.calendar = [NSCalendar currentCalendar];
    self.selectedDate = [NSDate date];
//    self.pickerStartDate = [self.myFomatter dateFromString:@"1900年2月1日 13:59"];
    self.pickerStartDate = [NSDate date];
    self.pickEndDate = [self.myFomatter dateFromString:@"2100年12月31日 13:59"];
    self.unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute;
}

#pragma mark Animation Methods
//模拟tableviewcell点击动画
-(void)grayViewAnimation{

}

//渐显
-(void)showPickerViewAnimation{
    [self grayViewAnimation];
    self.datePickerView.hidden = NO;
    [self.datePickerView setAlpha:0];
    [UIView animateWithDuration:0.2
                     animations:^{
                         [self.datePickerView setAlpha:1];
                     }];
}

//渐隐
-(void)fadePickerViewAnimation{

    [UIView animateWithDuration:0.2
                     animations:^{
                         [self.datePickerView setAlpha:0];
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             self.datePickerView.hidden = YES;
                         }
                     }];
}

// 模拟datepicker setdate 方法   这里决定显示的时候 列 初始化 行的位置
-(void)pickerViewSetDate:(NSDate *)date{
//    NSDateComponents *temComponents = [[NSDateComponents alloc]init];
//    temComponents = [self.calendar components:NSCalendarUnitYear fromDate:date];
    
    NSInteger yearRow = 0;
    NSInteger monthRow = [[self.calendar components:NSCalendarUnitMonth fromDate:date] month] - 1;
    NSInteger dayRow = [[self.calendar components:NSCalendarUnitDay fromDate:date] day] - 1;
    NSInteger hourRow = [[self.calendar components:NSCalendarUnitHour fromDate:date] hour];
    NSInteger minRow = [[self.calendar components:NSCalendarUnitMinute fromDate:date] minute] / 15;
    
    [self.datePickerView selectRow:yearRow inComponent:0 animated:YES];
    [self.datePickerView selectRow:monthRow inComponent:1 animated:YES];
    [self.datePickerView selectRow:dayRow inComponent:2 animated:YES];
    [self.datePickerView selectRow:hourRow inComponent:3 animated:YES];
    [self.datePickerView selectRow:minRow inComponent:4 animated:YES];
}

#pragma mark IBAction Methods
- (void)setDateButtonClicked:(id)sender {
    [self.delegate oneTimeCellHeightChange:self.ifChosen];
    if (!self.ifChosen) {
        [self pickerViewSetDate:self.selectedDate];
        self.ifChosen = !self.ifChosen;
        [self showPickerViewAnimation];
        [self grayViewAnimation];
    }else{
        self.ifChosen = !self.ifChosen;
        [self fadePickerViewAnimation];
        [self grayViewAnimation];
    }
}

#pragma mark - UIPickerViewDataSource Methods
- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view
{
    UILabel *dateLabel = (UILabel *)view;
    if (!dateLabel) {
        dateLabel = [[UILabel alloc] init];
        [dateLabel setFont:[UIFont systemFontOfSize:17]];
    }
    
    switch (component) {
        case 0: {
            NSDateComponents *components = [self.calendar components:NSCalendarUnitYear
                                                            fromDate:self.pickerStartDate];
            NSString *currentYear = [NSString stringWithFormat:@"%ld年", [components year] + row];
            [dateLabel setText:currentYear];
            dateLabel.textAlignment = NSTextAlignmentCenter;
            break;
        }
        case 1: {
            NSString *currentMonth = [NSString stringWithFormat:@"%ld月",(long)row+1];
            [dateLabel setText:currentMonth];
            dateLabel.textAlignment = NSTextAlignmentCenter;
            break;
        }
        case 2: {
            
            CGRect rect = dateLabel.frame;
            rect.size.width  +=  100;
            dateLabel.frame = rect;
            
            NSRange dateRange = [self.calendar rangeOfUnit:NSCalendarUnitDay
                                                    inUnit:NSCalendarUnitMonth
                                                   forDate:self.selectedDate];
//            NSCalendarUnit unitFlags = NSCalendarUnitYear | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
//            NSDateComponents *comps = [[NSDateComponents alloc] init];
//            [self.selectedComponents setDay:(row + 1) % (dateRange.length + 1)];
//            self.weekdayDate = [self.calendar dateFromComponents:self.selectedComponents];
//            comps = [self.calendar components:unitFlags fromDate:self.weekdayDate];  //,  [self numberToWekDay:[comps weekday] ]
            NSString *currentDay = [NSString stringWithFormat:@"%lu日", (row + 1) % (dateRange.length + 1) ];
            [dateLabel setText:currentDay];
            dateLabel.textAlignment = NSTextAlignmentCenter;
            break;
        }
        case 3:{
            NSString *currentHour = [NSString stringWithFormat:@"%ld时",(long)row];
            [dateLabel setText:currentHour];
            dateLabel.textAlignment = NSTextAlignmentCenter;
            break;
        }
        case 4:{
            NSString *currentMin = [NSString stringWithFormat:@"%02ld分",row*15];
            [dateLabel setText:currentMin];
            dateLabel.textAlignment = NSTextAlignmentCenter;
        }
        default:
            break;
    }
    
    return dateLabel;
}

- (NSString *)numberToWekDay:(NSInteger)number{

    switch (number) {
            case 1: return @"星期天";
            case 2: return @"星期一";
            case 3: return @"星期二";
            case 4: return @"星期三";
            case 5: return @"星期四";
            case 6: return @"星期五";
            case 7: return @"星期六";
    }
  return @"XXX";
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 5;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:{
            NSDateComponents *startCpts = [self.calendar components:NSCalendarUnitYear
                                                           fromDate:self.pickerStartDate];
            NSDateComponents *endCpts = [self.calendar components:NSCalendarUnitYear
                                                         fromDate:self.pickEndDate];
            return [endCpts year] - [startCpts year] + 1;
        }
            
        case 1:
            return 12;
        case 2:{
            NSRange dayRange = [self.calendar rangeOfUnit:NSCalendarUnitDay
                                                   inUnit:NSCalendarUnitMonth
                                                  forDate:self.selectedDate];
            return dayRange.length;
        }
        case 3:
            return 24;
        case 4:
            return 4;
        default:
            break;
    }
    return 0;
}

//每次修改都要执行的方法
-(void)changeDateLabel{
    self.selectedDate = [self.calendar dateFromComponents:self.selectedComponents];
    NSString *selectedDateString = [self.myFomatter stringFromDate:self.selectedDate];
    [self.delegate oneTimePickerValueChanged:selectedDateString];
}

#pragma mark - UIPickerViewDelegate Methods
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    
    switch (component) {
        case 0:
        {
            NSDateComponents *comps = [[NSDateComponents alloc] init];
            comps = [self.calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
            NSInteger year = [comps year] + row ;
            [self.selectedComponents setYear:year];
            [self changeDateLabel];
        }
            break;
        case 1:
        {
            [self.selectedComponents setMonth:row+1];
            [self changeDateLabel];
        }
            break;
        case 2:
        {
            [self.selectedComponents setDay:row +1];
            [self changeDateLabel];        }
            break;
        case 3:
        {
            [self.selectedComponents setHour:row];
            [self changeDateLabel];
        }
            break;
        case 4:
        {
            [self.selectedComponents setMinute:row*15];
            [self changeDateLabel];
        }
    }
    [self.datePickerView reloadAllComponents];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component

{
    return 35.0;
}

//  第component列的宽度是多少
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if (component == 0) {
        return 0;
    }else  if (component == 1) {
        return 50;
    }else  if (component == 2) {
        return 100;
    }else if (component == 3) {
        return 50;
    }else {
    
      return 50;
    }

}


@end
