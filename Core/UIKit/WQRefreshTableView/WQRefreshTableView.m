//
//  WQRefreshTableView.m
//  DNF
//
//  Created by Jayla on 16/2/3.
//  Copyright © 2016年 anzogame. All rights reserved.
//

#import "WQRefreshTableView.h"
#import "UIView+Blank.h"
#import "WQRefreshHeader.h"
#import "WQRefreshFooter.h"

@interface WQRefreshTableView ()
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (assign, nonatomic) NSUInteger pageIndex;
@end

@implementation WQRefreshTableView

- (instancetype)init {
    if (self = [super init]) {
        [self awakeFromNib];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self awakeFromNib];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib {
    self.pageIndex = 0;
    self.pageSize = 20;
    self.allowShowMore = YES;
    self.allowShowBlank = YES;
    self.blankImage = [UIImage imageNamed:@"空白提示-加载失败"];
    self.blankTitle = nil;
    self.blankMessage = @"没有找到符合的结果";
}

- (void)setRefreshDelegate:(id<WQRefreshTableViewDelegate>)refreshDelegate {
    _refreshDelegate = refreshDelegate;
    
    if ([self.refreshDelegate respondsToSelector:@selector(tableView:pageSize:pageIndex:success:failure:)]) {
        [self addRefreshHeader];
    }
}

- (void)setAllowShowMore:(BOOL)allowShowMore {
    _allowShowMore = allowShowMore;
    
    if (self.mj_footer) {
        [self.mj_footer removeFromSuperview];
        self.mj_footer = nil;
    }
}

/**********************************************************************/
#pragma mark - Private
/**********************************************************************/

- (void)addRefreshHeader {
    if (self.mj_header) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    WQRefreshHeader *header = [WQRefreshHeader headerWithRefreshingBlock:^{
        NSUInteger pageIndex = 0;
        [self.refreshDelegate tableView:self pageSize:self.pageSize pageIndex:pageIndex success:^(NSArray *list) {
            weakSelf.pageIndex = pageIndex;
            [weakSelf.mj_header endRefreshing];
            weakSelf.dataArray = [list mutableCopy];
            [weakSelf reloadData];
            
            [weakSelf addRefreshFooter];
            if (list.count < weakSelf.pageSize) {
                [weakSelf.mj_footer endRefreshingWithNoMoreData];
            } else {
                [weakSelf.mj_footer endRefreshing];
            }
            
            if (weakSelf.allowShowBlank && weakSelf.dataArray.count==0) {
                weakSelf.mj_footer.hidden = YES;
                [weakSelf showBlankWithImage:weakSelf.blankImage title:weakSelf.blankTitle message:weakSelf.blankMessage action:nil];
            } else {
                weakSelf.mj_footer.hidden = NO;
                [weakSelf dismissBlank];
            }
        } failure:^(NSError *error) {
            [weakSelf.mj_header endRefreshing];
            
            NSString *message = error.localizedDescription?:weakSelf.blankMessage;
            if (weakSelf.allowShowBlank && weakSelf.dataArray.count==0) {
                weakSelf.mj_footer.hidden = YES;
                [weakSelf showBlankWithImage:weakSelf.blankImage title:weakSelf.blankTitle message:message action:nil];
            } else {
                weakSelf.mj_footer.hidden = NO;
                [weakSelf dismissBlank];
                [SVProgressHUD showErrorWithStatus:message];
            }
        }];
    }];
    self.mj_header = header;
}

- (void)addRefreshFooter {
    if (!self.allowShowMore) {
        return;
    }
    if (self.mj_footer) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    WQRefreshFooter *footer = [WQRefreshFooter footerWithRefreshingBlock:^{
        NSUInteger pageIndex = weakSelf.pageIndex + 1;
        [self.refreshDelegate tableView:weakSelf pageSize:weakSelf.pageSize pageIndex:pageIndex success:^(NSArray *list) {
            weakSelf.pageIndex = pageIndex;
            [weakSelf.mj_footer endRefreshing];
            [weakSelf.dataArray addObjectsFromArray:list];
            [weakSelf reloadData];
            
            if (list.count < weakSelf.pageSize) {
                [weakSelf.mj_footer endRefreshingWithNoMoreData];
            } else {
                [weakSelf.mj_footer endRefreshing];
            }
            
            if (weakSelf.allowShowBlank && weakSelf.dataArray.count==0) {
                weakSelf.mj_footer.hidden = YES;
                [weakSelf showBlankWithImage:weakSelf.blankImage title:weakSelf.blankTitle message:weakSelf.blankMessage action:nil];
            } else {
                weakSelf.mj_footer.hidden = NO;
                [weakSelf dismissBlank];
            }
        } failure:^(NSError *error) {
            [weakSelf.mj_footer endRefreshing];
            
            NSString *message = error.localizedDescription?:weakSelf.blankMessage;
            if (weakSelf.allowShowBlank && weakSelf.dataArray.count==0) {
                weakSelf.mj_footer.hidden = YES;
                [weakSelf showBlankWithImage:weakSelf.blankImage title:weakSelf.blankTitle message:message action:nil];
            } else {
                weakSelf.mj_footer.hidden = NO;
                [weakSelf dismissBlank];
                [SVProgressHUD showErrorWithStatus:message];
            }
        }];
    }];
    self.mj_footer = footer;
}

/**********************************************************************/
#pragma mark - Public
/**********************************************************************/

- (void)refreshData {
    [self.mj_header beginRefreshing];
}

@end
