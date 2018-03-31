//
//  UIButton+ImageTextLayout.m
//  VideoPlayerForIphone
//
//  Created by zyh on 2017/10/23.
//  Copyright © 2017年 FengHongen. All rights reserved.
//

#import "UIButton+ImageTextLayout.h"

@implementation UIButton (ImageTextLayout)

- (void)setImageTextStyle:(UIButtonImageTextStyle)style space:(CGFloat)space
{
    CGRect imageRect = [self imageRectForContentRect:self.bounds];
    CGRect textRect = [self titleRectForContentRect:self.bounds];
    if ((int)textRect.size.width == 0 || (int)textRect.size.height == 0) {
        textRect.origin.x = imageRect.origin.x + imageRect.size.width;
        CGSize textSize = [self.titleLabel sizeThatFits:CGSizeZero];
        textSize.width = MIN(textSize.width, (self.bounds.size.width - textRect.origin.x - imageRect.origin.x));
        textRect.size = textSize;
        textRect.origin.y = (imageRect.origin.y + imageRect.size.height - textSize.height) / 2;
    }
    if ((int)textRect.size.width == 0 || (int)textRect.size.height == 0) {
        textRect.origin.x = imageRect.origin.x + imageRect.size.width;
        CGSize textSize = [self.titleLabel sizeThatFits:CGSizeZero];
        textSize.width = MIN(textSize.width, (self.bounds.size.width - textRect.origin.x - imageRect.origin.x));
        textRect.size = textSize;
        textRect.origin.y = (imageRect.origin.y + imageRect.size.height - textSize.height) / 2;
    }
    if (UIButtonImageTextStyleImageUpTextDown == style) {
        [self setImageEdgeInsets:UIEdgeInsetsMake(-textRect.size.height, textRect.size.width / 2, space, -(textRect.size.width / 2))];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(imageRect.size.height, -textRect.origin.x, -space, -(self.frame.size.width - textRect.origin.x - textRect.size.width))];
    } else if (UIButtonImageTextStyleImageDownTextUp == style) {
        [self setTitleEdgeInsets:UIEdgeInsetsMake(-imageRect.size.height, -textRect.origin.x, space, -(self.frame.size.width - textRect.origin.x - textRect.size.width))];
        [self setImageEdgeInsets:UIEdgeInsetsMake(textRect.size.height, textRect.size.width / 2, -space, -(textRect.size.width) / 2)];
    } else if (UIButtonImageTextStyleImageLeftTextRight == style) {
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, -space, 0, 0)];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -space)];
    } else if (UIButtonImageTextStyleImageRightTextLeft == style) {
        space = space / 2;
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, textRect.size.width + space, 0, -textRect.size.width - space)];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -imageRect.size.width - space, 0, imageRect.size.width + space)];
    }
}

@end
