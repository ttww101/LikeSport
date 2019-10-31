//
//  HorizontalMenuView.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/7/18.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "HorizontalMenuView.h"

@implementation HorizontalMenuView

- (void)setNameWithArray:(NSArray *)menuArray andIndex:(NSInteger)index {
    _menuArray = menuArray;
    
    CGFloat SPACE = (self.frame.size.width)/_menuArray.count;
    
    for (int i = 0; i < menuArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.frame = CGRectMake(SPACE*i, 0, SPACE, self.frame.size.height);
        
        btn.tag = i;
        if (btn.tag == index) {
            btn.enabled = NO;
        }
        if (i == menuArray.count-1) {
            [btn setImage:[UIImage imageNamed:@"calendar"] forState:UIControlStateNormal];
//            btn.imageEdgeInsets = UIEdgeInsetsMake(-5, -5, -5, -5);
        } else {
            // 设置按钮字体大小 颜色 状态
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[menuArray objectAtIndex:i]];
            [str addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor grayColor]} range:NSMakeRange(0, str.length)];
            [btn setAttributedTitle:str forState:UIControlStateNormal];
            
            NSMutableAttributedString *selStr = [[NSMutableAttributedString alloc]initWithString:[menuArray objectAtIndex:i]];
            [selStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor orangeColor]} range:NSMakeRange(0, str.length)];
            [btn setAttributedTitle:selStr forState:UIControlStateDisabled];
            
            btn.titleLabel.numberOfLines = 2;
        }

        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        // 分割线
        if (i>0 && self.frame.size.height>16) {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(SPACE*i, 8, 1,self.frame.size.height-16)];
            line.backgroundColor = [UIColor grayColor];
            [self addSubview:line];
        }
    }
    
//    // 底部划线
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-2.5, self.frame.size.width, 1)];
//    line.backgroundColor = [UIColor lightGrayColor];
//    [self addSubview:line];
//
//    // 标识当选被选中下划线
//    UIView *markLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-3, SPACE+1, 3)];
//    markLine.tag = 999;
//    markLine.backgroundColor = [UIColor orangeColor];
//    [self addSubview:markLine];
}


#pragma mark - 菜单按钮点击事件
- (void)btnClick:(UIButton *)sender {
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *subBtn = (UIButton *)subView;
            if (subView.tag == sender.tag && sender.tag != 5) {
                [subBtn setEnabled:NO];
            } else {
                [subBtn setEnabled:YES];
            }
        }
    }
    
    // 计算每个按钮间隔
    CGFloat SPACE = (self.frame.size.width)/_menuArray.count;
    
    UIView *markView = [self viewWithTag:999];
    [UIView animateWithDuration:0.2f animations:^{
        CGRect markFrame = markView.frame;
        markFrame.origin.x = sender.tag * SPACE;
        markView.frame = markFrame;
        
    }];
    
    if ([self.delegate respondsToSelector:@selector(getTag:)]) {
        [self.delegate getTag:sender.tag];
    }
}

// 设置选中的按钮
- (void)setBtnWithTag:(NSInteger)tag {
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *subBtn = (UIButton *)subView;
            if (subView.tag == tag && tag != 5) {
                [subBtn setEnabled:NO];
            } else {
                [subBtn setEnabled:YES];
            }
        }
    }
}

//- (void)setBtnEnabled {
//    for (UIView *subView in self.subviews) {
//        if ([subView isKindOfClass:[UIButton class]]) {
//            UIButton *subBtn = (UIButton *)subView;
////            [subBtn setEnabled:YES];
//            subBtn.userInteractionEnabled = YES;
//        }
//    }
//}
//
//- (void)setBtnDisenabled {
//    for (UIView *subView in self.subviews) {
//        if ([subView isKindOfClass:[UIButton class]]) {
//            UIButton *subBtn = (UIButton *)subView;
////            [subBtn setEnabled:NO];
//            subBtn.userInteractionEnabled = NO;
//
//        }
//    }
//}
@end
