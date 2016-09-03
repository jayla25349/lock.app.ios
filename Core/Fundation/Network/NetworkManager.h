//
//  NetworkManager.h
//  DNF
//
//  Created by Jayla on 16/5/25.
//  Copyright © 2016年 anzogame. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkUtil.h"
#import "NSError+HTTP.h"
#import "NSMutableDictionary+HTTP.h"

NS_ASSUME_NONNULL_BEGIN

@interface NetworkManager : AFHTTPSessionManager

- (nullable NSURLSessionDataTask *)HTTP_GET:(NSString *)url api:(nullable NSString *)api
                                 parameters:(nullable void (^)(id<ParameterDic> _Nonnull parameter))parameters
                                   progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgress
                                    success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                    failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject, NSError *error))failure;

- (nullable NSURLSessionDataTask *)HTTP_POST:(NSString *)url api:(nullable NSString *)api
                                  parameters:(nullable void (^)(id<ParameterDic> parameter))parameters
                   constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                                    progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                                     success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                     failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject, NSError *error))failure;

- (nullable NSURLSessionDataTask *)HTTP_POST:(NSString *)url api:(nullable NSString *)api
                                  parameters:(nullable void (^)(id<ParameterDic> parameter))parameters
                                     success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                     failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject, NSError *error))failure;

@end

NS_ASSUME_NONNULL_END

#define HTTP_GET(url, action) [AppEngine shareEngine].networkManager HTTP_GET:url api:action
#define HTTP_POST(url, action) [AppEngine shareEngine].networkManager HTTP_POST:url api:action
