//
//  DCNetworkReqeust.m
//  DCTask
//
//  Created by 青秀斌 on 2016/9/24.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "DCNetworkReqeust.h"

NS_ASSUME_NONNULL_BEGIN

@interface DCNetworkReqeust ()
@property (nonnull, nonatomic, strong) NSString *Id;
@property (nonnull, nonatomic, strong) NSDictionary *payload;
@end

@implementation DCNetworkReqeust

+ (instancetype)reqeustWithPayload:(NSDictionary *)payload {
    DCNetworkReqeust *request = [[DCNetworkReqeust alloc] init];
    request.Id = [[NSUUID UUID] UUIDString];;
    request.payload = payload;
    request.status = DCReqeustStatusSuspend;
    return request;
}

//请求数据
- (NSString *)data {
    NSError *error = nil;
    NSData *payloadData = [NSJSONSerialization dataWithJSONObject:self.payload options:0 error:&error];
    if (error) {
        return nil;
    }
    
    NSString *payloadString = [[NSString alloc] initWithData:payloadData encoding:NSUTF8StringEncoding];
    NSDictionary *dataDic = @{@"directive":@"data", @"target":@"admin", @"data":@{@"id":self.Id, @"payload":payloadString}};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataDic options:0 error:&error];
    if (error) {
        return nil;
    }
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

@end

NS_ASSUME_NONNULL_END
