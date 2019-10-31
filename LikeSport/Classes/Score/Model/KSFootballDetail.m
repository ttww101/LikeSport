//
//  KSFootballDetail.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/5/17.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "KSFootballDetail.h"

@implementation KSFootballDetail

@end
@implementation FootballDetailResult

+ (NSDictionary *)objectClassInArray{
    return @{@"match_event" : [MatchEvent class]};
}

@end


@implementation MatchZr

+ (NSDictionary *)objectClassInArray{
    return @{@"elected" : [Elected class], @"substitute" : [Substitute class]};
}

@end


@implementation Elected

@end


@implementation Substitute

@end


@implementation MatchInfo

@end


@implementation MatchEvent

@end


