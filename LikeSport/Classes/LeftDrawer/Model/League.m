//
//  League.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/7/6.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "League.h"

@implementation League

@end
@implementation LeagueResult

+ (NSDictionary *)objectClassInArray{
    return @{@"t0" : [T0 class], @"t1" : [T0 class],@"t2" : [T0 class]};
}

@end


@implementation T0

- (NSString *)signcode {
    
    for (NSInteger i=0; i<_signcode.length; i++) {
        if ([_signcode characterAtIndex:i]>='A'&[_signcode characterAtIndex:i]<='Z') {
            //A  65  a  97
            char  temp=[_signcode characterAtIndex:i]+32;
            NSRange range=NSMakeRange(i, 1);
            _signcode=[_signcode stringByReplacingCharactersInRange:range withString:[NSString stringWithFormat:@"%c",temp]];
        }
    }
    return _signcode;
}

- (NSString *)name {
    NSString *Name;
    if (_matchtypefullname) {
        Name = _teamname;
    } else if (_teamname){
        Name = _matchtypefullname;
    }
    return Name;
}

- (NSInteger)ID {
    NSInteger mid;
    if (_matchtype_id == 0) {
        mid = _team_id;
    } else if (_team_id == 0) {
        mid = _matchtype_id;
    }
    return mid;
}

@end



