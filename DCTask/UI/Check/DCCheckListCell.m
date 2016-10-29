//
//  DCCheckListCell.m
//  DCTask
//
//  Created by 青秀斌 on 16/9/12.
//  Copyright © 2016年 kylincc. All rights reserved.
//

#import "DCCheckListCell.h"
#import "DCCheckImageCell.h"
#import "DCCheckAddCell.h"

static NSString * const imageCellIdentifier = @"DCCheckImageCell";
static NSString * const editCellIdentifier = @"DCCheckAddCell";

@interface DCCheckListCell ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *normalButton;
@property (weak, nonatomic) IBOutlet UIButton *errorButton;
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@property (weak, nonatomic) IBOutlet UITextField *noteTextField;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) PlanItem *planItem;
@end

@implementation DCCheckListCell

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.planItem.managedObjectContext MR_saveToPersistentStoreWithCompletion:nil];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.normalButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    [self.errorButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    
    self.inputTextView.layer.cornerRadius = 5;
    self.inputTextView.layer.borderWidth = 0.5f;
    self.inputTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.inputTextView.layer.masksToBounds = YES;
    
    self.noteTextField.layer.cornerRadius = 5;
    self.noteTextField.layer.borderWidth = 0.5f;
    self.noteTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.noteTextField.layer.masksToBounds = YES;
    
    //注册文本改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resultTextChanged:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self.inputTextView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(noteTextChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.noteTextField];
}

- (void)prepareForReuse {
    self.planItem = nil;
    
    self.titleLabel.text = nil;
    self.normalButton.selected = NO;
    self.errorButton.selected = NO;
    self.inputTextView.text = nil;
    self.noteTextField.text = nil;
}

/**********************************************************************/
#pragma mark - Public
/**********************************************************************/

- (void)configWithPlanItem:(PlanItem *)planItem serial:(NSString *)serial {
    self.planItem = planItem;
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@ %@", serial, planItem.item_name];
    self.normalButton.selected = (planItem.state.integerValue==0)?YES:NO;
    self.errorButton.selected = (planItem.state.integerValue==1)?YES:NO;
    switch (planItem.item_flag.integerValue) {
        case 0:{
            self.inputTextView.text = planItem.result;
        }break;
        case 1:{
            Humiture *humiture = [Humiture MR_findFirstByAttribute:@"room_name" withValue:planItem.plan.room_name];
            if (humiture && planItem.result.length==0) {
                self.inputTextView.text = [NSString stringWithFormat:@"温度：%.1f°C", humiture.temperature.floatValue];
            } else {
                self.inputTextView.text = planItem.result;
            }
        }break;
        case 2:{
            Humiture *humiture = [Humiture MR_findFirstByAttribute:@"room_name" withValue:planItem.plan.room_name];
            if (humiture && planItem.result.length==0) {
                self.inputTextView.text = [NSString stringWithFormat:@"湿度：%.0f%%", humiture.humidity.floatValue*100];
            } else {
                self.inputTextView.text = planItem.result;
            }
        }break;
        case 3:{
            Humiture *humiture = [Humiture MR_findFirstByAttribute:@"room_name" withValue:planItem.plan.room_name];
            if (humiture && planItem.result.length==0) {
                self.inputTextView.text = [NSString stringWithFormat:@"温度：%.1f°C\n湿度：%.0f%%",
                                           humiture.temperature.floatValue,
                                           humiture.humidity.floatValue*100];
            } else {
                self.inputTextView.text = planItem.result;
            }
        }break;
    }
    self.noteTextField.text = planItem.note;
    
    [self.collectionView reloadData];
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        NSInteger itemCount = planItem.pics.count + 1;
        NSInteger rowCount = itemCount%4==0?itemCount/4:itemCount/4+1;
        make.height.mas_equalTo(60*rowCount + 20*(rowCount-1));
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
    self.planItem.state = @0;
}

- (IBAction)errorStatusAction:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    self.normalButton.selected = NO;
    self.errorButton.selected = YES;
    self.planItem.state = @1;
}

- (void)resultTextChanged:(NSNotification *)notification {
    self.planItem.result = self.inputTextView.text;
}

- (void)noteTextChanged:(NSNotification *)notification {
    self.planItem.note = self.noteTextField.text;
}

/**********************************************************************/
#pragma mark - UICollectionViewDataSource
/**********************************************************************/

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.planItem.pics.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.planItem.pics.count) {
        DCCheckImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:imageCellIdentifier forIndexPath:indexPath];
        
        Picture *picture = self.planItem.pics[indexPath.item];
        NSString *path = [DCUtil thumbnailPathWithName:picture.name];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        cell.imageView.image = image;
        
        return cell;
    } else {
        DCCheckAddCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:editCellIdentifier forIndexPath:indexPath];
        
        return cell;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return (collectionView.width-60*4)/3.0f;
}

/**********************************************************************/
#pragma mark - UICollectionViewDelegateFlowLayout
/**********************************************************************/

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.planItem.pics.count) {
        if ([self.delegate respondsToSelector:@selector(checkListCell:didSelectImage:)]) {
            [self.delegate checkListCell:self didSelectImage:indexPath.item];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(checkListCell:didSelectEdit:)]) {
            [self.delegate checkListCell:self didSelectEdit:indexPath.item];
        }
    }
}

@end
