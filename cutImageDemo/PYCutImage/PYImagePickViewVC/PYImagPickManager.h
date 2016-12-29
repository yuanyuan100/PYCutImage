//
//  PYImagPickManager.h
//  cutImageDemo
//
//  Created by Snake on 16/12/26.
//  Copyright © 2016年 IAsk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol PYImagPickManagerDelegate;

@interface PYImagPickManager : NSObject
/** 管理对象 */
+ (instancetype)managerWithViewController:(__kindof UIViewController *)controller;
/** 弹出选择 相机 相册 取消 */
- (void)showItme;
@property (nonatomic, weak) id<PYImagPickManagerDelegate>delegate;
/** 是否允许裁剪为正方形，默认NO */
@property (nonatomic, getter = isEditing, assign) BOOL edit;
@end

@protocol PYImagPickManagerDelegate <NSObject>

@optional
/** 弹出选择 相机2 相册1 取消0 的回调 */
- (void)py_ImagePickManager:(PYImagPickManager *)manager index:(NSInteger)index;
/** 裁剪后的图片 */
- (void)py_ImagePickManager:(PYImagPickManager *)manager cutImage:(UIImage *)image;
@required
/** 选择的原始图片 */
- (void)py_ImagePickManager:(PYImagPickManager *)manager originImage:(UIImage *)image;
@end
