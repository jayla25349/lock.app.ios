//
//  DCNetworkResponse.m
//  DCTask
//
//  Created by 青秀斌 on 2016/9/24.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "DCNetworkResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface DCNetworkResponse ()
@property (nullable, nonatomic, strong) NSString *Id;
@property (nullable, nonatomic, strong) NSDictionary *payload;
@end

@implementation DCNetworkResponse

+ (instancetype)responseWithId:(NSString *)Id payload:(NSDictionary *)payload{
    DCNetworkResponse *response = [[DCNetworkResponse alloc] init];
    response.Id = Id;
    response.payload = payload;
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
