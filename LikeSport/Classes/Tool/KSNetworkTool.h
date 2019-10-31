//
//  KSNetworkTool.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/4/7.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"
typedef NS_ENUM(NSUInteger, KSNetworkType) {
    KSNetworkTypeNone = 0,
    KSNetworkType2G = 1,
    KSNetworkType3G = 2,
    KSNetworkType4G = 3,
    KSNetworkType5G = 4, // /  5G目前为猜测结果
    KSNetworkTypeWiFi = 5,
};
@interface KSNetworkTool : NSObject

+ (KSNetworkType)getNetworkLinkType;


@end
