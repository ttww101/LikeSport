//
//  AdViewController.m
//  LikeSport
//
//  Created by Jack on 2019/8/26.
//  Copyright © 2019 swordfish. All rights reserved.
//

#import "AdViewController.h"
#import "AppDelegate.h"

@interface AdViewController () <WKNavigationDelegate, WKUIDelegate>

@end

@implementation AdViewController
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"sjklajdfjasfkadksl");
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
        NSURL *url = navigationAction.request.URL;
        
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.adView];
    self.adView.navigationDelegate = self;
//    [self.adView setValue:self forKey:@"navigationDelegate"];
    
    if ([self.model[@"type"] isEqualToString:@"ad"]) {
        UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 40, 20, 30, 30)];
        UIImage *closeImage = [UIImage imageNamed:@"close"];
        [closeBtn setImage:closeImage forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:closeBtn];
    } else {
//        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.height, 44)];
//        [self.view addSubview:toolBar];
//        
//        UIButton *homeBtn = [[UIButton alloc] init];
//        [homeBtn setTitle:@"🏠" forState:UIControlStateNormal];
//        
//        [homeBtn addTarget:self action:@selector(home) forControlEvents:UIControlEventTouchUpInside];
//        
//        UIButton *refreshBtn = [[UIButton alloc] init];
//        [refreshBtn setTitle:@"🔄" forState:UIControlStateNormal];
//        [refreshBtn addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
//
//        UIButton *previousBtn = [[UIButton alloc] init];
//        [previousBtn setTitle:@"<" forState:UIControlStateNormal];
//        [previousBtn addTarget:self action:@selector(previous) forControlEvents:UIControlEventTouchUpInside];
//
//        UIButton *nextBtn = [[UIButton alloc] init];
//        [nextBtn setTitle:@">" forState:UIControlStateNormal];
//        [nextBtn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
//        
//        UIBarButtonItem *homeItem = [[UIBarButtonItem alloc] initWithTitle:@"🏠" style:<#(UIBarButtonItemStyle)#> target:<#(nullable id)#> action:<#(nullable SEL)#>]
//        UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc] initWithCustomView:refreshBtn];
//        UIBarButtonItem *previousItem = [[UIBarButtonItem alloc] initWithCustomView:previousBtn];
//        UIBarButtonItem *nextItem = [[UIBarButtonItem alloc] initWithCustomView:nextBtn];
//        
//        toolBar.items = @[homeItem, refreshItem, previousItem, nextItem];

    }
    NSURL *url = [NSURL URLWithString:self.model[@"flag"]];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:15];

    [self.adView loadRequest: request];
    
}



//
//- (void)home {
//    NSURL *url = [NSURL URLWithString:self.model[@"flag"]];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [self.adView loadRequest: request];
//}
//
//- (void)refresh {
//    [self.adView reload];
//}
//
//- (void)next {
//    [self.adView goForward];
//}
//
//- (void)previous {
//    [self.adView goBack];
//}
//
//
- (void)close {
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    [delegate.window makeKeyAndVisible];
}

- (WKWebView *)adView {
    if (!_adView) {
        _adView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }
    return _adView;
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
