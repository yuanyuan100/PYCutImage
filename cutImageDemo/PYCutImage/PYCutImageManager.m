//
//  PYCutImageManager.m
//  cutImageDemo
//
//  Created by Snake on 16/12/26.
//  Copyright © 2016年 IAsk. All rights reserved.
//

#import "PYCutImageManager.h"
#import "PYImagPickManager.h"
#import "PYEditImageController.h"

@interface PYCutImageManager () <PYImagPickManagerDelegate>
@property (nonatomic, strong) PYImagPickManager *imagePickManager;
@end

@implementation PYCutImageManager
{
    CGFloat _aspect;
    CGFloat _width;
    __kindof UIViewController *_viewControler;
}
- (instancetype)initWithAspect:(CGFloat)aspect width:(CGFloat)width viewController:(__kindof UIViewController *)viewController {
    self = [super init];
    if (self) {
        _aspect = aspect;
        _width = width;
        _viewControler = viewController;
        
        self.imagePickManager = [PYImagPickManager managerWithViewController:_viewControler];
        self.imagePickManager.delegate = self;
    }
    return self;
}

- (void)py_ImagePickManager:(PYImagPickManager *)manager originImage:(UIImage *)image {
    PYEditImageController *vc = [[PYEditImageController alloc] initWithImage:image aspect:_aspect width:_width action:^(NSInteger action, UIImage *editedImage) {
        if (action == 0) {
            if ([self.delegate respondsToSelector:@selector(py_cutImageManagerDidCancelWithOrignImage:)]) {
                [self.delegate py_cutImageManagerDidCancelWithOrignImage:editedImage];
            }
        } else if (action == 1) {
            if ([self.delegate respondsToSelector:@selector(py_cutImageManagerDidEditedWithImage:)]) {
                [self.delegate py_cutImageManagerDidEditedWithImage:editedImage];
            }
        }
    }];
    [_viewControler presentViewController:vc animated:YES completion:nil];
}

- (void)goSeleteImage {
    [self.imagePickManager showItme];
}
@end
