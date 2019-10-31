//
//  AGIntroduceViewController.h
//  AGIntroduceViewController
//
//  Created by amG on 2019/10/3.
//  Copyright © 2019 PrototypeC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AGIntroduceViewController : UIViewController

- (instancetype)initWithImages:(NSArray <UIImage *>*)images;
- (void)setBackgroundColor:(UIColor *)color;
- (void)setPageControlSelectedColor:(UIColor *)color;
- (void)setPageControlUnSelectedColor:(UIColor *)color;

@property (nonatomic, copy) void (^endBlock)(void);
@property (assign, nonatomic) BOOL isLastPageShowDoneButton;

@end
