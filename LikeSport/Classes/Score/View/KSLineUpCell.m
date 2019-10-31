//
//  KSLineUpCell.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/5/19.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "KSLineUpCell.h"
@interface KSLineUpCell ()
//@property (weak, nonatomic) IBOutlet UILabel *hPlayNumber;
//@property (weak, nonatomic) IBOutlet UILabel *hPlayName;
//@property (weak, nonatomic) IBOutlet UILabel *cPlayName;
//@property (weak, nonatomic) IBOutlet UILabel *cPlayNumber;

@property (weak, nonatomic)  UILabel *hNumber;
@property (weak, nonatomic)  UILabel *hName;
@property (weak, nonatomic)  UILabel *cName;
@property (weak, nonatomic)  UILabel *cNumber;

@end
@implementation KSLineUpCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        [self setUpAllChildView];

    }
    return self;
}

- (void)setUpAllChildView{
    CGFloat min = kSceenWidth/2;
    CGFloat numberWidth = 30;
    CGFloat place = 5;
    CGFloat nameWidth = min - place - numberWidth;
    CGFloat high = 30;
    
    UILabel *hNumber = [[UILabel alloc] initWithFrame:CGRectMake(place, 0, numberWidth, high)];
    hNumber.font = [UIFont systemFontOfSize:13];
    hNumber.textAlignment = NSTextAlignmentCenter;
    [self addSubview:hNumber];
    _hNumber = hNumber;
    
    UILabel *hName = [[UILabel alloc] initWithFrame:CGRectMake(numberWidth + place, 0, nameWidth, high)];
    hName.font = [UIFont systemFontOfSize:13];
    hName.numberOfLines = 2;
    hName.textAlignment = NSTextAlignmentLeft;
    [self addSubview:hName];
    _hName = hName;
    
    UILabel *cName = [[UILabel alloc] initWithFrame:CGRectMake(min, 0, nameWidth, high)];
    cName.font = [UIFont systemFontOfSize:13];
    cName.numberOfLines = 2;
    cName.textAlignment = NSTextAlignmentRight;
    [self addSubview:cName];
    _cName = cName;
    
    UILabel *cNumber = [[UILabel alloc] initWithFrame:CGRectMake(kSceenWidth-numberWidth-place, 0, numberWidth, high)];
    cNumber.font = [UIFont systemFontOfSize:13];
    cNumber.textAlignment = NSTextAlignmentCenter;
    [self addSubview:cNumber];
    _cNumber = cNumber;
    
    
}

- (void)setElected:(Elected *)elected
{
    _elected = elected;
    if ([_elected.hplayername isEqualToString:@""]) {
        _hNumber.text = @"";
    } else {
        _hNumber.text = [NSString stringWithFormat:@"%li",(long)_elected.hplaynumber];
    }
    _hName.text = _elected.hplayername;
    _cName.text = _elected.cplayername;
    if ([_elected.cplayername isEqualToString:@""]) {
        _cNumber.text = @"";
    } else {
        _cNumber.text = [NSString stringWithFormat:@"%li",(long)_elected.cplaynumber];
    }

}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"lineUpCell";
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