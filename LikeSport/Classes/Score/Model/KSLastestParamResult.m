//
//  KSLastestParamResult.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/4/8.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "KSLastestParamResult.h"
#import "KSLive.h"

@implementation KSLastestParamResult

//+ (NSDictionary *)mj_objectClassInArray {
//    return @{@"result":[KSLive class]};
//}

@end

@implementation FollowResult

//+ (NSDictionary *)mj_objectClassInArray {
//    return @{@"result":[KSLive class]};
//}

@end

@implementation LiveResult : NSObject

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"result":[KSLive class]};
}
@end