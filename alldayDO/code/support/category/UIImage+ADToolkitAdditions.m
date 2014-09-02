//
//  UIImage+ADToolkitAdditions.m
//  alldayDO
//
//  Created by Fábio Nogueira  on 07/06/14.
//  Copyright (c) 2014 Fábio Nogueira . All rights reserved.
//

#import "UIImage+ADToolkitAdditions.h"

@implementation UIImage (ADToolkitAdditions)

- (UIImage *)tintedImageWithColor:(UIColor *)tintColor {
    return [self tintedImageWithColor:tintColor blendingMode:kCGBlendModeDestinationIn];
}

- (UIImage *)tintedGradientImageWithColor:(UIColor *)tintColor {
    return [self tintedImageWithColor:tintColor blendingMode:kCGBlendModeOverlay];
}

#pragma mark - Private Methods

- (UIImage *)tintedImageWithColor:(UIColor *)tintColor blendingMode:(CGBlendMode)blendMode {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.f);
    
    [tintColor setFill];
    CGRect bounds = CGRectMake(0.f, 0.f, self.size.width, self.size.height);
    UIRectFill(bounds);
    [self drawInRect:bounds blendMode:blendMode alpha:1.f];
    
    if (blendMode != kCGBlendModeDestinationIn) {
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.f];
    }
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}

@end
