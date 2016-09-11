//
//  DCChangePwdVC.m
//  DCTask
//
//  Created by 青秀斌 on 16/9/4.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "DCChangePwdVC.h"
#import "DCChangePwdCell.h"

static NSString *cellIdentifier = @"DCChangePwdCell";

@interface DCChangePwdVC ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation DCChangePwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    
    [self initView];
}

- (void)initView {
    
    if (self.tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.rowHeight = 44;
        self.tableView.sectionHeaderHeight = 10;
        self.tableView.sectionFooterHeight = 10;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[DCChangePwdCell class] forCellReuseIdentifier:cellIdentifier];
        [self.view addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
}

/**********************************************************************/
#pragma mark - UITableViewDataSource && UITableViewDelegate
/**********************************************************************/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DCChangePwdCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    switch (indexPath.row) {
        case 0:{
            
        }break;
        case 1:{
            
        }break;
        case 2:{
            
        }break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
