//
//  PersonCell.m
//  WWeChat
//
//  Created by wordoor－z on 16/1/29.
//  Copyright © 2016年 wzx. All rights reserved.
//

#import "PersonCell.h"
#import "UIImageView+WebCache.h"
#import "UserInfoManager.h"
//#import "UserInfoManager.h"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]
@implementation PersonCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUserInfo:(UserInfoResult *)userInfo
{
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSString *aver = [userInfo.avatar stringByReplacingOccurrencesOfString:@"{0}" withString:@"180x180"];
    NSString *averUrl = [[NSString alloc] initWithFormat:@"http://app.likesport.com/%@",aver];
//    [self.avaterImgView sd_setImageWithURL:[NSURL URLWithString:averUrl] placeholderImage:[UIImage imageNamed:@"img_default"]];
    [[NSUserDefaults standardUserDefaults]setObject:averUrl forKey:@"avatarUrl"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    // 清除头像缓存
//    [[SDImageCache sharedImageCache] removeImageForKey:averUrl];
    [self.avaterImgView sd_setImageWithURL:[NSURL URLWithString:averUrl] placeholderImage:[UIImage imageNamed:@"img_default"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        [[UserInfoManager manager]saveImgDataWithImg:image];
    }];
    

//    self.userNameLabel.text = model.nickName;
//    
//    self.weIDLabel.text = [NSString stringWithFormat:@"微信号: %@",model.weID];
//    
//    self.wmImgView.image = [UIImage imageNamed:@"me_wm"];
    self.userNameLabel.text = userInfo.nick_name;
    self.experienceLabel.text = [NSString stringWithFormat:@"%@(%@:%li)",userInfo.sns_level,NSLocalizedStringFromTable(@"Exp", @"InfoPlist", nil),(long)userInfo.score];
    //        NSLog(@"经验%@",last.result.avatar);
    
    self.jewelLabel.text = [NSString stringWithFormat:@"%@:%li",NSLocalizedStringFromTable(@"Gem", @"InfoPlist", nil),(long)userInfo.gem];
    self.goldLabel.text = [NSString stringWithFormat:@"%@:%li",NSLocalizedStringFromTable(@"Gold", @"InfoPlist", nil),(long)userInfo.gold];
    self.winLabel.text = [NSString stringWithFormat:@"%@:%li",NSLocalizedStringFromTable(@"Win", @"InfoPlist", nil),(long)userInfo.sns_win_num];
    self.levelLabel.text = [NSString stringWithFormat:@"%@:%li",NSLocalizedStringFromTable(@"Draw", @"InfoPlist", nil),(long)userInfo.sns_he_num];
    self.lossLabel.text = [NSString stringWithFormat:@"%@:%li",NSLocalizedStringFromTable(@"Lost", @"InfoPlist", nil),(long)userInfo.sns_shu_num];
}

//懒加载
- (UIImageView *)avaterImgView
{
    if (!_avaterImgView)
    {
        _avaterImgView = ({
        
            UIImageView * avaterImgView = [[UIImageView alloc]initWithFrame:CGRectMake(WGiveWidth(12), WGiveHeight(12), self.frame.size.height - 2*WGiveHeight(12), self.frame.size.height - 2*WGiveHeight(12))];
            
            avaterImgView.clipsToBounds = YES;
            
            //加点圆角
            avaterImgView.layer.cornerRadius = 5;
            
            avaterImgView;
        });
        [self addSubview:_avaterImgView];
    }
    return _avaterImgView;
}

- (UILabel *)userNameLabel
{
    if (!_userNameLabel)
    {
        _userNameLabel = ({
        
//            UILabel * userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.height - 2*WGiveHeight(12) + 2*WGiveWidth(12), WGiveHeight(19), WGiveWidth(160), WGiveHeight(22))];
            UILabel * userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 15, 200, 20)];

            userNameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
            userNameLabel.textColor = KSBlue;
            
            userNameLabel;
        });
        [self addSubview:_userNameLabel];
    }
    return _userNameLabel;
}

- (UILabel *)experienceLabel
{
    if (!_weIDLabel)
    {
        _experienceLabel = ({
            
//            UILabel * weIDLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.height - 2*WGiveHeight(12) + 2*WGiveWidth(12), _userNameLabel.frame.origin.y + _userNameLabel.frame.size.height + WGiveHeight(5), WGiveWidth(160), WGiveHeight(20))];
            UILabel * experienceLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 42, 200, 20)];
            
            experienceLabel.font = [UIFont boldSystemFontOfSize:14];
            experienceLabel.textColor = UIColorFromRGB(0x0061b0);
            
            experienceLabel;
        });
        [self addSubview:_experienceLabel];
    }
    return _experienceLabel;
}

- (UILabel *)jewelLabel
{
    if (!_jewelLabel)
    {
        _jewelLabel = ({
            
            UILabel * jewelLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 65, 100, 20)];
            
            jewelLabel.font = [UIFont boldSystemFontOfSize:14];
            jewelLabel.textColor = [UIColor purpleColor];
            jewelLabel.textColor = UIColorFromRGB(0x9bc1cc);
            
            jewelLabel;
        });
        [self addSubview:_jewelLabel];
    }
    return _jewelLabel;
}

- (UILabel *)goldLabel
{
    if (!_goldLabel)
    {
        _goldLabel = ({
            
            UILabel * goldLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 65, 100, 20)];
            
            goldLabel.font = [UIFont boldSystemFontOfSize:14];
            goldLabel.textColor = UIColorFromRGB(0xcba00d);
            
            goldLabel;
        });
        [self addSubview:_goldLabel];
    }
    return _goldLabel;
}

//- (UILabel *)winLabel
//{
//    if (!_winLabel)
//    {
//        _winLabel = ({
//            
//            UILabel * winLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 70, 80, 20)];
//            
//            winLabel.font = [UIFont systemFontOfSize:12];
//            
//            winLabel.textColor = [UIColor colorWithRed:31/255.0 green:101/255.0 blue:74/255.0 alpha:1];
//
//            winLabel;
//        });
//        [self addSubview:_winLabel];
//    }
//    return _winLabel;
//}
//
//- (UILabel *)levelLabel
//{
//    if (!_levelLabel)
//    {
//        _levelLabel = ({
//            
//            UILabel * levelLabel = [[UILabel alloc]initWithFrame:CGRectMake(180, 70, 80, 20)];
//            
//            levelLabel.font = [UIFont systemFontOfSize:12];
//            levelLabel.textColor = [UIColor colorWithRed:241/255.0 green:188/255.0 blue:56/255.0 alpha:1];
//            
//            levelLabel;
//        });
//        [self addSubview:_levelLabel];
//    }
//    return _levelLabel;
//}
//
//- (UILabel *)lossLabel
//{
//    if (!_lossLabel)
//    {
//        _lossLabel = ({
//            
//            UILabel * lossLabel = [[UILabel alloc]initWithFrame:CGRectMake(260, 70, 80, 20)];
//            
//            lossLabel.font = [UIFont systemFontOfSize:12];
//            lossLabel.textColor = [UIColor redColor];
//            
//            lossLabel;
//        });
//        [self addSubview:_lossLabel];
//    }
//    return _lossLabel;
//}

// 个人信息设置
- (UIImageView *)avatarView
{
    if (!_avaterImgView)
    {
        _avaterImgView = ({
            
            UIImageView * avaterImgView = [[UIImageView alloc]initWithFrame:CGRectMake(WGiveWidth(220), 18, 64, 64)];
            
            avaterImgView.clipsToBounds = YES;
            
            //加点圆角
            avaterImgView.layer.cornerRadius = 5;
            
            avaterImgView;
        });
        [self addSubview:_avaterImgView];
    }
    return _avaterImgView;
}

- (UILabel *)avatarLabel
{
    if (!_avatarLabel)
    {
        _avatarLabel = ({

            UILabel *avatarLabel = [[UILabel alloc]initWithFrame:CGRectMake(260, 70, 80, 20)];

            avatarLabel.font = [UIFont systemFontOfSize:12];
            avatarLabel.textColor = [UIColor redColor];

            avatarLabel;
        });
        [self addSubview:_avatarLabel];
    }
    return _avatarLabel;
}

@end
