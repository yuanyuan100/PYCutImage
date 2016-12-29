//
//  PYEditImageController.h
//  cutImageDemo
//
//  Created by Snake on 16/12/26.
//  Copyright © 2016年 IAsk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PYEditImageController : UIViewController
/**
 初始化裁剪对象Controller
 
 @param image 需要裁剪的图片
 @param aspect 裁剪比例 widht/height
 @param width 裁剪区域宽度
 @param complete 取消或确认的回调
 @return self
 */
-(instancetype)initWithImage:(UIImage *)image aspect:(CGFloat)aspect width:(CGFloat)width action:(void(^)(NSInteger action, UIImage *editedImage))complete;
@end
