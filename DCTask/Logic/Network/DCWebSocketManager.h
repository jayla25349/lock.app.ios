//
//  DCWebSocketManager.h
//  DCTask
//
//  Created by 青秀斌 on 2016/9/24.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCWebSocketReqeust.h"
#import "DCWebSocketResponse.h"
@protocol DCWebSocketManagerDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface DCWebSocketManager : NSObject
@property (nonatomic, weak) id<DCWebSocketManagerDelegate> delegate;

- (instancetype)initWithUserNumber:(NSString *)number;

//连接
- (void)connect;

//关闭
- (void)close;

//发送数据
- (DCWebSocketReqeust *)sendData:(NSDictionary *)data withId:(NSString *)Id;

@end

@protocol DCWebSocketManagerDelegate <NSObject>
@optional
- (void)webSocketManager:(DCWebSocketManager *)manager didReceiveData:(DCWebSocketResponse *)response;
- (void)webSocketManager:(DCWebSocketManager *)manager didSendData:(DCWebSocketReqeust *)request;
- (void)webSocketManagerDidSendAllData:(DCWebSocketManager *)manager;
@end

NS_ASSUME_NONNULL_END
