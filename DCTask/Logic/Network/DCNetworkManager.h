//
//  DCNetworkManager.h
//  DCTask
//
//  Created by 青秀斌 on 2016/9/24.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCNetworkReqeust.h"
#import "DCNetworkResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface DCNetworkManager : NSObject
@property (nullable, nonatomic, copy) void (^didSendData)(DCNetworkReqeust *request);
@property (nullable, nonatomic, copy) void (^didReceiveData)(DCNetworkResponse *response);
@property (nullable, nonatomic, copy) void (^didFilishedSend)(void);

- (instancetype)initWithUserNumber:(NSString *)number;

//连接
- (void)connect;

//关闭
- (void)close;

//发送数据
- (DCNetworkReqeust *)sendData:(NSDictionary *)data;

@end

NS_ASSUME_NONNULL_END
