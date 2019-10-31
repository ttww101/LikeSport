//
//  CommentCell.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/7/12.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"
@interface CommentCell : UITableViewCell

@property (nonatomic, strong) CommentResult *commentResult;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, copy) void(^deleteBlock)(NSInteger commentId);
@property (nonatomic, copy) void(^replaceBlock)(NSInteger replyid,NSString *nickName);

@end
