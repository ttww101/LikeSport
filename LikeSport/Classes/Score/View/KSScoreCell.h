//
//  KSScoreCell.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/5/23.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSScoreCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *a;
@property (weak, nonatomic) IBOutlet UILabel *b;
@property (weak, nonatomic) IBOutlet UILabel *c;
@property (weak, nonatomic) IBOutlet UILabel *d;
@property (weak, nonatomic) IBOutlet UILabel *e;
@property (weak, nonatomic) IBOutlet UILabel *f;
@property (weak, nonatomic) IBOutlet UILabel *g;
@property (weak, nonatomic) IBOutlet UILabel *h;
@property (weak, nonatomic) IBOutlet UILabel *i;
@property (weak, nonatomic) IBOutlet UILabel *j;
@property (weak, nonatomic) IBOutlet UILabel *k;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
