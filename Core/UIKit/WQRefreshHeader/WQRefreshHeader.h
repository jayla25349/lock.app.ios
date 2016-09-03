//
//  WQRefreshHeader.h
//  Pods
//
//  Created by Jayla on 15/12/14.
//
//

#import <MJRefresh/MJRefresh.h>

@interface WQRefreshHeader : MJRefreshHeader
@property (nonatomic, copy) NSString *textForIdle;
@property (nonatomic, copy) NSString *textForPulling;
@property (nonatomic, copy) NSString *textForRefreshing;
@end
