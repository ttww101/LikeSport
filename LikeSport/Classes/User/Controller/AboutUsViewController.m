//
//  AboutUsViewController.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/9/7.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "AboutUsViewController.h"
#import "AppDelegate.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake((kSceenWidth-60)/2, 20, 60, 60)];
    icon.image = [UIImage imageNamed:@"icon"];
    [self.view addSubview:icon];
    
    
    UILabel *VersionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, kSceenWidth-20, 20)];
//    label.text = @"语音技术由科大讯飞提供";
    VersionLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedStringFromTable(@"快手体育", @"InfoPlist", nil),[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    VersionLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:VersionLabel];
    
    UIButton *companyBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 140, kSceenWidth-20, 20)];
    [companyBtn setTitle:[NSString stringWithFormat:@"%@: %@",NSLocalizedStringFromTable(@"Official Website", @"InfoPlist", nil),@"www.likesport.com"] forState:UIControlStateNormal];
    [companyBtn setTitleColor:KSBlue forState:UIControlStateNormal];
    [companyBtn addTarget:self action:@selector(pushToOfficialWebsite) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:companyBtn];
//    UILabel *companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 140, kSceenWidth-20, 20)];
    //    label.text = @"语音技术由科大讯飞提供";
//    companyLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedStringFromTable(@"Official Website", @"InfoPlist", nil),@"htttp://www.likesport.com"];
//    companyLabel.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:companyLabel];
}

- (void)pushToOfficialWebsite{
    NSURL *url = [NSURL URLWithString:@"http://www.likesport.com"];
//    NSString *textURL = @"http://www.yoururl.com/";
//    NSURL *cleanURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", textURL]];
    [[UIApplication sharedApplication] openURL:url];
//    [[UIApplication shareApplication] openURL:url];
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
