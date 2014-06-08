//
//  UIImage+ADToolkitAdditions.h
//  alldayDO
//
//  Created by Fábio Nogueira  on 07/06/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ADToolkitAdditions)

- (UIImage *)tintedImageWithColor:(UIColor *)tintColor;
- (UIImage *)tintedGradientImageWithColor:(UIColor *)tintColor;

@end
