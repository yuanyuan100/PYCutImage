//
//  PYCutImageManager.h
//  cutImageDemo
//
//  Created by Snake on 16/12/26.
//  Copyright © 2016年 IAsk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol PYCutImageManagerDelegate;

@interface PYCutImageManager : NSObject
/**
 初始化裁剪对象

 @param aspect 裁剪比例 widht/height
 @param width 宽度
 @param viewController 当前控制器
 @return self
 */
- (instancetype)initWithAspect:(CGFloat)aspect width:(CGFloat)width viewController:(__kindof UIViewController *)viewController;
@property (nonatomic, weak) id<PYCutImageManagerDelegate> delegate;
- (void)goSeleteImage;
@end
@protocol PYCutImageManagerDelegate <NSObject>
@optional
/**
 取消

 @param image 原图
 */
- (void)py_cutImageManagerDidCancelWithOrignImage:(UIImage *)image;
@required
/**
 裁剪

 @param image 裁剪后的图
 */
- (void)py_cutImageManagerDidEditedWithImage:(UIImage *)image;
@end
