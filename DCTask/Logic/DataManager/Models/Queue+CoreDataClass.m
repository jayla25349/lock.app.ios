//
//  Queue+CoreDataClass.m
//  
//
//  Created by 青秀斌 on 16/9/19.
//
//

#import "Queue+CoreDataClass.h"
#import "Plan+CoreDataClass.h"
@implementation Queue

- (NSDictionary *)toJSONObject {
    NSMutableDictionary *jsonDic = nil;
    switch (self.type.integerValue) {
        case 0:{//状态队列
            jsonDic = [NSMutableDictionary dictionaryWithObject:@"PLAN_RETURN" forKey:@"business"];
            [jsonDic setValue:self.plan.plan_id forKey:@"plan_id"];
            [jsonDic setValue:self.plan.state forKey:@"state"];
            [jsonDic setValue:self.plan.reason forKey:@"reason"];
        }break;
        case 1:{//巡检队列
            NSMutableArray *itemArray = [NSMutableArray array];
            [self.plan.items enumerateObjectsUsingBlock:^(PlanItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSMutableArray *picArray = [NSMutableArray array];
                [obj.pics enumerateObjectsUsingBlock:^(Picture * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSMutableDictionary *picDic = [NSMutableDictionary dictionary];
                    [picDic setValue:obj.pic forKey:@"pic"];            //图片
                    [picDic setValue:obj.pic_type forKey:@"pic_type"];  //类型
                    [picArray addObject:picDic];
                }];
                
                NSMutableDictionary *itemDic = [NSMutableDictionary dictionary];
                [itemDic setValue:obj.item_id forKey:@"item_id"];   //巡检项id
                [itemDic setValue:obj.state forKey:@"state"];       //运行状态（0-正常；1-异常)
                [itemDic setValue:obj.result?:[NSNull null] forKey:@"result"];     //巡检情况
                [itemDic setValue:obj.note?:[NSNull null] forKey:@"note"];         //备注
                [itemDic setValue:@(picArray.count) forKey:@"pic_count"];//图片数量
                [itemDic setValue:picArray forKey:@"pics"];
                [itemArray addObject:itemDic];
            }];
            
            jsonDic = [NSMutableDictionary dictionaryWithObject:@"RESULT" forKey:@"business"];
            [jsonDic setValue:self.plan.plan_id forKey:@"plan_id"]; //巡检计划id
            [jsonDic setValue:itemArray forKey:@"items"];
        }break;
    }
    return jsonDic;
}

@end
