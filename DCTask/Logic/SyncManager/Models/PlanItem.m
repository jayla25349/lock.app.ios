//
//  PlanItem.m
//  
//
//  Created by 青秀斌 on 16/9/11.
//
//

#import "PlanItem.h"
#import "Plan.h"

@implementation PlanItem

- (NSDictionary *)toJSONObject {
    NSDictionary *jsonDic = @{@"item_id":self.item_id?:[NSNull null],
                              @"item_cate_name":self.item_cate_name?:[NSNull null],
                              @"equipment_name":self.equipment_name?:[NSNull null],
                              @"cabinet_name":self.cabinet_name?:[NSNull null],
                              @"cabinet_lock_mac":self.cabinet_lock_mac?:[NSNull null],
                              @"item_name":self.item_name?:[NSNull null]};
    
    return jsonDic;
}

@end
