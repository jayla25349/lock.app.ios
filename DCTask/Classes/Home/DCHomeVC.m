//
//  DCHomeVC.m
//  DCTask
//
//  Created by 青秀斌 on 16/9/3.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "DCHomeVC.h"
#import "DCHomeCell.h"
#import "DCCheckVC.h"
#import "DCLoginVC.h"
#import "DCSettingVC.h"
#import "DCOpenDoorVC.h"
#import "BSNavigationController.h"

static NSString *cellIdentifier = @"DCHomeCell";

@interface DCHomeVC ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIView *bannerView;
@property (nonatomic, strong) UIImageView *bannerImageView;
@property (nonatomic, strong) UIButton *openDoorButton;
@property (nonatomic, strong) UIButton *settingButton;

@property (nonatomic, strong) UIView *selectView;
@property (nonatomic, strong) UIButton *selectButton1;
@property (nonatomic, strong) UIButton *selectButton2;
@property (nonatomic, strong) UIButton *selectButton3;
@property (nonatomic, strong) UIImageView *selectCursorImageView;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITableView *tableView1;
@property (nonatomic, strong) UITableView *tableView2;
@property (nonatomic, strong) UITableView *tableView3;
@end

@implementation DCHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)initView {
    
    if (self.bannerView == nil) {
        self.bannerView = [[UIView alloc] init];
        [self.view addSubview:self.bannerView];
        [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
            make.width.equalTo(self.bannerView.mas_height).multipliedBy(750.0f/378.0f);
        }];
        
        self.bannerImageView = [[UIImageView alloc] init];
        self.bannerImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.bannerImageView.image = [UIImage imageNamed:@"home_banner"];
        [self.bannerView addSubview:self.bannerImageView];
        [self.bannerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.bannerView);
        }];
        
        
        CGRect bounds = CGRectMake(0, 0, 44, 22);
        UIImage *image = [UIImage imageWithSize:bounds.size drawBlock:^(CGContextRef  _Nonnull context) {
            CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(bounds, 0.5, 0.5)
                                                            cornerRadius:5.0f];
            [path setLineWidth:1.0f];
            [path stroke];
        }];
        self.openDoorButton = [[UIButton alloc] init];
        self.openDoorButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.openDoorButton setTitle:@"开门" forState:UIControlStateNormal];
        [self.openDoorButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.openDoorButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [self.openDoorButton setBackgroundImage:image forState:UIControlStateNormal];
        [self.openDoorButton addTarget:self action:@selector(openDoorAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.bannerView addSubview:self.openDoorButton];
        [self.openDoorButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(bounds.size);
        }];
        
        self.settingButton = [[UIButton alloc] init];
        [self.settingButton setImage:[UIImage imageNamed:@"navbar_setting"] forState:UIControlStateNormal];
        [self.settingButton addTarget:self action:@selector(settingAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.bannerView addSubview:self.settingButton];
        [self.settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bannerView).offset(20);
            make.left.equalTo(self.openDoorButton.mas_right).offset(10);
            make.right.equalTo(self.bannerView);
            make.centerY.equalTo(self.openDoorButton);
            make.size.mas_equalTo(CGSizeMake(44, 44));
        }];
    }
    
    if (self.selectView == nil) {
        self.selectView = [[UIView alloc] init];
        self.selectView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.selectView];
        [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bannerView.mas_bottom);
            make.left.right.equalTo(self.view);
            make.height.equalTo(@40);
        }];
        
        self.selectButton1 = [[UIButton alloc] init];
        self.selectButton1.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.selectButton1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.selectButton1 setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        [self.selectButton1 setTitle:@"待处理(3)" forState:UIControlStateNormal];
        [self.selectView addSubview:self.selectButton1];
        [self.selectButton1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self.selectView);
        }];
        
        self.selectButton2 = [[UIButton alloc] init];
        self.selectButton2.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.selectButton2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.selectButton2 setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        [self.selectButton2 setTitle:@"处理中(99)" forState:UIControlStateNormal];
        [self.selectView addSubview:self.selectButton2];
        [self.selectButton2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.selectButton1.mas_right);
            make.top.bottom.equalTo(self.selectView);
            make.width.equalTo(self.selectButton1);
        }];
        
        self.selectButton3 = [[UIButton alloc] init];
        self.selectButton3.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.selectButton3 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.selectButton3 setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        [self.selectButton3 setTitle:@"未提交(1)" forState:UIControlStateNormal];
        [self.selectView addSubview:self.selectButton3];
        [self.selectButton3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.selectButton2.mas_right);
            make.top.bottom.right.equalTo(self.selectView);
            make.width.equalTo(self.selectButton2);
        }];
    }
    
    if (self.scrollView == nil) {
        self.scrollView = [[UIScrollView alloc] init];
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:self.scrollView];
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.selectView.mas_bottom).offset(1);
            make.left.right.bottom.equalTo(self.view);
        }];
        
        self.tableView1 = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.tableView1.delegate = self;
        self.tableView1.dataSource = self;
        self.tableView1.backgroundColor = [UIColor clearColor];
        self.tableView1.rowHeight = 80;
        self.tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView1 registerClass:[DCHomeCell class] forCellReuseIdentifier:cellIdentifier];
        [self.scrollView addSubview:self.tableView1];
        [self.tableView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.height.width.equalTo(self.scrollView);
            make.left.equalTo(self.scrollView);
        }];
        
        self.tableView2 = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.tableView2.delegate = self;
        self.tableView2.dataSource = self;
        self.tableView2.backgroundColor = [UIColor clearColor];
        self.tableView2.rowHeight = 80;
        self.tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView2 registerClass:[DCHomeCell class] forCellReuseIdentifier:cellIdentifier];
        [self.scrollView addSubview:self.tableView2];
        [self.tableView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.height.width.equalTo(self.scrollView);
            make.left.equalTo(self.tableView1.mas_right);
        }];
        
        self.tableView3 = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.tableView3.delegate = self;
        self.tableView3.dataSource = self;
        self.tableView3.backgroundColor = [UIColor clearColor];
        self.tableView3.rowHeight = 80;
        self.tableView3.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView3 registerClass:[DCHomeCell class] forCellReuseIdentifier:cellIdentifier];
        [self.scrollView addSubview:self.tableView3];
        [self.tableView3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.height.width.equalTo(self.scrollView);
            make.left.equalTo(self.tableView2.mas_right);
            make.right.equalTo(self.scrollView);
        }];
    }
}

/**********************************************************************/
#pragma mark - Action
/**********************************************************************/

- (void)openDoorAction:(id)sener {
    DCOpenDoorVC *vc = [[DCOpenDoorVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)settingAction:(id)sender {
    DCSettingVC *vc = [[DCSettingVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

/**********************************************************************/
#pragma mark - UITableViewDataSource && UITableViewDelegate
/**********************************************************************/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:cellIdentifier cacheByIndexPath:indexPath configuration:^(id cell) {
        
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DCHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DCCheckVC *vc = [[DCCheckVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
