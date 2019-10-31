//
//  KSHttpTool.h
//  LikeSport
//
//  Created by 罗剑玉 on 16/4/7.
//  Copyright © 2016年 swordfish. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  用来封装文件数据的模型
 */
@interface KSDataObject : NSObject

/**
 *  文件数据
 */
@property (nonatomic, strong) NSData *data;

/**
 *  参数名
 */
@property (nonatomic, copy) NSString *name;

/**
 *  文件名
 */
@property (nonatomic, copy) NSString *filename;

/**
 *  文件类型
 */
@property (nonatomic, copy) NSString *mimeType;

@end






@interface KSHttpTool : NSObject
/**
 *  提交一个不带数据的POST请求
 *
 *  @param url     地址
 *  @param params  参数
 */
+ (void)POSTWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;


+ (void)POSTWithURL:(NSString *)url params:(NSDictionary *)params dataArray:(NSArray<KSDataObject *> *)dataArray success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

// 上传头像
+ (void)POSTWithURL:(NSString *)url params:(NSDictionary *)params data:(KSDataObject *)data success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;


+ (void)GETWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//+ (void)GETIDWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

+ (void)GETWithSignURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

@end


