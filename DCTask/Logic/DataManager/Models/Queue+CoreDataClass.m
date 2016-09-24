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

- (NSString *)toJSONString {
    NSMutableDictionary *jsonDic = nil;
    switch (self.type.integerValue) {
        case 0:{//任务状态
            jsonDic = [NSMutableDictionary dictionaryWithObject:@"PLAN_RETURN" forKey:@"business"];
            [jsonDic setValue:self.plan.plan_id forKey:@"plan_id"];
            [jsonDic setValue:self.plan.state forKey:@"state"];
            [jsonDic setValue:@"" forKey:@"reason"];
        }break;
        case 1:{//巡检任务
            NSMutableArray *itemArray = [NSMutableArray array];
            [self.plan.items enumerateObjectsUsingBlock:^(PlanItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSMutableArray *picArray = [NSMutableArray array];
                [obj.pics enumerateObjectsUsingBlock:^(Picture * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSMutableDictionary *picDic = [NSMutableDictionary dictionary];
                    [picDic setValue:obj.name forKey:@"pic"];        //图片
                    [picArray addObject:picDic];
                }];
                
                NSMutableDictionary *itemDic = [NSMutableDictionary dictionary];
                [itemDic setValue:obj.item_id forKey:@"item_id"];   //巡检项id
                [itemDic setValue:obj.item_id forKey:@"state"];     //运行状态（0-正常；1-异常)
                [itemDic setValue:obj.item_id forKey:@"result"];    //巡检情况
                [itemDic setValue:obj.item_id forKey:@"note"];      //备注
                [itemDic setValue:@(obj.pics.count) forKey:@"pic_count"];//图片数量
                [itemDic setValue:picArray forKey:@"pics"];
                [itemArray addObject:itemDic];
            }];
            
            jsonDic = [NSMutableDictionary dictionaryWithObject:@"RESULT" forKey:@"business"];
            [jsonDic setValue:self.plan.plan_id forKey:@"plan_id"]; //巡检计划id
            [jsonDic setValue:itemArray forKey:@"items"];
        }break;
    }
    
    if (jsonDic) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDic
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        if (!error) {
            return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
    }
    return nil;
}

@end
