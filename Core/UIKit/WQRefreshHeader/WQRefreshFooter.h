//
//  WQRefreshFooter.h
//  Kylin
//
//  Created by 青秀斌 on 15/12/14.
//
//

#import <MJRefresh/MJRefresh.h>

@interface WQRefreshFooter : MJRefreshAutoFooter
@property (nonatomic, copy) NSString *textForIdle;
@property (nonatomic, copy) NSString *textForPulling;
@property (nonatomic, copy) NSString *textForRefreshing;
@property (nonatomic, copy) NSString *textForNoMoreData;

@end
