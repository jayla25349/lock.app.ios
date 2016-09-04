//
//  NetworkManager.m
//  Kylin
//
//  Created by 青秀斌 on 16/5/25.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "NetworkManager.h"
#import "DebugAlert.h"

#define TASK_BEGIN \
NSTimeInterval beginTime = [NSDate timeIntervalSinceReferenceDate];

#define TASK_END(task, parameters) \
DDLogDebug(@"******************************请求开始(%lu)******************************", task.taskIdentifier);\
DDLogDebug(@"请求地址：%@", task.currentRequest.URL);\
DDLogDebug(@"请求参数：%@", parameters);\
DDLogDebug(@"请求头部：%@", task.currentRequest.allHTTPHeaderFields);

#define TASK_SUCCESS(task, responseObject) \
NSTimeInterval endTime = [NSDate timeIntervalSinceReferenceDate];\
DDLogDebug(@"响应头部：%@", ((NSHTTPURLResponse *)task.response).allHeaderFields);\
DDLogDebug(@"响应内容：%@", responseObject);\
DDLogDebug(@"请求用时：%f", endTime-beginTime);\
DDLogDebug(@"******************************请求完成(%lu)******************************\n\n\n", task.taskIdentifier);

#define TASK_FAILURE(task, responseObject, error) \
NSTimeInterval endTime = [NSDate timeIntervalSinceReferenceDate];\
DDLogDebug(@"请求失败：%@", error.localizedDescription);\
DDLogDebug(@"响应头部：%@", ((NSHTTPURLResponse *)task.response).allHeaderFields);\
DDLogDebug(@"响应内容：%@", responseObject);\
DDLogDebug(@"请求用时：%f", endTime-beginTime);\
DDLogDebug(@"******************************请求完成(%lu)******************************\n\n\n", task.taskIdentifier);

@interface NetworkManager ()

@end

@implementation NetworkManager

-(instancetype)init {
    self = [super init];
    
    AFHTTPRequestSerializer *requestSerializer = self.requestSerializer;
    [requestSerializer setTimeoutInterval:15];
    
    AFJSONResponseSerializer *responseSerializer = (AFJSONResponseSerializer *)self.responseSerializer;
    responseSerializer.removesKeysWithNullValues = YES;
    responseSerializer.readingOptions = NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments;
    
    [self.reachabilityManager startMonitoring];
    return self;
}

/**********************************************************************/
#pragma mark - Overwrite
/**********************************************************************/

- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                  uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgress
                                downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:&serializationError];
    if (serializationError) {
        if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
#pragma clang diagnostic pop
        }
        
        return nil;
    }
    
    TASK_BEGIN
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self dataTaskWithRequest:request
                          uploadProgress:uploadProgress
                        downloadProgress:downloadProgress
                       completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
                           if (error) {
                               TASK_FAILURE(dataTask, responseObject, error)
                               if (failure) {
                                   failure(dataTask, error);
                               }
                           } else {
                               TASK_SUCCESS(dataTask, responseObject)
                               if (success) {
                                   success(dataTask, responseObject);
                               }
                           }
                       }];
    TASK_END(dataTask, parameters);
    
    return dataTask;
}
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                      progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters constructingBodyWithBlock:block error:&serializationError];
    if (serializationError) {
        if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
#pragma clang diagnostic pop
        }
        
        return nil;
    }
    
    TASK_BEGIN
    __block NSURLSessionDataTask *task = [self uploadTaskWithStreamedRequest:request progress:uploadProgress completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (error) {
            TASK_FAILURE(task, responseObject, error)
            if (failure) {
                failure(task, error);
            }
        } else {
            TASK_SUCCESS(task, responseObject)
            if (success) {
                success(task, responseObject);
            }
        }
    }];
    TASK_END(task, parameters);
    
    [task resume];
    
    return task;
}

/**********************************************************************/
#pragma mark - Private
/**********************************************************************/

- (void)handleSussecc:(NSURLSessionDataTask *)task response:(id)responseObject
              success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
              failure:(void (^)(NSURLSessionDataTask *task, id responseObject, NSError *error))failure {
    NSAssert([responseObject isKindOfClass:[NSDictionary class]], @"请求数据错误:%@", task);
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        NSNumber *code = responseObject[@"code"];
        if (code.integerValue == 200) {
            if (success) {
                success(task, responseObject);
            }
        } else {
            ErrorAlert([[NSString stringWithFormat:@"%@", responseObject] replaceUnicode]);
            if (failure) {
                NSMutableDictionary *userInfo = [responseObject mutableCopy];
                [userInfo setObject:responseObject[@"msg"]?:NET_REQUEST_ERROR forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:BussinessErrorDoman code:-2 userInfo:userInfo];
                failure(task, responseObject, error);
            }
        }
    } else {
        ErrorAlert([[NSString stringWithFormat:@"%@", responseObject] replaceUnicode]);
        if (failure) {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NET_SERVER_ERROR};
            NSError *error = [NSError errorWithDomain:BussinessErrorDoman code:-1 userInfo:userInfo];
            failure(task, responseObject, error);
        }
    }
}

- (void)handleFailure:(NSURLSessionDataTask *)task error:(NSError *)error
              failure:(void (^)(NSURLSessionDataTask *task, id responseObject, NSError *error))failure {
    ErrorAlert(@"%@", error);
    if (failure){
        NSError *tempError = nil;
        if ([error.domain isEqualToString:NSURLErrorDomain] && error.code == NSURLErrorNotConnectedToInternet) {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NET_UNCONNECT};
            tempError = [NSError errorWithDomain:RequestErrorDoman code:error.code userInfo:userInfo];
        } else {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NET_REQUEST_ERROR};
            tempError = [NSError errorWithDomain:ResponseErrorDoman code:error.code userInfo:userInfo];
        }
        failure(task, nil, tempError);
    }
}

/**********************************************************************/
#pragma mark - NetworkProtocol
/**********************************************************************/

- (nullable NSURLSessionDataTask *)HTTP_GET:(NSString *)url api:(nullable NSString *)api
                                 parameters:(nullable void (^)(id<ParameterDic> _Nonnull parameter))parameters
                                   progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgress
                                    success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                    failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject, NSError *error))failure {
    NSParameterAssert(url);
    
    NSMutableDictionary *tempDict = nil;
    if (parameters) {
        tempDict = [NSMutableDictionary dictionary];
        parameters(tempDict);
    }
    
    //请求地址
    NSString *requestUrl = [NetworkUtil reqeustUrlWithServer:url action:api];
    
    //请求参数
    NSDictionary *reqeustParams = [NetworkUtil requestParamatersWithDic:tempDict];
    
    //请求网络数据
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *dataTask = [self GET:requestUrl parameters:reqeustParams progress:downloadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf handleSussecc:task response:responseObject success:success failure:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf handleFailure:task error:error failure:failure];
    }];
    
    return dataTask;
}

- (nullable NSURLSessionDataTask *)HTTP_POST:(NSString *)url api:(nullable NSString *)api
                                  parameters:(nullable void (^)(id<ParameterDic> parameter))parameters
                   constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                                    progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                                     success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                     failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject, NSError *error))failure {
    NSParameterAssert(url);
    
    NSMutableDictionary *tempDict = nil;
    if (parameters) {
        tempDict = [NSMutableDictionary dictionary];
        parameters(tempDict);
    }
    
    //请求地址
    NSString *requestUrl = [NetworkUtil reqeustUrlWithServer:url action:api];
    
    //请求参数
    NSDictionary *reqeustParams = [NetworkUtil requestParamatersWithDic:tempDict];
    
    //请求网络数据
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *dataTask = [self POST:requestUrl parameters:reqeustParams constructingBodyWithBlock:block progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf handleSussecc:task response:responseObject success:success failure:failure];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf handleFailure:task error:error failure:failure];
    }];
    
    return dataTask;
}

- (nullable NSURLSessionDataTask *)HTTP_POST:(NSString *)url api:(nullable NSString *)api
                                  parameters:(nullable void (^)(id<ParameterDic> parameter))parameters
                                     success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                     failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject, NSError *error))failure {
    return [self HTTP_POST:url api:api parameters:parameters constructingBodyWithBlock:nil progress:nil success:success failure:failure];
}

/**********************************************************************/
#pragma mark - UIApplicationDelegate
/**********************************************************************/


@end
