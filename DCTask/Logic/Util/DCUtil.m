//
//  DCUtil.m
//  DCTask
//
//  Created by 青秀斌 on 16/9/23.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "DCUtil.h"

@implementation DCUtil

+ (NSString *)imagePathWithName:(NSString *)name {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    path = [path stringByAppendingPathComponent:@"images"];
    path = [path stringByAppendingPathComponent:name];
    return path;
}

+ (NSString *)thumbnailPathWithName:(NSString *)name {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    path = [path stringByAppendingPathComponent:@"thumbnails"];
    path = [path stringByAppendingPathComponent:name];
    return path;
}

@end
