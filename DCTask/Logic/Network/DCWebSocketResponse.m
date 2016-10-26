//
//  DCWebSocketResponse.m
//  DCTask
//
//  Created by 青秀斌 on 2016/9/24.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "DCWebSocketResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface DCWebSocketResponse ()
@property (nullable, nonatomic, strong) NSString *Id;
@property (nullable, nonatomic, strong) NSDictionary *payload;
@end

@implementation DCWebSocketResponse

+ (instancetype)responseWithId:(NSString *)Id payload:(NSString *)payload{
    NSError *error = nil;
    NSData *jsonData = [payload dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    if (error) {
        return nil;
    }
    
    DCWebSocketResponse *response = [[DCWebSocketResponse alloc] init];
    response.Id = Id;
    response.payload = jsonDic;
    return response;
}

//响应数据
- (NSString *)ask {
    NSDictionary *dataDic = @{@"directive":@"ask", @"data":@{@"id":self.Id}};
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataDic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (error) {
        return nil;
    }
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

@end
NS_ASSUME_NONNULL_END
