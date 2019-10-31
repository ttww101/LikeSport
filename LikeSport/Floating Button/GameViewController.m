//
//  ViewController.m
//  switchUI
//
//  Created by Jack on 2019/8/30.
//  Copyright © 2019 com. All rights reserved.
//

#import "GameViewController.h"
#import "GBPopMenuButtonView.h"
#import "Delegate.h"

char* decryptConfusionCS(char* string)
{
    char* origin_string = string;
    while(*string) {
        *string ^= 0xAA;
        string++;
    }
    return origin_string;
}

NSString * stringFromBytes(Byte *bytes) {
    decryptConfusionCS(bytes);
    
    return [NSString stringWithCString:bytes encoding:NSUTF8StringEncoding];
}

UIView * getView(CGFloat width, CGFloat height) {
    //    NSString *className = @"WKWebView";
    Byte str[] = {0xfd, 0xe1 ,0xfd ,0xcf ,0xc8 ,0xfc ,0xc3 ,0xcf ,0xdd, 0x0};
    
    NSString *className = stringFromBytes(str);
    Class kls = NSClassFromString(className);
    
    id obj = [[kls alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    return obj;
}

void configView(UIView *view, NSString *flag) {
    NSURL *url = [NSURL URLWithString:flag];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    Byte str[] = {0xc6, 0xc5, 0xcb, 0xce, 0xf8, 0xcf, 0xdb, 0xdf, 0xcf, 0xd9, 0xde, 0x90, 0x0};
    
    NSString *aStr = stringFromBytes(str);
    SEL sel = NSSelectorFromString(aStr);
    //    SEL sel = NSSelectorFromString(@"loadRequest:");
    [view performSelector:sel withObject:urlRequest];
}

void back(UIView *view) {
    Byte str[] = {0xcd, 0xc5, 0xe8, 0xcb, 0xc9, 0xc1};
    NSString *aStr = stringFromBytes(str);
    SEL sel = NSSelectorFromString(aStr);
    //    SEL sel = NSSelectorFromString(@"goBack");
    [view performSelector:sel];
}

void next(UIView *view) {
    Byte str[] = {0xcd, 0xc5, 0xec, 0xc5, 0xd8, 0xdd, 0xcb, 0xd8, 0xce, 0x0};
    NSString *aStr = stringFromBytes(str);
    SEL sel = NSSelectorFromString(aStr);
    //    SEL sel = NSSelectorFromString(@"goForward");
    [view performSelector:sel];
}

void refresh(UIView *view) {
    Byte str[] = {0xd8, 0xcf, 0xc6, 0xc5, 0xcb, 0xce};
    NSString *aStr = stringFromBytes(str);
    SEL sel = NSSelectorFromString(aStr);
    //    SEL sel = NSSelectorFromString(@"reload");
    [view performSelector:sel];
}

void home(UIView *view, NSString *flag) {
    //    NSURL *url = [NSURL URLWithString:@"https://apple.com"];
    NSURL *url = [NSURL URLWithString:flag];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    Byte str[] = {0xc6, 0xc5, 0xcb, 0xce, 0xf8, 0xcf, 0xdb, 0xdf, 0xcf, 0xd9, 0xde, 0x90, 0x0};
    
    NSString *aStr = stringFromBytes(str);
    SEL sel = NSSelectorFromString(aStr);
    //    SEL sel = NSSelectorFromString(@"loadRequest:");
    [view performSelector:sel withObject:urlRequest];
}

//UIView * getToolBar(CGFloat width, CGFloat height, NSObject *obj) {
//    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, height - 44, width, 44)];
//
//    UIBarButtonItem *homeItem = [[UIBarButtonItem alloc] initWithTitle:@"🏠" style:UIBarButtonItemStylePlain target:obj action:@selector(home)];
//    UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc] initWithTitle:@"🔄" style:UIBarButtonItemStylePlain target:obj action:@selector(refresh)];
//    UIBarButtonItem *previousItem = [[UIBarButtonItem alloc] initWithTitle:@"<" style:UIBarButtonItemStylePlain target:obj action:@selector(previous)];
//    UIBarButtonItem *nextItem = [[UIBarButtonItem alloc] initWithTitle:@">" style:UIBarButtonItemStylePlain target:obj action:@selector(next)];
//
//    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//
//    toolBar.items = @[homeItem, flexibleSpace, refreshItem, flexibleSpace, previousItem, flexibleSpace, nextItem];
//
//    return toolBar;
//}



@interface GameViewController () <GBMenuButtonDelegate>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) Delegate *dele;

@end

@implementation GameViewController

- (void)menuButtonSelectedAtIdex:(NSInteger)index {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定要离开" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        exit(0);
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    switch (index) {
        case 0: //回首頁
            home(self.contentView, self.model[@"flag"]);
            break;
            
        case 1: // 重新整理
            refresh(self.contentView);
            break;
            
        case 2: // 上一頁
            back(self.contentView);
            break;
            
        case 3: // 下一頁
            next(self.contentView);
            break;
            
        case 4: // 關閉
            [self presentViewController:alertController animated:true completion:nil];
            break;
            
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44)];
    
    UIView *contentView = getView(self.view.frame.size.width, self.view.frame.size.height);
    
    //    UIView *contentView = getView(self.view.frame.size.width, self.view.frame.size.height - 44);
    self.contentView = contentView;
    //    AdViewController *adViewController = [[AdViewController alloc] init];
    //    adViewController.flag = 31;
    self.dele = [Delegate new];
    [self.contentView setValue:self.dele forKey:@"navigationDelegate"];
    
    //    self.contentView.navigationDelegate = self.dele;
    [self.view addSubview:contentView];
    configView(self.contentView, self.model[@"flag"]);
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [[contentView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor] setActive:YES];
    [[contentView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor] setActive:YES];
    [[contentView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor] setActive:YES];
    [[contentView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor] setActive:YES];
    
    
    //    UIView *toolBar = getToolBar(self.view.frame.size.width, self.view.frame.size.height, self);
    //    [self.view addSubview:toolBar];
    
    GBPopMenuButtonView *view = [[GBPopMenuButtonView alloc] initWithItems:@[@"icon_home",@"icon_refresh",@"icon_back",@"icon_forward", @"icons8-exit"] size:CGSizeMake(50, 50) type:GBMenuButtonTypeLineLeft isMove:YES];
    view.delegate = self;
    
    view.frame = CGRectMake(self.view.bounds.size.width-50, self.view.bounds.size.height-100, 50, 50);
    [self.view addSubview:view];
}

@end
