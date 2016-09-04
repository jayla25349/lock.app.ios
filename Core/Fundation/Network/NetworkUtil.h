//
//  NetworkUtil.h
//  Kylin
//
//  Created by 青秀斌 on 16/7/28.
//
//

#import <Foundation/Foundation.h>

@interface HttpQueryStringPair : NSObject
@property (readwrite, nonatomic, strong) id field;
@property (readwrite, nonatomic, strong) id value;

- (id)initWithField:(id)field value:(id)value;
- (NSString *)URLEncodedStringValueWithEncoding:(NSStringEncoding)stringEncoding;
@end

extern NSArray * HttpQueryStringPairsFromKeyAndValue(NSString *key, id value);
extern NSArray * HttpQueryStringPairsFromDictionary(NSDictionary *dictionary);
extern NSString * HttpQueryStringFromParametersWithEncoding(NSDictionary *parameters, NSStringEncoding stringEncoding);


@interface NetworkUtil : NSObject

//请求地址
+ (NSString *)reqeustUrlWithServer:(NSString *)server action:(NSString *)action;

//请求参数
+ (NSDictionary *)requestParamatersWithDic:(NSDictionary *)paramDic;

@end
