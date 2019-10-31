//
//  KSLiveCell.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/4/26.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KSLiveFrame;
@class KSLive;
@class KSMore;
@class KSLiveView;
@protocol KSLiveCellDelegate <NSObject>

@optional
- (void)moreTable:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
- (void)followTable:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
@end
@interface KSLiveCell : UITableViewCell


@property (nonatomic, strong) KSLiveFrame *liveF;
@property (nonatomic, strong) NSMutableArray<KSMore *> *more;
@property (nonatomic, strong) KSLive *live;

@property(nonatomic, weak) KSLiveView *liveView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
+ (instancetype)footballCellWithTableView:(UITableView *)tableView;

@property (weak, nonatomic) id<KSLiveCellDelegate> delegate;

- (void)changeArrowWithUp:(BOOL)up;

@end
