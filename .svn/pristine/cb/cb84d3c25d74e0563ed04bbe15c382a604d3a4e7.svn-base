//
//  FollowViewController.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/6/8.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "BaseViewController.h"
@protocol FollowDelegate <NSObject>

@optional

@required

- (void)setSegmentTag:(NSInteger)tag;

@end
@interface FollowViewController : BaseViewController
@property (nonatomic, copy) void(^segmentBlock)(NSInteger tag);

@property (nonatomic, assign) id<FollowDelegate> delegate;

@end
