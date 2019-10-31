//
//  KSConstant.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/5/17.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "KSConstant.h"

@implementation KSConstant
NSString * const webUrl = @"http://www.likesport.com";
NSString * const apiUrl = @"http://api.likesport.com";
NSString * const appUrl = @"https://app.likesport.com";
NSInteger const appID = 106;
NSString * const mac_token = @"123456";

- (NSString *)getState:(NSString *)state {
//    NSString *theString = _wikiParam.s_statetxt;
    NSArray *items = @[@"W",@"S",@"Z",@"X",@"J",@"F",@"D",@"Y",@"T",@"Q",@"C"];
    NSInteger item = [items indexOfObject:state];
    switch (item) {
        case 0:
            return NSLocalizedStringFromTable(@"Not Start", @"InfoPlist", nil);
            break;
        case 1:
            return NSLocalizedStringFromTable(@"1st Half", @"InfoPlist", nil);
            break;
        case 2:
            return NSLocalizedStringFromTable(@"Midfielder", @"InfoPlist", nil);
            
            break;
        case 3:
            return NSLocalizedStringFromTable(@"2nd Half", @"InfoPlist", nil);
            
            break;
        case 4:
            return NSLocalizedStringFromTable(@"ET", @"InfoPlist", nil);
            
            break;
        case 5:
            return NSLocalizedStringFromTable(@"Ended", @"InfoPlist", nil);
            break;
        case 6:
            return NSLocalizedStringFromTable(@"TBD", @"InfoPlist", nil);
            break;
        case 7:
            return NSLocalizedStringFromTable(@"Delay", @"InfoPlist", nil);
            break;
        case 8:
            return NSLocalizedStringFromTable(@"Stop", @"InfoPlist", nil);
            break;
        case 9:
            return NSLocalizedStringFromTable(@"Cut", @"InfoPlist", nil);
            break;
        case 10:
            return NSLocalizedStringFromTable(@"Cancel", @"InfoPlist", nil);
            break;
        
        default:
            break;
    }
    return nil;
}

// 篮球
- (NSString *)getBasketballState:(NSString *)state {
    //    NSString *theString = _wikiParam.s_statetxt;
    NSArray *items = @[@"W",@"1",@"2",@"3",@"4",@"Z",@"F",@"D",@"Y",@"T",@"Q",@"C"];
    NSInteger item = [items indexOfObject:state];
    switch (item) {
        case 0:
            return NSLocalizedStringFromTable(@"Not Start", @"InfoPlist", nil);
            break;
        case 1:
            return NSLocalizedStringFromTable(@"1th", @"InfoPlist", nil);
            break;
        case 2:
            return NSLocalizedStringFromTable(@"2th", @"InfoPlist", nil);
            
            break;
        case 3:
            return NSLocalizedStringFromTable(@"3th", @"InfoPlist", nil);
            
            break;
        case 4:
            return NSLocalizedStringFromTable(@"4th", @"InfoPlist", nil);
            
            break;
        case 5:
            return NSLocalizedStringFromTable(@"Midfielder", @"InfoPlist", nil);
            break;

        case 6:
            return NSLocalizedStringFromTable(@"Ended", @"InfoPlist", nil);
            break;
            
        case 7:
            return NSLocalizedStringFromTable(@"TBD", @"InfoPlist", nil);
            break;
        case 8:
            return NSLocalizedStringFromTable(@"Delay", @"InfoPlist", nil);
            break;
        case 9:
            return NSLocalizedStringFromTable(@"Stop", @"InfoPlist", nil);
            break;
        case 10:
            return NSLocalizedStringFromTable(@"Cut", @"InfoPlist", nil);
            break;
        case 11:
            return NSLocalizedStringFromTable(@"Cancel", @"InfoPlist", nil);
            break;
            
        default:
            break;
    }
    return nil;
}

// 网球
- (NSString *)getTinnisState:(NSString *)state {
    NSArray *items = @[@"W",@"1",@"2",@"3",@"4",@"5",@"F",@"D",@"Y",@"T",@"Q",@"C"];
    NSInteger item = [items indexOfObject:state];
    switch (item) {
        case 0:
            return NSLocalizedStringFromTable(@"Not Start", @"InfoPlist", nil);
            break;
        case 1:
            return NSLocalizedStringFromTable(@"1rd set", @"InfoPlist", nil);
            break;
        case 2:
            return NSLocalizedStringFromTable(@"2rd set", @"InfoPlist", nil);
            
            break;
        case 3:
            return NSLocalizedStringFromTable(@"3rd set", @"InfoPlist", nil);
            
            break;
        case 4:
            return NSLocalizedStringFromTable(@"4rd set", @"InfoPlist", nil);
            
            break;
        case 5:
            return NSLocalizedStringFromTable(@"5rd set", @"InfoPlist", nil);
            break;
            
        case 6:
            return NSLocalizedStringFromTable(@"Ended", @"InfoPlist", nil);
            break;
            
        case 7:
            return NSLocalizedStringFromTable(@"TBD", @"InfoPlist", nil);
            break;
        case 8:
            return NSLocalizedStringFromTable(@"Delay", @"InfoPlist", nil);
            break;
        case 9:
            return NSLocalizedStringFromTable(@"Stop", @"InfoPlist", nil);
            break;
        case 10:
            return NSLocalizedStringFromTable(@"Cut", @"InfoPlist", nil);
            break;
        case 11:
            return NSLocalizedStringFromTable(@"Cancel", @"InfoPlist", nil);
            break;
            
        default:
            break;
    }
    return nil;
}

- (NSString *)getLetterWithNumber:(NSInteger)number {
    if (number<27) {
        NSArray *array = @[@"#",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
        return array[number];
    } else {
        return [NSString stringWithFormat:@"%li",(long)number];
    }
    
}

//- (NSString *)getStateWithIndex:(NSInteger)index {
//    //    NSString *theString = _wikiParam.s_statetxt;
////    NSArray *items = @[@"W",@"S",@"Z",@"X",@"J",@"F",@"D",@"Y",@"T",@"Q",@"C",@"R",@"E"];
////    NSInteger item = [items indexOfObject:state];
//    switch (index) {
//        case 0:
//            return NSLocalizedStringFromTable(@"Not Start", @"InfoPlist", nil);
//            break;
//        case 1:
//            return NSLocalizedStringFromTable(@"1st Half", @"InfoPlist", nil);
//            break;
//        case 2:
//            return NSLocalizedStringFromTable(@"Half Time", @"InfoPlist", nil);
//            
//            break;
//        case 3:
//            return NSLocalizedStringFromTable(@"2nd Half", @"InfoPlist", nil);
//            
//            break;
//        case 4:
//            return NSLocalizedStringFromTable(@"1st Half", @"InfoPlist", nil);
//            
//            break;
//        case 5:
//            return NSLocalizedStringFromTable(@"1st Half", @"InfoPlist", nil);
//            break;
//        case 6:
//            return NSLocalizedStringFromTable(@"1st Half", @"InfoPlist", nil);
//            break;
//        case 7:
//            return NSLocalizedStringFromTable(@"1st Half", @"InfoPlist", nil);
//            break;
//        case 8:
//            return NSLocalizedStringFromTable(@"1st Half", @"InfoPlist", nil);
//            break;
//        case 9:
//            return NSLocalizedStringFromTable(@"1st Half", @"InfoPlist", nil);
//            break;
//        case 10:
//            return NSLocalizedStringFromTable(@"1st Half", @"InfoPlist", nil);
//            break;
//        case 11:
//            return NSLocalizedStringFromTable(@"1st Half", @"InfoPlist", nil);
//            
//            break;
//        case 12:
//            return NSLocalizedStringFromTable(@"1st Half", @"InfoPlist", nil);
//            break;
//        default:
//            break;
//    }
//    return nil;
//    
//}
@end
