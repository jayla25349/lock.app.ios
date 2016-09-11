//
//  Plan.m
//  
//
//  Created by 青秀斌 on 16/9/11.
//
//

#import "Plan.h"

@implementation Plan

- (NSString *) MR_primaryKey {
    return @"plan_id";
}

- (NSDictionary *)toJSONObject {
    NSDictionary *jsonDic = @{@"plan_id":self.plan_id?:[NSNull null],
                              @"plan_name":self.plan_name?:[NSNull null],
                              @"dispatch_man":self.dispatch_man?:[NSNull null],
                              @"plan_date":self.plan_date?@([self.plan_date timeIntervalSince1970]):[NSNull null],
                              @"room_name":self.room_name?:[NSNull null],
                              @"lock_mac":self.lock_mac?:[NSNull null]};
    
    return jsonDic;
}

@end
