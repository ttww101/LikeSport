//
//  AdViewController.h
//  LikeSport
//
//  Created by Jack on 2019/8/26.
//  Copyright © 2019 swordfish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>


@interface AdViewController : UIViewController
@property (strong, nonatomic) WKWebView *adView;
@property (strong, nonatomic) NSDictionary *model;
@property (assign, nonatomic) int flag;

@end
