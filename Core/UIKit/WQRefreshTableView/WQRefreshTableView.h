//
//  WQRefreshTableView.h
//  DNF
//
//  Created by Jayla on 16/2/3.
//  Copyright © 2016年 anzogame. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WQRefreshTableViewDelegate;

@interface WQRefreshTableView : UITableView
@property (weak, nonatomic) IBOutlet id<WQRefreshTableViewDelegate> refreshDelegate;

@property (strong, nonatomic, readonly) NSMutableArray *dataArray;
@property (assign, nonatomic, readonly) NSUInteger pageIndex;
@property (assign, nonatomic) NSUInteger pageSize;

@property (assign, nonatomic) BOOL allowShowMore;
@property (assign, nonatomic) BOOL allowShowBlank;
@property (strong, nonatomic) UIImage *blankImage;
@property (strong, nonatomic) NSString *blankTitle;
@property (strong, nonatomic) NSString *blankMessage;

- (void)refreshData;
@end

@protocol WQRefreshTableViewDelegate <NSObject>
@optional
/**
 *  @author Jayla, 16-07-21 14:07:11
 *
 *  @brief 上拉加载和下拉刷新回调事件
 *
 *  @param tableView 当前TableView
 *  @param pageSize  加载页号（为0是即为下拉刷新）
 *  @param pageIndex 每页大小（默认20）
 *  @param success   成功回调（传入当前页数据，页面将自动刷新）
 *  @param failure   失败回调（传入失败信息，页面将自动提示）
 */
- (void)tableView:(WQRefreshTableView *)tableView
         pageSize:(NSUInteger)pageSize
        pageIndex:(NSUInteger)pageIndex
          success:(void (^)(NSArray *list))success
          failure:(void (^)(NSError *error))failure;

@end
