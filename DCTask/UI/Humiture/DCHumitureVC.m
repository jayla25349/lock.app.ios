//
//  DCHumitureVC.m
//  DCTask
//
//  Created by 青秀斌 on 2016/10/28.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "DCHumitureVC.h"
#import "DCHumitureCell.h"

@interface DCHumitureVC ()<UITableViewDataSource, NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end

@implementation DCHumitureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Humiture MR_performFetch:self.fetchedResultsController];
}

/**********************************************************************/
#pragma mark - Private
/**********************************************************************/

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user=%@", [DCAppEngine shareEngine].userManager.user];
    _fetchedResultsController = [Humiture MR_fetchAllSortedBy:@"createDate"
                                                    ascending:NO
                                                withPredicate:predicate
                                                      groupBy:nil
                                                     delegate:self];
    return _fetchedResultsController;
}

/**********************************************************************/
#pragma mark - UITableViewDataSource
/**********************************************************************/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DCHumitureCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DCHumitureCell"];
    Humiture *humiture = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell configWithHumiture:humiture];
    return cell;
}

/**********************************************************************/
#pragma mark - NSFetchedResultsControllerDelegate
/**********************************************************************/

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    switch(type) {
        case NSFetchedResultsChangeInsert:{
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
        }break;
        case NSFetchedResultsChangeDelete:{
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            
        }break;
        case NSFetchedResultsChangeUpdate:{
            DCHumitureCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            Humiture *humiture = [controller objectAtIndexPath:indexPath];
            [cell configWithHumiture:humiture];
        }break;
        case NSFetchedResultsChangeMove:{
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
        }break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
    
    NSUInteger count = [controller fetchedObjects].count;
    if (count>0) {
        [self.tableView dismissBlank];
    } else {
        [self.tableView showBlankWithImage:[UIImage imageNamed:@"home_blank"] title:nil message:nil action:nil offsetY:-100];
    }
}

@end
