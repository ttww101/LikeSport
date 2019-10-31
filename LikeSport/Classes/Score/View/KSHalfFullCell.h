//
//  KSHalfFullCell.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/5/30.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSHalfFullCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *total;
@property (weak, nonatomic) IBOutlet UILabel *ww;
@property (weak, nonatomic) IBOutlet UILabel *wd;
@property (weak, nonatomic) IBOutlet UILabel *wl;
@property (weak, nonatomic) IBOutlet UILabel *dw;
@property (weak, nonatomic) IBOutlet UILabel *dd;
@property (weak, nonatomic) IBOutlet UILabel *dl;
@property (weak, nonatomic) IBOutlet UILabel *lw;
@property (weak, nonatomic) IBOutlet UILabel *ld;
@property (weak, nonatomic) IBOutlet UILabel *ll;



+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
