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

@interface DCHomeVC ()<UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (weak, nonatomic) IBOutlet UIButton *openDoorButton;
@property (weak, nonatomic) IBOutlet UIButton *settingButton;

@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet UIButton *selectButton1;
@property (weak, nonatomic) IBOutlet UIButton *selectButton2;
@property (weak, nonatomic) IBOutlet UIButton *selectButton3;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView1;
@property (weak, nonatomic) IBOutlet UITableView *tableView2;
@property (weak, nonatomic) IBOutlet UITableView *tableView3;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController1;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController2;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController3;
@end

@implementation DCHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [Plan MR_performFetch:self.fetchedResultsController1];
    if ([self.fetchedResultsController1 fetchedObjects].count==0) {
        [self.tableView1 showBlankLoadNoData:nil];
    }
    [Plan MR_performFetch:self.fetchedResultsController2];
    if ([self.fetchedResultsController2 fetchedObjects].count==0) {
        [self.tableView2 showBlankLoadNoData:nil];
    }
    [Plan MR_performFetch:self.fetchedResultsController3];
    if ([self.fetchedResultsController3 fetchedObjects].count==0) {
        [self.tableView3 showBlankLoadNoData:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

/**********************************************************************/
#pragma mark - Private
/**********************************************************************/

- (void)initView {
    
//    CGRect bounds = CGRectMake(0, 0, 44, 22);
//    UIImage *image = [UIImage imageWithSize:bounds.size drawBlock:^(CGContextRef  _Nonnull context) {
//        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
//        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(bounds, 0.5, 0.5)
//                                                        cornerRadius:5.0f];
//        [path setLineWidth:1.0f];
//        [path stroke];
//    }];
//    [self.openDoorButton setBackgroundImage:image forState:UIControlStateNormal];
}

- (NSFetchedResultsController *)fetchedResultsController1 {
    if (_fetchedResultsController1 != nil) {
        return _fetchedResultsController1;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user=%@ AND plan_status=0", [DCAppEngine shareEngine].userManager.user];
    _fetchedResultsController1 = [Plan MR_fetchAllSortedBy:@"createDate"
                                                 ascending:NO
                                             withPredicate:predicate
                                                   groupBy:nil
                                                  delegate:self];
    return _fetchedResultsController1;
}

- (NSFetchedResultsController *)fetchedResultsController2 {
    if (_fetchedResultsController2 != nil) {
        return _fetchedResultsController2;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user=%@ AND plan_status=1", [DCAppEngine shareEngine].userManager.user];
    _fetchedResultsController2 = [Plan MR_fetchAllSortedBy:@"decideDate"
                                                 ascending:NO
                                             withPredicate:predicate
                                                   groupBy:nil
                                                  delegate:self];
    return _fetchedResultsController2;
}

- (NSFetchedResultsController *)fetchedResultsController3 {
    if (_fetchedResultsController3 != nil) {
        return _fetchedResultsController3;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user=%@ AND plan_status=3", [DCAppEngine shareEngine].userManager.user];
    _fetchedResultsController3 = [Plan MR_fetchAllSortedBy:@"submitDate"
                                                 ascending:NO
                                             withPredicate:predicate
                                                   groupBy:nil
                                                  delegate:self];
    return _fetchedResultsController3;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.tableView1) {
        return [[self.fetchedResultsController1 sections] count];
    } else if (tableView == self.tableView2) {
        return [[self.fetchedResultsController2 sections] count];
    } else if (tableView == self.tableView3) {
        return [[self.fetchedResultsController3 sections] count];
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView1) {
        id<NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController1 sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    } else if (tableView == self.tableView2) {
        id<NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController2 sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    } else if (tableView == self.tableView3) {
        id<NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController3 sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:cellIdentifier cacheByIndexPath:indexPath configuration:^(DCHomeCell *cell) {
        Plan *plan = nil;
        if (tableView == self.tableView1) {
            plan = [self.fetchedResultsController1 objectAtIndexPath:indexPath];
        } else if (tableView == self.tableView2) {
            plan = [self.fetchedResultsController2 objectAtIndexPath:indexPath];
        } else if (tableView == self.tableView3) {
            plan = [self.fetchedResultsController3 objectAtIndexPath:indexPath];
        }
        [cell configWithPlan:plan index:indexPath.row+1];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DCHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    Plan *plan = nil;
    if (tableView == self.tableView1) {
        plan = [self.fetchedResultsController1 objectAtIndexPath:indexPath];
    } else if (tableView == self.tableView2) {
        plan = [self.fetchedResultsController2 objectAtIndexPath:indexPath];
    } else if (tableView == self.tableView3) {
        plan = [self.fetchedResultsController3 objectAtIndexPath:indexPath];
    }
    [cell configWithPlan:plan index:indexPath.row+1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Plan *plan = nil;
    if (tableView == self.tableView1) {
        plan = [self.fetchedResultsController1 objectAtIndexPath:indexPath];
        
        AlertView *alertView = [AlertView alertControllerWithTitle:@"请选择你的操作" message:nil];
        [alertView addButtonWithTitle:@"接收任务" action:^(AlertView * _Nonnull alertView) {
            [plan accept];
            [alertView dismiss];
        }];
        [alertView addButtonWithTitle:@"拒绝任务" action:^(AlertView * _Nonnull alertView) {
            [plan refuse];
            [alertView dismiss];
        }];
        [alertView addButtonWithTitle:@"取消" action:nil];
        [alertView show];
    } else if (tableView == self.tableView2) {
        plan = [self.fetchedResultsController2 objectAtIndexPath:indexPath];
        [self performSegueWithIdentifier:@"ShowCheckVC" sender:plan];
    } else if (tableView == self.tableView3) {
        plan = [self.fetchedResultsController3 objectAtIndexPath:indexPath];
        [self performSegueWithIdentifier:@"ShowCheckVC" sender:plan];
    }
}

/**********************************************************************/
#pragma mark - NSFetchedResultsControllerDelegate
/**********************************************************************/

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    UITableView *tableView = nil;
    if (controller == self.fetchedResultsController1) {
        tableView = self.tableView1;
    } else if (controller == self.fetchedResultsController2) {
        tableView = self.tableView2;
    } else if (controller == self.fetchedResultsController3) {
        tableView = self.tableView3;
    }
    [tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = nil;
    if (controller == self.fetchedResultsController1) {
        tableView = self.tableView1;
    } else if (controller == self.fetchedResultsController2) {
        tableView = self.tableView2;
    } else if (controller == self.fetchedResultsController3) {
        tableView = self.tableView3;
    }
    switch(type) {
        case NSFetchedResultsChangeInsert:{
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
        }break;
        case NSFetchedResultsChangeDelete:{
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            
        }break;
        case NSFetchedResultsChangeUpdate:{
            DCHomeCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            Plan *plan = [controller objectAtIndexPath:indexPath];
            [cell configWithPlan:plan index:indexPath.row+1];
        }break;
        case NSFetchedResultsChangeMove:{
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
        }break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    UITableView *tableView = nil;
    if (controller == self.fetchedResultsController1) {
        tableView = self.tableView1;
    } else if (controller == self.fetchedResultsController2) {
        tableView = self.tableView2;
    } else if (controller == self.fetchedResultsController3) {
        tableView = self.tableView3;
    }
    [tableView endUpdates];
    
    if ([controller fetchedObjects].count==0) {
        [tableView showBlankLoadNoData:nil];
    }
}

@end