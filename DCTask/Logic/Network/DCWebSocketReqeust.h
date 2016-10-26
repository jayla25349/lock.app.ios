//
//  DCWebSocketReqeust.h
//  DCTask
//
//  Created by 青秀斌 on 2016/9/24.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DCReqeustStatus) {
    DCReqeustStatusSuspend,
    DCReqeustStatusRuning,
    DCReqeustStatusFilished
};

@interface DCWebSocketReqeust : NSObject
@property (nonnull, nonatomic, readonly) NSString *Id;
@property (nonnull, nonatomic, readonly) NSDictionary *payload;
@property (nonatomic, assign) DCReqeustStatus status;

+ (instancetype)reqeustWithId:(NSString *)Id payload:(NSDictionary *)payload;

//请求数据
- (NSString *)data;

@end

NS_ASSUME_NONNULL_END
