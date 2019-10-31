//
//  KSExpansionCell.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/5/10.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KSLiveFrame;
@class KSMore;
@class KSLive;
@interface KSExpansionCell : UITableViewCell
@property (nonatomic, strong) KSLiveFrame *liveF;
@property (nonatomic, strong) NSMutableArray<KSMore *> *more;
@property (nonatomic, strong) KSLive *live;


@property (weak, nonatomic) UILabel *hteamnameView;
@property (weak, nonatomic) UILabel *cteamnameView;
@property (weak, nonatomic) UILabel *full_bfView;
@property (weak, nonatomic) UILabel *half_bfView;



+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
