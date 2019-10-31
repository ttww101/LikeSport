//
//  KSLiveTableViewCell.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/4/7.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSLive.h"

@class KSLiveTableViewCell;

@protocol KSExpansionCellDelegate <NSObject>

@optional
- (void)expansionTable:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end


@interface KSLiveTableViewCell : UITableViewCell



@property (nonatomic, strong) KSLive *live;

// 声明点击展开按钮要执行的代码块
//@property (nonatomic, strong) void(^btnClick)();

@property (weak, nonatomic) id<KSExpansionCellDelegate> delegate;


@end
