//
//  DCNetworkResponse.h
//  DCTask
//
//  Created by 青秀斌 on 2016/9/24.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DCNetworkResponse : NSObject
@property (nullable, nonatomic, readonly) NSString *Id;
@property (nullable, nonatomic, readonly) NSDictionary *payload;

+ (instancetype)responseWithId:(NSString *)Id payload:(NSDictionary *)payload;

//响应数据
- (NSString *)ask;

@end

NS_ASSUME_NONNULL_END
