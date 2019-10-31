//
//  KSLive.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/4/7.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "KSLive.h"
#import "MJExtension.h"
#import "KSMore.h"
@implementation KSLive

MJCodingImplementation

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"t0":[KSLive class],@"t1":[KSLive class],@"t2":[KSLive class],@"data":[KSLive class],@"result_data":[KSLive class],@"fixtures_data":[KSLive class],@"more":[KSMore class]};
}

- (NSString *)tsigncode {
    
    for (NSInteger i=0; i<_tsigncode.length; i++) {
        if ([_tsigncode characterAtIndex:i]>='A'&[_tsigncode characterAtIndex:i]<='Z') {
            //A  65  a  97
            char  temp=[_tsigncode characterAtIndex:i]+32;
            NSRange range=NSMakeRange(i, 1);
            _tsigncode=[_tsigncode stringByReplacingCharactersInRange:range withString:[NSString stringWithFormat:@"%c",temp]];
        }
    }
    return _tsigncode;
}


- (void)setTotal_h:(NSInteger)total_h {
    if (_total_h != total_h && _timeH != 0) {
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        _timeH = (long int)time;
    }
    _total_h = total_h;

}

- (void)setTotal_c:(NSInteger)total_c {
    if (_total_c != total_c && _timeC != 0) {
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        _timeC = (long int)time;
    }
    _total_c = total_c;
}

- (void)setSt1_h:(NSInteger)st1_h {
    if (_st1_h != st1_h && _st1T_h != 0) {
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        _st1T_h = (long int)time;
    }
    _st1_h = st1_h;
}

- (void)setSt1_c:(NSInteger)st1_c {
    if (_st1_c != st1_c && _st1T_c != 0) {
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        _st1T_c = (long int)time;
    }
    _st1_c = st1_c;
}

- (void)setSt2_h:(NSInteger)st2_h {
    if (_st2_h != st2_h && _st2T_h != 0) {
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        _st2T_h = (long int)time;
    }
    _st2_h = st2_h;
}

- (void)setSt2_c:(NSInteger)st2_c {
    if (_st2_c != st2_c && _st2T_c != 0) {
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        _st2T_c = (long int)time;
    }
    _st2_c = st2_c;
}

- (void)setSt3_h:(NSInteger)st3_h {
    if (_st3_h != st3_h && _st3T_h != 0) {
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        _st3T_h = (long int)time;
    }
    _st3_h = st3_h;
}

- (void)setSt3_c:(NSInteger)st3_c {
    if (_st3_c != st3_c && _st3T_c != 0) {
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        _st3T_c = (long int)time;
    }
    _st3_c = st3_c;
}

- (void)setSt4_h:(NSInteger)st4_h {
    if (_st4_h != st4_h && _st4T_h != 0) {
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        _st4T_h = (long int)time;
    }
    _st4_h = st4_h;
}

- (void)setSt4_c:(NSInteger)st4_c {
    if (_st4_c != st4_c && _st4T_c != 0) {
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        _st4T_c = (long int)time;
    }
    _st4_c = st4_c;
}

- (void)setSt5_h:(NSInteger)st5_h {
    if (_st5_h != st5_h && _st5T_h != 0) {
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        _st5T_h = (long int)time;
    }
    _st5_h = st5_h;
}

- (void)setSt5_c:(NSInteger)st5_c {
    if (_st5_c != st5_c && _st5T_c != 0) {
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        _st5T_c = (long int)time;
    }
    _st5_c = st5_c;
}

//- (NSString *)state
//{
//    NSString *state;
//    NSString *theString = _state;
//    NSArray *items = @[@"W",@"S",@"Z",@"X",@"J",@"F",@"D",@"Y",@"T",@"Q",@"C"];
//    NSInteger item = [items indexOfObject:theString];
//    switch (item) {
//        case 0:
//            state = @"未";
//            break;
//        case 1:
//            state = @"上";
//            break;
//        case 2:
//            state = @"中场";
//            break;
//        case 3:
//            state= @"下";
//            break;
//        case 4:
//            state = @"加时";
//            break;
//        case 5:
//            state = @"完场";
//            break;
//        case 6:
//            state = @"待定";
//            break;
//        case 7:
//            state = @"延期";
//            break;
//        case 8:
//            state = @"中断";
//            break;
//        case 9:
//            state = @"腰斩";
//            break;
//        case 10:
//            state = @"取消";
//            break;
//            
//        default:
//            break;
//    }
//    NSInteger sta = [_state integerValue];
//    if (sta == 1 || sta == 2 || sta == 3 || sta == 4) {
//        state = _state;
//    }
//    return state;
//
//}

- (NSInteger)realstarttime
{
    //计算以当前时间为基准，过了多少分钟
    NSDate *half = [NSDate dateWithTimeIntervalSince1970:_realstarttime];
    NSTimeInterval aTimer = [[NSDate date] timeIntervalSinceDate:half];
    NSInteger hour = (int)(aTimer/3600);
    NSInteger minute = (int)(aTimer - hour*3600)/60;

    return minute;
    
}

//- (NSString *)starttime
//{
//    // 根据本地时区更改时间
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.timeZone = [NSTimeZone systemTimeZone];//[NSTimeZone timeZoneWithName:@"shanghai"];
//    [dateFormatter setDateFormat:@"HH:mm"];
//    NSDate *theday = [NSDate dateWithTimeIntervalSince1970:_starttime];
//    NSString *date = [dateFormatter stringFromDate:theday];
//    return date;
//}

//- (NSString *)neutralgreen
//{
//    if ([_neutralgreen isEqualToString:@"Y"]) {
//        return @"[中]";
//    }
//    return nil;
//}

//- (NSString *)hteamname
//{
//    if (_isDouble) {
//        return [NSString stringWithFormat:@"%@/%@",_hteamname,_hteamname_2];
//    } else {
//        return _hteamname;
//    }
//}

//- (NSString *)cteamname
//{
//    if (_isDouble) {
//        return [NSString stringWithFormat:@"%@/%@",_cteamname,_cteamname_2];
//    } else {
//        return _cteamname;
//    }
//}


@end

