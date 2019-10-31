//
//  KSTeamDetailTableViewCell.h
//  LikeSport
//
//  Created by 罗剑玉 on 2017/4/8.
//  Copyright © 2017年 swordfish. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^pushblock)();
@interface KSTeamDetailTableViewCell : UITableViewCell
@property (nonatomic, strong) UIButton *titlelabel;
@property (nonatomic, strong) UIView *lolview;

@property(nonatomic,copy)pushblock pushAction;
@end
