//
//  ChangeDataViewController.h
//  WWeChat
//
//  Created by wordoor－z on 16/2/15.
//  Copyright © 2016年 wzx. All rights reserved.
//

#import "BaseViewController.h"

@interface ChangeDataViewController : BaseViewController

typedef NS_ENUM(NSInteger,ChangeType)
{
    ChangeAvater,
    ChangeNickName,
    ChangeAddress,
    ChangeSex,
    ChangePath,
    ChangeEmail,
};

@property(nonatomic,strong)UIImageView * avaterView;

@property(nonatomic,weak)void(^avaterBlock)(UIImage * img);

@property (nonatomic, copy) void(^sexBlock)(NSInteger sex);

@property (nonatomic, copy) NSString *nick_name;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *email;


@property (nonatomic, copy) void(^nick_nameBlock)(NSString *nick_name);

@property (nonatomic, copy) void(^addressBlock)(NSString *address);

@property (nonatomic, copy) void(^emailBlock)(NSString *email);


- (instancetype)initWithType:(ChangeType)type;

@end
