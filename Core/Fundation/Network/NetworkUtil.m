//
//  NetworkUtil.m
//  Pods
//
//  Created by Jayla on 16/7/28.
//
//

#import "NetworkUtil.h"

static NSString * const kAFCharactersToBeEscapedInQueryString = @":/?&=;+!@#$()',*";

static NSString * HttpPercentEscapedQueryStringKeyFromStringWithEncoding(NSString *string, NSStringEncoding encoding) {
    static NSString * const kAFCharactersToLeaveUnescapedInQueryStringPairKey = @"[].";
    
    return (__bridge_transfer  NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, (__bridge CFStringRef)kAFCharactersToLeaveUnescapedInQueryStringPairKey, (__bridge CFStringRef)kAFCharactersToBeEscapedInQueryString, CFStringConvertNSStringEncodingToEncoding(encoding));
}

static NSString * HttpPercentEscapedQueryStringValueFromStringWithEncoding(NSString *string, NSStringEncoding encoding) {
    return (__bridge_transfer  NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, NULL, (__bridge CFStringRef)kAFCharactersToBeEscapedInQueryString, CFStringConvertNSStringEncodingToEncoding(encoding));
}

@implementation HttpQueryStringPair

- (id)initWithField:(id)field value:(id)value {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.field = field;
    self.value = value;
    
    return self;
}

- (NSString *)URLEncodedStringValueWithEncoding:(NSStringEncoding)stringEncoding {
    if (!self.value || [self.value isEqual:[NSNull null]]) {
        return HttpPercentEscapedQueryStringKeyFromStringWithEncoding([self.field description], stringEncoding);
    } else {
        return [NSString stringWithFormat:@"%@=%@", HttpPercentEscapedQueryStringKeyFromStringWithEncoding([self.field description], stringEncoding), HttpPercentEscapedQueryStringValueFromStringWithEncoding([self.value description], stringEncoding)];
    }
}
@end

NSArray * HttpQueryStringPairsFromKeyAndValue(NSString *key, id value) {
    NSMutableArray *mutableQueryStringComponents = [NSMutableArray array];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"description" ascending:YES selector:@selector(compare:)];
    
    if ([value isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = value;
        // Sort dictionary keys to ensure consistent ordering in query string, which is important when deserializing potentially ambiguous sequences, such as an array of dictionaries
        for (id nestedKey in [dictionary.allKeys sortedArrayUsingDescriptors:@[ sortDescriptor ]]) {
            id nestedValue = [dictionary objectForKey:nestedKey];
            if (nestedValue) {
                [mutableQueryStringComponents addObjectsFromArray:HttpQueryStringPairsFromKeyAndValue((key ? [NSString stringWithFormat:@"%@[%@]", key, nestedKey] : nestedKey), nestedValue)];
            }
        }
    } else if ([value isKindOfClass:[NSArray class]]) {
        NSArray *array = value;
        for (id nestedValue in array) {
            [mutableQueryStringComponents addObjectsFromArray:HttpQueryStringPairsFromKeyAndValue([NSString stringWithFormat:@"%@[]", key], nestedValue)];
        }
    } else if ([value isKindOfClass:[NSSet class]]) {
        NSSet *set = value;
        for (id obj in [set sortedArrayUsingDescriptors:@[ sortDescriptor ]]) {
            [mutableQueryStringComponents addObjectsFromArray:HttpQueryStringPairsFromKeyAndValue(key, obj)];
        }
    } else {
        [mutableQueryStringComponents addObject:[[HttpQueryStringPair alloc] initWithField:key value:value]];
    }
    
    return mutableQueryStringComponents;
}

NSArray * HttpQueryStringPairsFromDictionary(NSDictionary *dictionary) {
    return HttpQueryStringPairsFromKeyAndValue(nil, dictionary);
}

NSString * HttpQueryStringFromParametersWithEncoding(NSDictionary *parameters, NSStringEncoding stringEncoding) {
    NSMutableArray *mutablePairs = [NSMutableArray array];
    for (HttpQueryStringPair *pair in HttpQueryStringPairsFromDictionary(parameters)) {
        [mutablePairs addObject:[pair URLEncodedStringValueWithEncoding:stringEncoding]];
    }
    
    return [mutablePairs componentsJoinedByString:@"&"];
}

@implementation NetworkUtil

//请求地址
+ (NSString *)reqeustUrlWithServer:(NSString *)server action:(NSString *)action {
    NSParameterAssert(server);
    NSString *url = [server stringByAppendingPathComponent:action];
    return url;
}

//请求参数
+ (NSDictionary *)requestParamatersWithDic:(NSDictionary *)paramDic {
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
//    [tempDic setObject:@"sfsfsfsfs" forField:@"sign"];
//    [tempDic setObject:@"ios" forField:@"os"];
//    [tempDic setObject:[WQDevice osVersion] forField:@"osVersion"];
//    [tempDic setObject:[WQDevice appBuild] forField:@"platformVersion"];
//    [tempDic setObject:[WQAppEngine stringForSystemKey:@"GAME"] forField:@"game"];
//    [tempDic setObject:[WQAppEngine stringForSystemKey:@"APP_FULL_NAME"] forField:@"platform"];
//    [tempDic setObject:[WQUser me].token forField:@"userToken"];
//    [tempDic setObject:[WQUser me].user_id?:[WQUser me].userid forField:@"userId"];//用[WQUser me].userid是为了兼容lol
//    [tempDic setObject:[WQUtility deviceId]?:[WQUser me].userid forField:@"deviceId"];//为什么用[WQUser me].userid？原作者说不记得了
//    [tempDic setInteger:[[NSDate date] timeIntervalSince1970] forField:@"time"];
//    [tempDic setObject:@"v1" forField:@"apiVersion"];
//    [tempDic setObject:api forField:@"api"];
    if ([paramDic isKindOfClass:[NSDictionary class]]) {
        [tempDic addEntriesFromDictionary:paramDic];
    }
    
    return tempDic;
}

@end
