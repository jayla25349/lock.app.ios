//
//  WQRefreshHeader.m
//  Kylin
//
//  Created by 青秀斌 on 15/12/14.
//
//

#import "WQRefreshHeader.h"

@interface WQRefreshHeader()
@property (strong, nonatomic) UIImageView *loadingView;
@property (strong, nonatomic) UILabel *stateLabel;

@property (nonatomic, assign) CGFloat anmitationRotate;
@property (nonatomic, assign) BOOL isAnimation;
@end

@implementation WQRefreshHeader

- (instancetype)init {
    self = [super init];
    self.textForIdle = @"下拉即可刷新...";
    self.textForPulling = @"释放即可刷新...";
    self.textForRefreshing = @"正在刷新...";
    return self;
}

/**********************************************************************/
#pragma mark - WQThemeDelegate
/**********************************************************************/

- (void)viewSwitchTheme{
    self.loadingView.image = [UIImage imageNamed:@"下拉刷新"];
    self.stateLabel.textColor = [UIColor grayColor];
}

/**********************************************************************/
#pragma mark - Private
/**********************************************************************/

- (void)startAnimation {
    if (self.isAnimation) {
        return;
    }
    if (self.state == MJRefreshStateRefreshing) {
        self.isAnimation = YES;
        
        __weak typeof(self) weakSelf = self;
        CGAffineTransform angle = CGAffineTransformMakeRotation(fabs(self.anmitationRotate) *(M_PI)/45);
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            weakSelf.loadingView.transform = angle;
        } completion:^(BOOL finished) {
            weakSelf.anmitationRotate -= 30;
            weakSelf.isAnimation = NO;
            [weakSelf startAnimation];
        }];
    }
}

/**********************************************************************/
#pragma mark - OverWrite
/**********************************************************************/

- (void)prepare {
    [super prepare];
    self.mj_h = 50;
    self.automaticallyChangeAlpha = YES;
    
    if (self.loadingView == nil) {
        self.loadingView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"下拉刷新"]];
        [self addSubview:self.loadingView];
    }
    
    if (self.stateLabel == nil) {
        self.stateLabel = [[UILabel alloc] init];
        self.stateLabel.textAlignment = NSTextAlignmentCenter;
        self.stateLabel.font = [UIFont boldSystemFontOfSize:12];
        self.stateLabel.backgroundColor = [UIColor clearColor];
        self.stateLabel.textColor = [UIColor grayColor];
        [self addSubview:self.stateLabel];
    }
    
    [self viewSwitchTheme];
}

- (void)placeSubviews {
    [super placeSubviews];
    
    CGRect frame = self.bounds;
    frame.origin.x = 20;
    frame.size.width -= frame.origin.x;
    
    self.loadingView.center = CGPointMake(self.mj_w * 0.5 - 50, self.mj_h * 0.5);
    self.stateLabel.frame = frame;
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change{
    [super scrollViewContentOffsetDidChange:change];
    
    if (self.scrollView.isDragging && self.state != MJRefreshStateRefreshing) {
        self.anmitationRotate = self.scrollView.mj_offsetY;
        CGAffineTransform angle = CGAffineTransformMakeRotation(fabs(self.anmitationRotate) *(M_PI)/45);
        self.loadingView.transform = angle;
    }
}

- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState
    
    switch (state) {
        case MJRefreshStateIdle:{
            self.stateLabel.text = self.textForIdle;
        }break;
        case MJRefreshStatePulling:{
            self.stateLabel.text = self.textForPulling;
        }break;
        case MJRefreshStateRefreshing:{
            self.stateLabel.text = self.textForRefreshing;
            
            [self startAnimation];
        }break;
        default:break;
    }
}

@end
