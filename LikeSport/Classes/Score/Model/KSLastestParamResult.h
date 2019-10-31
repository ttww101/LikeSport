//
//  KSLastestParamResult.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/4/8.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
#import "KSLive.h"
@class FollowResult;
@class LiveResult;
@interface KSLastestParamResult : NSObject

@property (nonatomic, copy) NSString *ret_total;

@property (nonatomic, copy) NSString *ret_code;

@property (nonatomic, strong) KSLive *result;



//@property (nonatomic, strong) NSArray<KSLive *> *result;


@end

@interface FollowResult : NSObject

@property (nonatomic, copy) NSString *ret_total;

@property (nonatomic, copy) NSString *ret_code;

@property (nonatomic, strong) KSLive *result;



//@property (nonatomic, strong) NSArray<KSLive *> *result;


@end

@interface LiveResult : NSObject
@property (nonatomic, copy) NSString *ret_total;

@property (nonatomic, copy) NSString *ret_code;

@property (nonatomic, strong) NSArray *result;
@end
