//
//  Comment.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/7/9.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CommentResult;
@interface Comment : NSObject

@property (nonatomic, assign) NSInteger ret_code;

@property (nonatomic, copy) NSString *err_msg;

@property (nonatomic, strong) NSArray<CommentResult *> *result;

@end
@interface CommentResult : NSObject

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, assign) NSInteger replyid;

@property (nonatomic, copy) NSString *reply_nick_name;

@property (nonatomic, copy) NSString *region_code;

@property (nonatomic, assign) NSInteger userid;

@property (nonatomic, copy) NSString *nick_name;

@property (nonatomic, copy) NSString *regionname;

@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, assign) NSInteger createTime;

@property (nonatomic, assign) NSInteger region_id;

@property (nonatomic, assign) NSInteger reply_userid;

@property (nonatomic, copy) NSString *content;

@end

