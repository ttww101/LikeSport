//
//  ChooseCell.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/6/30.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Matchtypes;
@protocol ChooseCellDelegate <NSObject>

@optional

- (void)followMatch:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
- (void)chooseMatch:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end
@interface ChooseCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) Matchtypes *match;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;
@property (weak, nonatomic) id<ChooseCellDelegate> delegate;
//@property (weak, nonatomic) UIImageView *flagView;

@end
