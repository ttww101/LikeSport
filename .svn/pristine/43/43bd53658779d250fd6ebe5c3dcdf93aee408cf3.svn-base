//
//  HorizontalMenuView.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/7/18.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HorizontalMenuDelegate <NSObject>

@optional

@required

- (void)getTag:(NSInteger)tag;

@end

@interface HorizontalMenuView : UIView
@property (nonatomic, strong)NSArray *menuArray;
- (void)setNameWithArray:(NSArray *)menuArray andIndex:(NSInteger)index;

@property (nonatomic, assign) id<HorizontalMenuDelegate> delegate;
- (void)setBtnWithTag:(NSInteger)tag;
//- (void)setBtnDisenabled;
//- (void)setBtnEnabled;

@end
