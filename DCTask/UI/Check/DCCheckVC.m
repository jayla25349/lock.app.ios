//
//  DCCheckVC.m
//  DCTask
//
//  Created by 青秀斌 on 16/9/4.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "DCCheckVC.h"
#import "DCCheckListCell.h"
#import "DCCheckMenuCell.h"

static NSString * const listCellIdentifier = @"DCCheckListCell";
static NSString * const menuCellIdentifier = @"DCCheckMenuCell";

@interface DCCheckVC ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, DCCheckListCellDelegate, MWPhotoBrowserDelegate>
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;
@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property (weak, nonatomic) IBOutlet UIView *menuContentView;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIButton *lockButton;
@property (weak, nonatomic) IBOutlet UIButton *lastButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (nonatomic, strong) NSDictionary<NSString *, NSArray *> * dataSource;
@property (nonatomic, strong) NSArray<NSString *> * categorys;

@property (nonatomic, strong) DCCheckListCell *currentCheckCell;
@end

@implementation DCCheckVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.plan.plan_name;
    
    if (!self.editable) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    [self reloadData];
}

/**********************************************************************/
#pragma mark - Private
/**********************************************************************/

- (void)reloadData {
    
    //分类
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    [self.plan.items enumerateObjectsUsingBlock:^(PlanItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
    
    //设置默认选中
    if (self.categorys.count>0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.menuTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
}

/**********************************************************************/
#pragma mark - Action
/**********************************************************************/

- (IBAction)submitAction:(id)sender {
    __block NSString *message = nil;
    [self.categorys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
        NSArray<PlanItem *> *items = self.dataSource[obj1];
        [items enumerateObjectsUsingBlock:^(PlanItem * _Nonnull obj2, NSUInteger idx2, BOOL * _Nonnull stop2) {
            if (obj2.result.length==0 || obj2.state.integerValue==-1) {
                message = [NSString stringWithFormat:@"%lu.%lu未填写巡检内容", idx1+1, idx2+1];
                *stop1 = YES;
                *stop2 = YES;
            }
        }];
    }];
    if (message) {
        [SVProgressHUD showInfoWithStatus:message];
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
                make.left.equalTo(self.menuContentView.mas_left);
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
    NSInteger index = self.menuTableView.indexPathForSelectedRow.row - 1;
    if (index>=0 && index<self.categorys.count) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.menuTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self.contentTableView reloadData];
    } else {
        [SVProgressHUD showInfoWithStatus:@"已是最开始一项！"];
    }
}

- (IBAction)nextAction:(UIButton *)sender {
    NSInteger index = self.menuTableView.indexPathForSelectedRow.row + 1;
    if (index>=0 && index<self.categorys.count) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.menuTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self.contentTableView reloadData];
    } else {
        [SVProgressHUD showInfoWithStatus:@"已是最后一项！"];
    }
}

/**********************************************************************/
#pragma mark - UITableViewDataSource && UITableViewDelegate
/**********************************************************************/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.contentTableView) {
        NSInteger index = self.menuTableView.indexPathForSelectedRow.row;
        NSString *category = self.categorys[index];
        NSArray<PlanItem *> *items = self.dataSource[category];
        return items.count;
    } else {
        return self.categorys.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == self.contentTableView) {
        NSInteger index = self.menuTableView.indexPathForSelectedRow.row;
        NSString *category = self.categorys[index];
        return [NSString stringWithFormat:@"%ld.%@", index+1, category];
    } else {
        return @"选择巡检类别";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.contentTableView) {
        NSInteger index = self.menuTableView.indexPathForSelectedRow.row;
        NSString *category = self.categorys[index];
        NSArray<PlanItem *> *items = self.dataSource[category];
        PlanItem *planItem = items[indexPath.row];
        
        return [tableView fd_heightForCellWithIdentifier:listCellIdentifier configuration:^(DCCheckListCell *cell) {
            [cell configWithPlanItem:planItem serial:[NSString stringWithFormat:@"%ld.%ld", index+1, indexPath.row+1]];
        }];
    } else {
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.contentTableView) {
        NSInteger index = self.menuTableView.indexPathForSelectedRow.row;
        NSString *category = self.categorys[index];
        NSArray<PlanItem *> *items = self.dataSource[category];
        PlanItem *planItem = items[indexPath.row];
        
        DCCheckListCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellIdentifier];
        cell.delegate = self;
        cell.editable = self.editable;
        [cell configWithPlanItem:planItem serial:[NSString stringWithFormat:@"%ld.%ld", index+1, indexPath.row+1]];
        
        return cell;
    } else {
        NSString *category = self.categorys[indexPath.row];
        
        DCCheckMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:menuCellIdentifier];
        cell.textLabel.text = [NSString stringWithFormat:@"%ld.%@", indexPath.row+1, category];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.menuTableView) {
        [self.contentTableView reloadData];
        [self menuAction:self.menuButton];
    }
}

/**********************************************************************/
#pragma mark - DCCheckListCellDelegate
/**********************************************************************/

- (void)checkListCell:(DCCheckListCell *)cell didSelectImage:(NSInteger)index {
    self.currentCheckCell = cell;
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.enableGrid = NO;
    [browser setCurrentPhotoIndex:index];
    [self.navigationController pushViewController:browser animated:YES];
}

- (void)checkListCell:(DCCheckListCell *)cell didSelectEdit:(NSInteger)index {
    self.currentCheckCell = cell;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    } else {
        [SVProgressHUD showInfoWithStatus:@"相机不可用"];
    }
}

/**********************************************************************/
#pragma mark - UIImagePickerControllerDelegate
/**********************************************************************/

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self.currentCheckCell.planItem addImage:image completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        if (error) {
            [SVProgressHUD showInfoWithStatus:@"添加图片失败"];
        } else {
            [self.contentTableView reloadData];
            [picker dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

/**********************************************************************/
#pragma mark - MWPhotoBrowserDelegate
/**********************************************************************/

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.currentCheckCell.planItem.pics.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    NSString *fileName = self.currentCheckCell.planItem.pics[index].name;
    NSString *filePath = [DCUtil thumbnailPathWithName:fileName];
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    
    return [MWPhoto photoWithImage:image];
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    NSString *fileName = self.currentCheckCell.planItem.pics[index].name;
    NSString *filePath = [DCUtil imagePathWithName:fileName];
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    
    return [MWPhoto photoWithImage:image];
}
- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
    return [NSString stringWithFormat:@"%ld/%ld", index, self.currentCheckCell.planItem.pics .count];
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
