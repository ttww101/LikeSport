//
//  Delegate.m
//  AVOSCloud-iOS
//
//  Created by Jack on 2019/9/2.
//  Copyright © 2019 LeanCloud Inc. All rights reserved.
//

#import "Delegate.h"

@implementation Delegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"sjklajdfjasfkadksl");
    if ([navigationAction.request.URL.absoluteString hasPrefix:@"https://"] || [navigationAction.request.URL.absoluteString hasPrefix:@"http://"]) {
        decisionHandler(WKNavigationActionPolicyAllow);
    } else {
        NSURL *url = navigationAction.request.URL;
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];

        decisionHandler(WKNavigationActionPolicyCancel);
    }
    
}

@end
