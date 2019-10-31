//
//  KSWikiTableViewCell.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/4/9.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "KSWikiTableViewCell.h"
@interface KSWikiTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rewardsLabel;

@end

@implementation KSWikiTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setWiki:(WikiResult *)wiki {
    _wiki = wiki;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone systemTimeZone];//[NSTimeZone timeZoneWithName:@"shanghai"];
    if ([Language rangeOfString:@"zh-Hans"].location != NSNotFound) {
        [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    } else {
        [dateFormatter setDateFormat:@"dd/MM/YYYY"];
    }
    NSDate *theday = [NSDate dateWithTimeIntervalSince1970:_wiki.starttime];
    NSString *date = [dateFormatter stringFromDate:theday];
    if (_wiki.hteamname.length > 0 && _wiki.hteamname.length) {
        _titleLabel.text = [NSString stringWithFormat:@"%@, %@-%@, %@",_wiki.matchtypefullname,_wiki.hteamname,_wiki.cteamname,date];
    } else {
        _titleLabel.text = [NSString stringWithFormat:@"%@, %@",_wiki.matchtypefullname,date];
    }
    
    _typeLabel.text = _wiki.content;
    
//    switch (_wiki.wikitype) {
//        case 1:
//
//            _typeLabel.text = NSLocalizedStringFromTable(@"Provide score or status", @"InfoPlist", nil);
//            break;
//
//        case 3:
//            _typeLabel.text = NSLocalizedStringFromTable(@"Provide fixture", @"InfoPlist", nil);
//            _titleLabel.text = [NSString stringWithFormat:@"%@, %@",_wiki.matchtypefullname,_wiki.stagename];
//            break;
//
//        default:
//            break;
//    }
    
    _rewardsLabel.text = [NSString stringWithFormat:@"%li%@",(long)_wiki.rwxnb,NSLocalizedStringFromTable(@"Gold", @"InfoPlist", nil)];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
