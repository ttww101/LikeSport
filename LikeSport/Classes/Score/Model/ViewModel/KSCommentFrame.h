//
//  KSCommentFrame.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/7/12.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CommentResult;
@interface KSCommentFrame : NSObject

//  评论数据
@property (nonatomic, strong) CommentResult *commentResult;

//  评论frame
@property (nonatomic, assign) CGRect commentViewFrame;

/** ******** 原创微博子控件frame *******/
//  头像Frame
@property (nonatomic, assign) CGRect iconFrame;

//  国旗Frame
@property (nonatomic, assign) CGRect flagFrame;

//  昵称Frame
@property (nonatomic, assign) CGRect nameFrame;

//  时间Frame
@property (nonatomic, assign) CGRect timeFrame;

//  正文Frame
@property (nonatomic, assign) CGRect textFrame;

// cell的高度
@property (nonatomic, assign) CGFloat cellHeight;

@end
