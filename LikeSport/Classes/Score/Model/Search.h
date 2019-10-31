//
//  Search.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/9/2.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SearchResult;
@interface Search : NSObject

@property (nonatomic, assign) NSInteger ret_code;

@property (nonatomic, copy) NSString *err_msg;

@property (nonatomic, strong) NSArray<SearchResult *> *result;

@end
@interface SearchResult : NSObject

@property (nonatomic, copy) NSString *Sport; // 类别

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *Name;

@property (nonatomic, copy) NSString *Type; // A:球队 B:赛事类别 C:球员

@property (nonatomic, copy) NSString *RID;

@property (nonatomic, copy) NSString *RName;

@property (nonatomic, copy) NSString *RCode;



@end

