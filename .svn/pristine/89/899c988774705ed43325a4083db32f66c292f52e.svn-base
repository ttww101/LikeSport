//
//  CommentCell.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/7/12.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "CommentCell.h"
@interface CommentCell ()
@property (weak, nonatomic) IBOutlet UIImageView *averImage;
@property (weak, nonatomic) IBOutlet UIImageView *flagImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *replaceBtn;

@end

@implementation CommentCell
- (IBAction)deleteBtn:(id)sender {
    if (self.deleteBlock) {
        self.deleteBlock(_commentResult.id);
    }
}

- (IBAction)replaceBtn:(id)sender {
    if (self.replaceBlock) {
        self.replaceBlock(_commentResult.id,_commentResult.nick_name);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCommentResult:(CommentResult *)commentResult {
    [_deleteBtn setTitle:NSLocalizedStringFromTable(@"Delete", @"InfoPlist", nil) forState:UIControlStateNormal];
    [_replaceBtn setTitle:NSLocalizedStringFromTable(@"Reply", @"InfoPlist", nil) forState:UIControlStateNormal];
    _commentResult = commentResult;
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *userid = [defaults objectForKey:@"userid"];//根据键值取出name
    if (_commentResult.userid != [userid integerValue]) {
        _deleteBtn.hidden = YES;
    } else if (_commentResult.userid == 0) {
        _deleteBtn.hidden = YES;
    } else {
        _deleteBtn.hidden = NO;
    }
    
    // 设置头像
    NSString *aver = [_commentResult.avatar stringByReplacingOccurrencesOfString:@"{0}" withString:@"180x180"];
    NSString *averUrl = [[NSString alloc] initWithFormat:@"http://app.likesport.com/%@",aver];
    NSLog(@"链接%@",averUrl);
    // 加载图片之前先清除本机的头像缓存
    [[SDImageCache sharedImageCache] removeImageForKey:averUrl];
    [_averImage sd_setImageWithURL:[NSURL URLWithString:averUrl] placeholderImage:[UIImage imageNamed:@"img_default"]];
    _averImage.contentMode =  UIViewContentModeScaleAspectFit;
    
    // 设置国旗
    if ([_commentResult.region_code isEqualToString:@"sa"] || [_commentResult.region_code isEqualToString:@"fifa"] || [_commentResult.region_code isEqualToString:@""]) {
        _flagImage.image = [UIImage imageNamed:@"1"];
    } else {
        _flagImage.image = [UIImage imageNamed:_commentResult.region_code];
    }
    
    // 设置昵称
    _nameLabel.text = _commentResult.nick_name;
    
    // 设置正文
    
    if (_commentResult.replyid == 0) {
        _contentLabel.text = _commentResult.content;
    } else {
        NSString *string = [NSString stringWithFormat:@"@%@:%@",_commentResult.reply_nick_name,_commentResult.content];
        //创建 NSMutableAttributedString
//        NSMutableAttributedString *attributedStr01 = [[NSMutableAttributedString alloc] initWithString:string];
//        
//        //给所有字符设置字体为Zapfino，字体高度为15像素
//        [attributedStr01 addAttribute: NSFontAttributeName value: [UIFont fontWithName: @"Zapfino" size: 15] range: NSMakeRange(0, string.length)];
//        //分段控制，最开始昵称字符颜色设置成蓝色
//        [attributedStr01 addAttribute: NSForegroundColorAttributeName value: [UIColor blueColor] range: NSMakeRange(0, 5)];
        NSMutableAttributedString *hintString = [[NSMutableAttributedString alloc] initWithString:string];
        //获取要调整颜色的文字位置,调整颜色
        NSRange range1=[[hintString string] rangeOfString:[NSString stringWithFormat:@"@%@",_commentResult.reply_nick_name]];
        [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:range1];
        
        _contentLabel.attributedText = hintString;
//        _contentLabel.text = string;
    }
    
    // 根据本地时区更改时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone systemTimeZone];//[NSTimeZone timeZoneWithName:@"shanghai"];
    if ([Language rangeOfString:@"zh-Hans"].location != NSNotFound) {
        [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    } else {
        [dateFormatter setDateFormat:@"dd/MM/YYYY HH:mm"];
    }
    NSDate *theday = [NSDate dateWithTimeIntervalSince1970:_commentResult.createTime];
    NSString *date = [dateFormatter stringFromDate:theday];
    _timeLabel.text = date;
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"commentCell";
    id cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}


@end
