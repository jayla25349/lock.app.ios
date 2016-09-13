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
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *titleLineView;

@property (nonatomic, strong) UIView *statusView;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIButton *statusButton1;
@property (nonatomic, strong) UIButton *statusButton2;
@property (nonatomic, strong) UIImageView *statusLineView;

@property (nonatomic, strong) UIView *conditionView;
@property (nonatomic, strong) UILabel *conditionLabel1;
@property (nonatomic, strong) UITextView *conditionTextView;
@property (nonatomic, strong) UILabel *conditionLabel2;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIImageView *conditionLineView;

@property (nonatomic, strong) PlanItem *planItem;
@end

@implementation DCCheckCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)prepareForReuse {
    self.planItem = nil;
    
    self.titleLabel.text = nil;
    self.statusButton1.selected = NO;
    self.statusButton2.selected = NO;
    self.conditionTextView.text = nil;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.planItem.managedObjectContext MR_saveToPersistentStoreWithCompletion:nil];
}

/**********************************************************************/
#pragma mark - Private
/**********************************************************************/

- (void)initView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //标题
    if (!self.titleView) {
        self.titleView = [[UIView alloc] init];
        [self.contentView addSubview:self.titleView];
        [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.left.right.equalTo(self.contentView);
            make.height.equalTo(@44);
        }];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.titleView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleView);
            make.left.equalTo(self.titleView).offset(15);
            make.right.equalTo(self.titleView).offset(-15);
        }];
        
        self.titleLineView = [[UIImageView alloc] init];
        self.titleLineView.backgroundColor = RGB(225, 225, 225);
        [self.titleView addSubview:self.titleLineView];
        [self.titleLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom);
            make.left.equalTo(self.titleView).offset(15);
            make.right.equalTo(self.titleView).offset(-15);
            make.bottom.equalTo(self.titleView);
            make.height.equalTo(@0.5f);
        }];
    }
    
    //状态
    if (!self.statusView) {
        self.statusView = [[UIView alloc] init];
        [self.contentView addSubview:self.statusView];
        [self.statusView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleView.mas_bottom);
            make.left.right.equalTo(self.contentView);
            make.height.equalTo(@44);
        }];
        
        self.statusLabel = [[UILabel alloc] init];
        self.statusLabel.font = [UIFont systemFontOfSize:12];
        self.statusLabel.textColor = [UIColor grayColor];
        self.statusLabel.textAlignment = NSTextAlignmentLeft;
        self.statusLabel.text = @"是否正常：";
        [self.statusView addSubview:self.statusLabel];
        [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.statusView);
            make.left.equalTo(self.statusView).offset(15);
        }];
        
        self.statusButton1 = [[UIButton alloc] init];
        self.statusButton1.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.statusButton1 setTitle:@"正常" forState:UIControlStateNormal];
        [self.statusButton1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.statusButton1 setImage:[UIImage imageNamed:@"check_btn_status_unSelect"] forState:UIControlStateNormal];
        [self.statusButton1 setImage:[UIImage imageNamed:@"check_btn_status_normal"] forState:UIControlStateSelected];
        [self.statusButton1 setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [self.statusButton1 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [self.statusButton1 addTarget:self action:@selector(normalStatusAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.statusView addSubview:self.statusButton1];
        [self.statusButton1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.statusView);
            make.left.equalTo(self.statusLabel.mas_right);
            make.width.equalTo(self.statusLabel);
        }];
        
        self.statusButton2 = [[UIButton alloc] init];
        self.statusButton2.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.statusButton2 setTitle:@"异常" forState:UIControlStateNormal];
        [self.statusButton2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.statusButton2 setImage:[UIImage imageNamed:@"check_btn_status_unSelect"] forState:UIControlStateNormal];
        [self.statusButton2 setImage:[UIImage imageNamed:@"check_btn_status_error"] forState:UIControlStateSelected];
        [self.statusButton2 setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [self.statusButton2 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [self.statusButton2 addTarget:self action:@selector(errorStatusAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.statusView addSubview:self.statusButton2];
        [self.statusButton2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.statusView);
            make.left.equalTo(self.statusButton1.mas_right);
            make.right.equalTo(self.statusView).offset(-15);
            make.width.equalTo(self.statusButton1);
        }];
        
        self.statusLineView = [[UIImageView alloc] init];
        self.statusLineView.backgroundColor = RGB(225, 225, 225);
        [self.statusView addSubview:self.statusLineView];
        [self.statusLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.statusLabel.mas_bottom);
            make.top.equalTo(self.statusButton1.mas_bottom);
            make.top.equalTo(self.statusButton2.mas_bottom);
            make.left.equalTo(self.statusView).offset(15);
            make.right.equalTo(self.statusView).offset(-15);
            make.bottom.equalTo(self.statusView);
            make.height.equalTo(@0.5f);
        }];
    }
    
    //备注
    if (!self.conditionView) {
        self.conditionView = [[UIView alloc] init];
        [self.contentView addSubview:self.conditionView];
        [self.conditionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.statusView.mas_bottom);
            make.left.right.bottom.equalTo(self.contentView);
        }];
        
        self.conditionLabel1 = [[UILabel alloc] init];
        self.conditionLabel1.font = [UIFont systemFontOfSize:12];
        self.conditionLabel1.textColor = [UIColor grayColor];
        self.conditionLabel1.textAlignment = NSTextAlignmentLeft;
        self.conditionLabel1.text = @"巡视情况/运行情况：";
        [self.conditionView addSubview:self.conditionLabel1];
        [self.conditionLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.conditionView).offset(15);
            make.left.equalTo(self.conditionView).offset(15);
            make.right.equalTo(self.conditionView).offset(-15);
        }];
        
        self.conditionTextView = [[UITextView alloc] init];
        self.conditionTextView.backgroundColor = RGB(225, 225, 225);
        self.conditionTextView.layer.cornerRadius = 7;
        self.conditionTextView.layer.masksToBounds = YES;
        [self.conditionView addSubview:self.conditionTextView];
        [self.conditionTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.conditionLabel1.mas_bottom).offset(10);
            make.left.equalTo(self.conditionView).offset(15);
            make.right.equalTo(self.conditionView).offset(-15);
            make.height.equalTo(@70);
        }];
        
        self.conditionLabel2 = [[UILabel alloc] init];
        self.conditionLabel2.font = [UIFont systemFontOfSize:12];
        self.conditionLabel2.textColor = [UIColor grayColor];
        self.conditionLabel2.textAlignment = NSTextAlignmentLeft;
        self.conditionLabel2.text = @"照片：";
        [self.conditionView addSubview:self.conditionLabel2];
        [self.conditionLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.conditionTextView.mas_bottom).offset(20);
            make.left.equalTo(self.conditionView).offset(15);
            make.right.equalTo(self.conditionView).offset(-15);
        }];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 20;
        layout.minimumInteritemSpacing = 20;
        layout.itemSize = CGSizeMake(60, 60);
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.scrollEnabled = NO;
        [self.collectionView registerClass:[DCCheckImageCell class] forCellWithReuseIdentifier:cellIdentifier];
        [self.conditionView addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.conditionLabel2.mas_bottom).offset(10);
            make.left.equalTo(self.conditionView).offset(15);
            make.right.equalTo(self.conditionView).offset(-15);
        }];
        
        self.conditionLineView = [[UIImageView alloc] init];
        self.conditionLineView.backgroundColor = [UIColor lightGrayColor];
        [self.conditionView addSubview:self.conditionLineView];
        [self.conditionLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.collectionView.mas_bottom).offset(15);
            make.left.right.bottom.equalTo(self.conditionView);
            make.height.equalTo(@0.5f);
        }];
        
        //注册文本改变通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textChanged:)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:self.conditionTextView];
    }
}

/**********************************************************************/
#pragma mark - Public
/**********************************************************************/

- (void)configWithPlanItem:(PlanItem *)planItem indexPath:(NSIndexPath *)indexPath {
    self.planItem = planItem;
    
    self.titleLabel.text = [NSString stringWithFormat:@"%ld.%ld %@", indexPath.section+1, indexPath.row+1, planItem.item_name];
    self.statusButton1.selected = (planItem.check_state.integerValue==0)?YES:NO;
    self.statusButton2.selected = (planItem.check_state.integerValue==1)?YES:NO;
    self.conditionTextView.text = planItem.check_result;
    
    [self.collectionView reloadData];
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(self.collectionView.contentSize.height);
        make.height.mas_equalTo(80);
    }];
}

/**********************************************************************/
#pragma mark - Action
/**********************************************************************/

- (void)normalStatusAction:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    self.statusButton1.selected = YES;
    self.statusButton2.selected = NO;
    self.planItem.check_state = @0;
}

- (void)errorStatusAction:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    self.statusButton1.selected = NO;
    self.statusButton2.selected = YES;
    self.planItem.check_state = @1;
}

- (void)textChanged:(NSNotification *)notification {
    self.planItem.check_result = self.conditionTextView.text;
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
