//
//  SearchCell.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/9/3.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "SearchCell.h"

@implementation SearchCell
{
    UILabel *typeLabel;
    UIButton *followBtn;
    UIImageView *flagView;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        flagView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 16, 18, 12)];
        [self.contentView addSubview:flagView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, kSceenWidth-110, self.frame.size.height)];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_nameLabel];
        
        typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSceenWidth-70, 0, 60, self.frame.size.height)];
        typeLabel.font = [UIFont systemFontOfSize:14];
        typeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:typeLabel];
        
//        followBtn = [[UIButton alloc] initWithFrame:CGRectMake(kSceenWidth-50, 0, 50, self.frame.size.height)];
//        [followBtn setImage:[UIImage imageNamed:@"starred"] forState:UIControlStateNormal];
//        [self.contentView addSubview:followBtn];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSearchResult:(SearchResult *)searchResult {
    if ([searchResult.Type isEqualToString:@"A"]) {
        typeLabel.text = NSLocalizedStringFromTable(@"Team", @"InfoPlist", nil);
    } else if ([searchResult.Type isEqualToString:@"B"]){
        typeLabel.text = NSLocalizedStringFromTable(@"Category", @"InfoPlist", nil);
    } else if ([searchResult.Type isEqualToString:@"C"]){
        typeLabel.text = NSLocalizedStringFromTable(@"Player", @"InfoPlist", nil);
    }
    
    flagView.image = [UIImage imageNamed:searchResult.RCode.lowercaseString];
    
//    if (_keyword) {
        // 原始搜索结果字符串.
//        NSString *originResult = self.arrOfSeachResults[indexPath.row];
        
        // 获取关键字的位置
//        NSRange range = [searchResult.Name rangeOfString:_keyword];
//        // 转换成可以操作的字符串类型.
//        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:searchResult.Name];
//        // 添加属性(粗体)
////        [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:range];
//        // 关键字高亮
//        [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
//        
//        // 将带属性的字符串添加到cell.textLabel上.
////        [cell.textLabel setAttributedText:attribute];
//        [nameLabel setAttributedText:attribute];
        
        
//        NSMutableAttributedString *hintString = [[NSMutableAttributedString alloc]initWithString:_searchResult.Name];
//        //获取要调整颜色的文字位置,调整颜色
//        NSRange range1=[[hintString string] rangeOfString:[NSString stringWithFormat:@"@%@",_keyword]];
//        [hintString addAttribute:NSForegroundColorAttributeName value:KSBlue range:range1];
//        nameLabel.attributedText = hintString;
        
//        NSRange range = [_searchResult.Name rangeOfString:_keyword];
//        NSMutableAttributedString *attr;
//        [attr setAttributes:@{NSForegroundColorAttributeName:KSBlue} range:range];
//        nameLabel.attributedText = attr;
//    } else {
        _nameLabel.text = searchResult.Name;
//    }
    
}

@end
