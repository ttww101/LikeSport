//
//  Comment.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/7/9.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "Comment.h"

@implementation Comment


+ (NSDictionary *)objectClassInArray{
    return @{@"result" : [CommentResult class]};
}
@end
@implementation CommentResult

//- (NSString *)createTime
//{
//    // 根据本地时区更改时间
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.timeZone = [NSTimeZone systemTimeZone];//[NSTimeZone timeZoneWithName:@"shanghai"];
//    [dateFormatter setDateFormat:@"HH:mm"];
//    NSDate *theday = [NSDate dateWithTimeIntervalSince1970:_createTime];
//    NSString *date = [dateFormatter stringFromDate:theday];
//    
//    return date;
//}

- (NSString *)region_code {
    
    for (NSInteger i=0; i<_region_code.length; i++) {
        if ([_region_code characterAtIndex:i]>='A'&[_region_code characterAtIndex:i]<='Z') {
            //A  65  a  97
            char  temp=[_region_code characterAtIndex:i]+32;
            NSRange range=NSMakeRange(i, 1);
            _region_code=[_region_code stringByReplacingCharactersInRange:range withString:[NSString stringWithFormat:@"%c",temp]];
        }
    }
    return _region_code;
}
@end


