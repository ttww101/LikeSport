//
//  KSExpansionCell.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/5/10.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "KSExpansionCell.h"
#import "KSExpansionView.h"
#import "KSLiveFrame.h"
#import "KSMore.h"
#import "KSLive.h"
#import "KSFootballExpansion.h"
@interface KSExpansionCell ()

@property(nonatomic,weak) KSExpansionView *expansionView;
@property (weak, nonatomic) KSFootballExpansion *footballExpansion;

@end
@implementation KSExpansionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 足球展开
        KSFootballExpansion *footballExpansion = [[KSFootballExpansion alloc] init];
        [self addSubview:footballExpansion];
        _footballExpansion = footballExpansion;
 
        KSExpansionView *expansionView = [[KSExpansionView alloc] init];
        [self addSubview:expansionView];
        _expansionView = expansionView;

        
    }
    return self;
}

//- (void)setFootballExpansion:(KSFootballExpansion *)footballExpansion
//{
//    if (!_footballExpansion) {
//        KSFootballExpansion *footballExpansion = [[KSFootballExpansion alloc] init];
//        [self addSubview:footballExpansion];
//        _footballExpansion = footballExpansion;
//    }
//}

- (void)setLive:(KSLive *)live
{
    _live = live;
    _footballExpansion.live = live;

}

- (void)setMore:(NSMutableArray<KSMore *> *)more
{
    _more = more;
    _footballExpansion.more = more;
}




- (void)setLiveF:(KSLiveFrame *)liveF
{
    _liveF = liveF;
    
    _expansionView.frame = liveF.liveViewFrame;
    _expansionView.liveF = liveF;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"expansionCell";
    id cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
