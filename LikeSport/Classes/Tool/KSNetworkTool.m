//
//  KSNetworkTool.m
//  LikeSport
//
//  Created by 罗剑玉 on 16/4/7.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import "KSNetworkTool.h"

@implementation KSNetworkTool

+ (KSNetworkType)getNetworkLinkType {
    
    Reachability *wifi = [Reachability reachabilityForLocalWiFi];
    // 2.检测手机是否能上网络(WIFI\3G\2.5G)
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    
    if ([wifi currentReachabilityStatus] != NotReachable) { // 有wifi
        return KSNetworkTypeWiFi;
    } else if ([conn currentReachabilityStatus] != NotReachable) { // 没有使用wifi, 使用手机自带网络进行上网
        return KSNetworkType3G;
    }
    return KSNetworkTypeNone;
}

@end
