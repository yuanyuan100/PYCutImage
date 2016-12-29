//
//  UIImage+PYEditImage.h
//  cutImageDemo
//
//  Created by Snake on 16/12/26.
//  Copyright © 2016年 IAsk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (PYEditImage)
- (UIImage *)py_getSubImage:(CGRect)rect;
- (UIImage *)py_fixOrientation;
@end
