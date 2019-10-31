//
//  KSFontSizeController.m
//  LikeSport
//
//  Created by 罗剑玉 on 2016/11/15.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "KSFontSizeController.h"

@interface KSFontSizeController ()<UIGestureRecognizerDelegate>
{
    UISlider *slider;
    NSArray *numbers;
}

@end

@implementation KSFontSizeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    "Text Size"="Text Size";
//    "Standard"="Standard";
    self.navigationItem.title = NSLocalizedStringFromTable(@"Text Size", @"InfoPlist", nil);

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 100, kSceenWidth, 80)];
    [self.view addSubview:view];
    
    UILabel *smallLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 10, 20, 20)];
    smallLabel.text = @"A";
    smallLabel.font = [UIFont systemFontOfSize:14];
    [view addSubview:smallLabel];
    
    UILabel *bigLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSceenWidth-25-20, 10, 20, 20)];
    bigLabel.text = @"A";
    bigLabel.font = [UIFont systemFontOfSize:20];
    [view addSubview:bigLabel];
    
    slider = [[UISlider alloc] initWithFrame:CGRectMake(20.0,40,kSceenWidth-40,20.0)];
    [view addSubview:slider];
    
    numbers = @[@(1), @(2), @(3), @(4), @(5), @(6), @(7)];
    // slider values go from 0 to the number of values in your numbers array
    NSInteger numberOfSteps = ((float)[numbers count] - 1);
    slider.maximumValue = numberOfSteps;
    slider.minimumValue = 0;
    [slider setThumbTintColor:KSBlue];
    [slider setMinimumTrackTintColor:KSBlue];
    [slider setMaximumTrackTintColor:KSBlue];
    slider.continuous = YES; // NO makes it call only once you let go
    [slider addTarget:self
               action:@selector(valueChanged:)
     forControlEvents:UIControlEventValueChanged];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapGesture:)];
    tapGesture.delegate = self;
    [slider addGestureRecognizer:tapGesture];
    
//    CGFloat width = kSceenWidth-40/5;
//    for (int i = 0; i < 6; i++) {
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i*width, 0, 1, 20)];
//        view.backgroundColor = KSBlue;
//        [slider addSubview:view];
//    }

}

- (void)actionTapGesture:(UITapGestureRecognizer *)sender {
    CGPoint touchPoint = [sender locationInView:slider];
    NSInteger value = (slider.maximumValue - slider.minimumValue) * (touchPoint.x / slider.frame.size.width )+0.5;
    [slider setValue:value animated:YES];
//        NSLog(@"number: %li", (long)value);
    [self saveValue:[NSString stringWithFormat:@"%li",(long)value+1] withKey:@"fontSize"];
}

- (void)valueChanged:(UISlider *)sender {
    // round the slider position to the nearest index of the numbers array
    NSUInteger index = (NSUInteger)(slider.value + 0.5);
    [slider setValue:index animated:NO];
    NSNumber *number = numbers[index]; // <-- This numeric value you want
//    NSLog(@"sliderIndex: %i", (int)index);
//    NSLog(@"number: %@", number);
    [self saveValue:[NSString stringWithFormat:@"%@",number] withKey:@"fontSize"];
}

//- (void) sliderValueChanged:(id)sender{
////    UISlider* control = (UISlider*)sender;
////    if(control == mySlider){
////        float value = control.value;
////        /* 添加自己的处理代码 */
////    }
//    if ([sender isKindOfClass:[UISlider class]]) {
//        UISlider * slider = sender;
//        CGFloat value = slider.value;
//        NSLog(@"slider=%f", value);
//        self.view.backgroundColor = [UIColor colorWithRed:value green:value blue:value alpha:value];
//    }
//}

#pragma mark - 字段持久缓存(保存在数据库)
- (void)saveValue:(NSString *)value withKey:(NSString *)key
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
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
