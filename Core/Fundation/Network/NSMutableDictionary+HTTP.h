//
//  NSMutableDictionary+HTTP.h
//  CoreFramework
//
//  Created by Jayla on 16/1/14.
//  Copyright © 2016年 Anzogame. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ParameterDic <NSObject>

- (void)setFloat:(float)value forField:(NSString *)field;
- (void)setDouble:(double)value forField:(NSString *)field;
- (void)setInteger:(NSInteger)value forField:(NSString *)field;

- (void)setString:(id)value forKey:(NSString *)key NS_DEPRECATED_IOS(7_0, 7_0);
- (void)setObject:(id)value forField:(NSString *)field;
- (void)removeObjectForField:(NSString *)field;

//设置子参数
- (void)setParameter:(void (^)(id<ParameterDic> parameter))block forField:(NSString *)value;
- (void)setParameterForParams:(void (^)(id<ParameterDic> parameter))block;
@end 

@interface NSMutableDictionary (HTTP)<ParameterDic>

@end
