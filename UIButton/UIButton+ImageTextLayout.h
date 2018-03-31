//
//  UIButton+ImageTextLayout.h
//  VideoPlayerForIphone
//
//  Created by zyh on 2017/10/23.
//  Copyright © 2017年 FengHongen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UIButtonImageTextStyle) {
    UIButtonImageTextStyleImageUpTextDown,
    UIButtonImageTextStyleImageDownTextUp,
    UIButtonImageTextStyleImageLeftTextRight,
    UIButtonImageTextStyleImageRightTextLeft
};

@interface UIButton (ImageTextLayout)

/*
 使用以下方法时，注意事项：
 1. 提前设置了button的frame。
 2. 提前设置了button的image和title。
 */

- (void)setImageTextStyle:(UIButtonImageTextStyle)style space:(CGFloat)space;

@end
