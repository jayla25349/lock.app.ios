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

@interface DCCheckVC ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;
@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property (weak, nonatomic) IBOutlet UIView *menuContentView;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIButton *lockButton;
@property (weak, nonatomic) IBOutlet UIButton *lastButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (nonatomic, strong) NSDictionary<NSString *, NSArray *> * dataSource;
@property (nonatomic, strong) NSArray<NSString *> * categorys;
@end

@implementation DCCheckVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.plan.plan_name;
    
    if (!self.editable) {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

/**********************************************************************/
#pragma mark - Private
/**********************************************************************/


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

- (IBAction)submitAction:(id)sender {
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

- (IBAction)tapAction:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self menuAction:self.menuButton];
    }
}

- (IBAction)menuAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.menuContentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0f];
        [self.menuTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.menuContentView.mas_left);
        }];
        [self.menuContentView layoutIfNeeded];
        [self.view bringSubviewToFront:self.menuContentView];
        
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.menuContentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
            [self.menuTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.menuContentView.mas_centerX);
            }];
            [self.menuContentView layoutIfNeeded];
        } completion:nil];
    } else {
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.menuContentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0f];
            [self.menuTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.menuContentView.mas_left);
            }];
            [self.menuContentView layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self.view sendSubviewToBack:self.menuContentView];
        }];
    }
}

- (IBAction)lockAction:(UIButton *)sender {
}

- (IBAction)lastAction:(UIButton *)sender {
}

- (IBAction)nextAction:(UIButton *)sender {
}

/**********************************************************************/
#pragma mark - UITableViewDataSource && UITableViewDelegate
/**********************************************************************/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.contentTableView) {
        return self.categorys.count;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.contentTableView) {
        NSString *category = self.categorys[section];
        NSArray<PlanItem *> *items = self.dataSource[category];
        return items.count;
    } else {
        return self.categorys.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == self.contentTableView) {
        NSString *category = self.categorys[section];
        return [NSString stringWithFormat:@"%ld.%@", section+1, category];
    } else {
        return @"选择巡检类别";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.contentTableView) {
        return [tableView fd_heightForCellWithIdentifier:cellIdentifier configuration:^(DCCheckCell *cell) {
            NSString *category = self.categorys[indexPath.section];
            NSArray<PlanItem *> *items = self.dataSource[category];
            PlanItem *planItem = items[indexPath.row];
            [cell configWithPlanItem:planItem indexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        }];
    } else {
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *category = self.categorys[indexPath.section];
    
    if (tableView == self.contentTableView) {
        DCCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell.editable = self.editable;
        
        NSArray<PlanItem *> *items = self.dataSource[category];
        PlanItem *planItem = items[indexPath.row];
        [cell configWithPlanItem:planItem indexPath:indexPath];
        
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"categoryIdentifier"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"categoryIdentifier"];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableview_cell_arrow"]];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"%ld.%@", indexPath.row+1, category];
        
        return cell;
    }
}

/**********************************************************************/
#pragma mark - UIGestureRecognizerDelegate
/**********************************************************************/

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if(touch.view != self.menuContentView){
        return NO;
    }else{
        return YES;
    }
}

@end
