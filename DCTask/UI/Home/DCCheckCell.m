//
//  DCCheckCell.m
//  DCTask
//
//  Created by 青秀斌 on 16/9/12.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "DCCheckCell.h"
#import "DCCheckImageCell.h"
#import "DCCheckEditCell.h"

static NSString * const imageCellIdentifier = @"DCCheckImageCell";
static NSString * const editCellIdentifier = @"DCCheckEditCell";

@interface DCCheckCell ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *normalButton;
@property (weak, nonatomic) IBOutlet UIButton *errorButton;
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) PlanItem *planItem;
@property (nonatomic, strong) NSArray<Picture *> *pics;
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
    self.pics = [Picture MR_findAllSortedBy:@"createDate"
                                  ascending:YES
                              withPredicate:[NSPredicate predicateWithFormat:@"planItem=%@", planItem]];
    
    self.titleLabel.text = [NSString stringWithFormat:@"%ld.%ld %@", indexPath.section+1, indexPath.row+1, planItem.item_name];
    self.normalButton.selected = (planItem.check_state.integerValue==0)?YES:NO;
    self.errorButton.selected = (planItem.check_state.integerValue==1)?YES:NO;
    self.inputTextView.text = planItem.check_result;
    
    [self.collectionView reloadData];
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        NSInteger itemCount = self.pics.count + 1;
        NSInteger rowCount = itemCount%4==0?itemCount/4:itemCount/4+1;
        make.height.mas_equalTo(70*rowCount + 20*(rowCount-1));
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
    return self.pics.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.pics.count) {
        DCCheckImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:imageCellIdentifier forIndexPath:indexPath];
        
        Picture *picture = self.pics[indexPath.item];
        NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        NSString *filePath = [docPath stringByAppendingPathComponent:picture.name];
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        cell.imageView.image = image;
        
        return cell;
    } else {
        DCCheckEditCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:editCellIdentifier forIndexPath:indexPath];
        
        return cell;
    }
}

/**********************************************************************/
#pragma mark - UICollectionViewDelegateFlowLayout
/**********************************************************************/

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.pics.count) {
        if ([self.delegate respondsToSelector:@selector(checkCell:didSelectImage:)]) {
            [self.delegate checkCell:self didSelectImage:indexPath.item];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(checkCell:didSelectEdit:)]) {
            [self.delegate checkCell:self didSelectEdit:indexPath.item];
        }
    }
}

@end
