//
//  KSEventCell.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/5/19.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "KSEventCell.h"
@interface KSEventCell()
//@property (weak, nonatomic) IBOutlet UILabel *proctime;
//@property (weak, nonatomic) IBOutlet UIImageView *hAction;
//@property (weak, nonatomic) IBOutlet UIImageView *cAction;
//@property (weak, nonatomic) IBOutlet UILabel *hPlayer;
//@property (weak, nonatomic) IBOutlet UILabel *cPlayer;
@property (weak, nonatomic)  UILabel *proctime;
@property (weak, nonatomic)  UIImageView *hAction;
@property (weak, nonatomic)  UIImageView *cAction;
@property (weak, nonatomic)  UILabel *hPlayer;
@property (weak, nonatomic)  UILabel *cPlayer;
@end
@implementation KSEventCell

- (void)prepareForReuse {
    [super prepareForReuse];
    self.proctime.text = @"";
    self.hAction.image = nil;
    self.cAction.image = nil;
    self.hPlayer.text = @"";
    self.cPlayer.text = @"";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setUpAllChildView];
        
    }
    return self;
}

- (void)setUpAllChildView{
    CGFloat min = kSceenWidth/2;
    CGFloat imageWidth = 30;
    CGFloat timeWidth = 30;
    CGFloat place = 5;
    
    UILabel *proctime = [[UILabel alloc] initWithFrame:CGRectMake(min-timeWidth/2, 0, timeWidth, imageWidth)];
    proctime.font = [UIFont systemFontOfSize:15];
    proctime.textAlignment = NSTextAlignmentCenter;
    [self addSubview:proctime];
    _proctime = proctime;
    
    UIImageView *hAction = [[UIImageView alloc] initWithFrame:CGRectMake(min-timeWidth/2-imageWidth, place, imageWidth-2*place, imageWidth-2*place)];
    [self addSubview:hAction];
    _hAction = hAction;
    
    UILabel *hPlayer = [[UILabel alloc] initWithFrame:CGRectMake(place, 0, min-timeWidth/2-imageWidth-place, imageWidth)];
    hPlayer.font = [UIFont systemFontOfSize:12];
    hPlayer.numberOfLines = 2;
    hPlayer.textAlignment = NSTextAlignmentCenter;
    [self addSubview:hPlayer];
    _hPlayer = hPlayer;
    
    UIImageView *cAction = [[UIImageView alloc] initWithFrame:CGRectMake(min+timeWidth/2, place, imageWidth-2*place, imageWidth-2*place)];
    [self addSubview:cAction];
    _cAction = cAction;
    
    UILabel *cPlayer = [[UILabel alloc] initWithFrame:CGRectMake(min+timeWidth/2+imageWidth, 0, min-timeWidth/2-imageWidth-place, imageWidth)];
    cPlayer.font = [UIFont systemFontOfSize:12];
    cPlayer.numberOfLines = 2;
    cPlayer.textAlignment = NSTextAlignmentCenter;
    [self addSubview:cPlayer];
    _cPlayer = cPlayer;
}

- (void)setMore:(KSMore *)more
{
    _more = more;
    _proctime.text = [NSString stringWithFormat:@"%li'",(long)_more.proctime];
    if ([_more.teamtag isEqualToString:@"H"]) {
        _hPlayer.text = _more.playername;
        if ([_more.actiontype isEqualToString:@"s"]) {
            _hPlayer.text = [_more.playername stringByReplacingOccurrencesOfString:@"|" withString:@"\n"];
        }
        [self eventWithAction:_hAction];

//        [_hAction setImage:[UIImage imageNamed:@"football"]];

    } else if ([_more.teamtag isEqualToString:@"C"]){
        _cPlayer.text = _more.playername;
        if ([_more.actiontype isEqualToString:@"s"]) {
            _cPlayer.text = [_more.playername stringByReplacingOccurrencesOfString:@"|" withString:@"\n"];
        }
        [self eventWithAction:_cAction];
    }
}

- (void)eventWithAction:(UIImageView *)action{ //↑ ↓
    NSString *theString = _more.actiontype;
    NSArray *items = @[@"g",@"p",@"o",@"y",@"r",@"t",@"s",@"x",@"z"];
    NSInteger item = [items indexOfObject:theString];
    switch (item) {
        case 0:
            [action setImage:[UIImage imageNamed:@"icon_events_goal_medium"]];
            break;
        case 1:
            action.image = [UIImage imageNamed:@"icon_events_penaltyGoal_medium"];
//            action.tintColor = [UIColor yellowColor];
            break;
        case 2:
            action.image = [UIImage imageNamed:@"icon_events_ownGoal_medium"];
//            action.tintColor = [UIColor blackColor];
            break;
        case 3:
            action.image = [UIImage imageNamed:@"icon_events_yellowCard_medium"];
//            action.backgroundColor = [UIColor yellowColor];
            break;
        case 4:
            action.image = [UIImage imageNamed:@"icon_events_redCard_medium"];
//            action.backgroundColor = [UIColor redColor];
            break;
        case 5:
            action.image = [UIImage imageNamed:@"icon_events_red_yellow_card"];
            
            break;
        case 6:
            action.image = [UIImage imageNamed:@"icon_events_sub_medium"];
            break;
        case 7:
//            action.image = [UIImage imageNamed:@"football"];
            break;
        case 8:
            
            break;
            
        default:
            break;
    }
}


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"eventCell";
    id cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
