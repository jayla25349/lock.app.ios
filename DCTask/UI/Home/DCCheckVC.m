//
//  DCCheckVC.m
//  DCTask
//
//  Created by 青秀斌 on 16/9/4.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "DCCheckVC.h"
#import "DCCheckCell.h"

static NSString * const cellIdentifier = @"DCCheckCell";

@interface DCCheckVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) UITableView *menuTableView;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *menuButton;
@property (nonatomic, strong) UIButton *lockButton;
@property (nonatomic, strong) UIButton *lastButton;
@property (nonatomic, strong) UIButton *nextButton;

@property (nonatomic, strong) NSDictionary<NSString *, NSArray *> * dataSource;
@property (nonatomic, strong) NSArray<NSString *> * categorys;
@end

@implementation DCCheckVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.plan.plan_name;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(submitAction:)];
    [self initView];
}

/**********************************************************************/
#pragma mark - Private
/**********************************************************************/

- (void)initView {
    
    if (!self.tableView) {
        self.tableView = [[UITableView alloc] init];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[DCCheckCell class] forCellReuseIdentifier:cellIdentifier];
        [self.view addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
        }];
    }
    
    if (!self.menuView) {
        self.menuView = [[UIView alloc] init];
        [self.view addSubview:self.menuView];
        [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
        }];
        
        self.menuTableView = [[UITableView alloc] init];
        self.menuTableView.delegate = self;
        self.menuTableView.dataSource = self;
        [self.menuTableView registerClass:[DCCheckCell class] forCellReuseIdentifier:cellIdentifier];
        [self.menuView addSubview:self.menuTableView];
        [self.menuTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(self.menuView);
            make.width.equalTo(self.menuView).multipliedBy(0.5f);
        }];
        
        self.menuView.hidden = YES;
        [self.view sendSubviewToBack:self.menuView];
    }
    
    if (!self.bottomView) {
        self.bottomView = [[UIView alloc] init];
        self.bottomView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.bottomView];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tableView.mas_bottom);
            make.left.bottom.right.equalTo(self.view);
            make.left.bottom.right.equalTo(self.menuView);
            make.height.equalTo(@49);
        }];
        
        self.menuButton = [[UIButton alloc] init];
        [self.bottomView addSubview:self.menuButton];
        [self.menuButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.menuView);
            make.left.equalTo(self.menuView);
        }];
        
        self.lockButton = [[UIButton alloc] init];
        [self.bottomView addSubview:self.lockButton];
        [self.lockButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.menuView);
            make.left.equalTo(self.menuButton.mas_right);
            make.width.equalTo(self.menuButton);
        }];
        
        self.lastButton = [[UIButton alloc] init];
        [self.bottomView addSubview:self.lastButton];
        [self.lastButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.menuView);
            make.left.equalTo(self.lockButton.mas_right);
            make.width.equalTo(self.lockButton);
        }];
        
        self.nextButton = [[UIButton alloc] init];
        [self.bottomView addSubview:self.nextButton];
        [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.menuView);
            make.left.equalTo(self.lastButton.mas_right);
            make.width.equalTo(self.lastButton);
            make.right.equalTo(self.menuView);
        }];
    }
    
    [self.tableView reloadData];
}

- (void)setPlan:(Plan *)plan {
    _plan = plan;
    
    //分类
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    [plan.items enumerateObjectsUsingBlock:^(PlanItem * _Nonnull obj, BOOL * _Nonnull stop) {
        NSMutableArray *tempArray = tempDic[obj.item_cate_name];
        if (!tempArray) {
            tempArray = [NSMutableArray array];
            [tempDic setValue:tempArray forKey:obj.item_cate_name];
        }
        [tempArray addObject:obj];
    }];
    
    //排序
    self.dataSource = tempDic;
    self.categorys = tempDic.allKeysSorted;
    [self.categorys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray<PlanItem *> *tempArray = tempDic[obj];
        [tempArray sortUsingComparator:^NSComparisonResult(PlanItem * _Nonnull obj1, PlanItem * _Nonnull obj2) {
            return [obj1.item_name compare:obj2.item_name];
        }];
    }];
}

/**********************************************************************/
#pragma mark - Action
/**********************************************************************/

- (void)submitAction:(id)sender {
    NSArray<PlanItem *> *items = [self.plan unfinishedItems];
    if (items) {
        [SVProgressHUD showInfoWithStatus:@"未完成巡检，请完善后再提交"];
    } else {
        AlertView *alertView = [AlertView alertControllerWithTitle:@"确认要提交你的操作吗？" message:nil];
        [alertView addButtonWithTitle:@"确认" action:^(AlertView * _Nonnull alertView) {
            [self.plan submit];
            [self.navigationController popViewControllerAnimated:YES];
            [alertView dismiss];
        }];
        [alertView addButtonWithTitle:@"取消" action:nil];
        [alertView show];
    }
}

/**********************************************************************/
#pragma mark - UITableViewDataSource && UITableViewDelegate
/**********************************************************************/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.categorys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *category = self.categorys[section];
    NSArray<PlanItem *> *items = self.dataSource[category];
    return items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *category = self.categorys[section];
    return [NSString stringWithFormat:@"%ld.%@", section+1, category];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:cellIdentifier configuration:^(DCCheckCell *cell) {
        NSString *category = self.categorys[indexPath.section];
        NSArray<PlanItem *> *items = self.dataSource[category];
        PlanItem *planItem = items[indexPath.row];
        [cell configWithPlanItem:planItem indexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DCCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSString *category = self.categorys[indexPath.section];
    NSArray<PlanItem *> *items = self.dataSource[category];
    PlanItem *planItem = items[indexPath.row];
    [cell configWithPlanItem:planItem indexPath:indexPath];
    
    return cell;
}

@end
