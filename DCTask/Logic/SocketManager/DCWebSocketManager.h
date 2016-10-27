//
//  DCWebSocketManager.h
//  DCTask
//
//  Created by 青秀斌 on 2016/9/24.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCWebSocketRequest.h"
#import "DCWebSocketResponse.h"
@protocol DCWebSocketManagerDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface DCWebSocketManager : NSObject
@property (nonatomic, weak) id<DCWebSocketManagerDelegate> delegate;

- (instancetype)initWithURL:(NSURL *)url;

- (void)connect;
- (void)close;

- (void)sendRequest:(DCWebSocketRequest *)request;
- (void)sendResponse:(DCWebSocketResponse *)response;

@end

@protocol DCWebSocketManagerDelegate <NSObject>
@optional
- (void)webSocketManager:(DCWebSocketManager *)manager didReceiveData:(DCWebSocketResponse *)response;
- (void)webSocketManager:(DCWebSocketManager *)manager didReceiveAsk:(DCWebSocketRequest *)request;
- (void)webSocketManagerDidFilishSend:(DCWebSocketManager *)manager;
@end

NS_ASSUME_NONNULL_END
