//
//  WQBlankView.h
//  Kylin
//
//  Created by 青秀斌 on 16/4/22.
//
//

#import <UIKit/UIKit.h>
@class WQBlankView;

typedef WQBlankView *(^BlankImageBlock)(UIImage *);
typedef WQBlankView *(^BlankTextBlock)(NSString *);
typedef WQBlankView *(^BlankOffsetBlock)(CGFloat);

@interface WQBlankView : UIView
@property (copy, nonatomic) BlankImageBlock image;
@property (copy, nonatomic) BlankTextBlock title;
@property (copy, nonatomic) BlankTextBlock message;
@property (copy, nonatomic) BlankOffsetBlock offsetY;

@end
