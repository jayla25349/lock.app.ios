//
//  DCCheckCell.m
//  DCTask
//
//  Created by 青秀斌 on 16/9/12.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "DCCheckCell.h"
#import "DCCheckImageCell.h"

static NSString * const cellIdentifier = @"DCCheckImageCell";

@interface DCCheckCell ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *normalButton;
@property (weak, nonatomic) IBOutlet UIButton *errorButton;
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) PlanItem *planItem;
@end

@implementation DCCheckCell

- (void)prepareForReuse {
    self.planItem = nil;
    
    self.titleLabel.text = nil;
    self.normalButton.selected = NO;
    self.errorButton.selected = NO;
    self.inputTextView.text = nil;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.planItem.managedObjectContext MR_saveToPersistentStoreWithCompletion:nil];
}

/**********************************************************************/
#pragma mark - Private
/**********************************************************************/

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.normalButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    [self.errorButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    self.inputTextView.layer.cornerRadius = 5;
    self.inputTextView.layer.masksToBounds = YES;
    
    //注册文本改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textChanged:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self.inputTextView];
}

/**********************************************************************/
#pragma mark - Public
/**********************************************************************/

- (void)configWithPlanItem:(PlanItem *)planItem indexPath:(NSIndexPath *)indexPath {
    self.planItem = planItem;
    
    self.titleLabel.text = [NSString stringWithFormat:@"%ld.%ld %@", indexPath.section+1, indexPath.row+1, planItem.item_name];
    self.normalButton.selected = (planItem.check_state.integerValue==0)?YES:NO;
    self.errorButton.selected = (planItem.check_state.integerValue==1)?YES:NO;
    self.inputTextView.text = planItem.check_result;
    
    [self.collectionView reloadData];
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(self.collectionView.contentSize.height);
        make.height.mas_equalTo(80);
    }];
}

- (void)setEditable:(BOOL)editable {
    _editable = editable;
    
    self.contentView.userInteractionEnabled = editable;
}

/**********************************************************************/
#pragma mark - Action
/**********************************************************************/

- (IBAction)normalStatusAction:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    self.normalButton.selected = YES;
    self.errorButton.selected = NO;
    self.planItem.check_state = @0;
}

- (IBAction)errorStatusAction:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    self.normalButton.selected = NO;
    self.errorButton.selected = YES;
    self.planItem.check_state = @1;
}

- (void)textChanged:(NSNotification *)notification {
    self.planItem.check_result = self.inputTextView.text;
}

/**********************************************************************/
#pragma mark - UICollectionViewDataSource
/**********************************************************************/

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DCCheckImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    [cell.imageView yy_setImageWithURL:[NSURL URLWithString:@"http://img5q.duitang.com/uploads/item/201505/16/20150516214039_mujEZ.thumb.224_0.jpeg"]
                               options:0];
    return cell;
}

/**********************************************************************/
#pragma mark - UICollectionViewDelegateFlowLayout
/**********************************************************************/


@end
