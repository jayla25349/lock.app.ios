//
//  WQTextField.h
//  Pods
//
//  Created by Jayla on 16/3/23.
//
//

#import <UIKit/UIKit.h>

@interface WQTextField : UITextField
@property (nonatomic, assign) NSUInteger maxLength;
@property (nonatomic, assign) UIEdgeInsets textEdge;
@property (nonatomic, assign) CGPoint leftOffset;
@property (nonatomic, strong) UIImage *leftImage;
@end
