//
//  Picture.m
//  
//
//  Created by 青秀斌 on 16/9/11.
//
//

#import "Picture.h"
#import "TaskItem.h"

@implementation Picture

- (NSDictionary *)toJSONObject {
    NSDictionary *jsonDic = @{@"pic":self.pic?:[NSNull null]};
    return jsonDic;
}

@end
