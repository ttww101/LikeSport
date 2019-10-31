//
//  KSHalfFullCell.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/5/30.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "KSHalfFullCell.h"

@interface KSHalfFullCell ()

@end

@implementation KSHalfFullCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"halfFullCell";
    id cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
