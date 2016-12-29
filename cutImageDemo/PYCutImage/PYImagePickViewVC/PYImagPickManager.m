//
//  PYImagPickManager.m
//  cutImageDemo
//
//  Created by Snake on 16/12/26.
//  Copyright © 2016年 IAsk. All rights reserved.
//

#import "PYImagPickManager.h"

@interface PYImagPickManager () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) UIAlertController *alertVC;
@property (nonatomic, strong) UIImagePickerController *imagePickVC;
@property (nonatomic, weak) __kindof UIViewController *vc;
@end

@implementation PYImagPickManager
+ (instancetype)managerWithViewController:(__kindof UIViewController *)controller {
    PYImagPickManager *manager = [PYImagPickManager new];
    manager.vc = controller;
    return manager;
}

- (void)showItme {
    [self.vc presentViewController:self.alertVC animated:YES completion:nil];
}

#pragma mark - getter
- (UIAlertController *)alertVC {
    if (_alertVC) {
        return _alertVC;
    }
    return _alertVC = ({
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if ([self.delegate respondsToSelector:@selector(py_ImagePickManager:index:)]) {
                    [self.delegate py_ImagePickManager:self index:2];
                }
                [self showImagePickSoureType:UIImagePickerControllerSourceTypeCamera];
            }];
            [alert addAction:action1];
        }
       UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           if ([self.delegate respondsToSelector:@selector(py_ImagePickManager:index:)]) {
               [self.delegate py_ImagePickManager:self index:1];
           }
           [self showImagePickSoureType:UIImagePickerControllerSourceTypePhotoLibrary];
       }];
        
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if ([self.delegate respondsToSelector:@selector(py_ImagePickManager:index:)]) {
                [self.delegate py_ImagePickManager:self index:0];
            }
        }];
        
        [alert addAction:action2];
        [alert addAction:actionCancel];
        
        alert;
    });
}

- (UIImagePickerController *)imagePickVC {
    if (_imagePickVC) {
        return _imagePickVC;
    }
    return _imagePickVC = ({
        UIImagePickerController *pick = [[UIImagePickerController alloc] init];
        pick.delegate = self;
        pick.allowsEditing = self.isEditing;
        pick;
    });
}

- (void)showImagePickSoureType:(UIImagePickerControllerSourceType)sourceTyep {
    self.imagePickVC.sourceType = sourceTyep;
    [self.vc presentViewController:self.imagePickVC animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    /* 此处info 有六个值
     * UIImagePickerControllerMediaType; // an NSString UTTypeImage)
     * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
     * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图片
     * UIImagePickerControllerCropRect;       // an NSValue (CGRect)
     * UIImagePickerControllerMediaURL;       // an NSURL
     * UIImagePickerControllerReferenceURL    // an NSURL that references an asset in the AssetsLibrary framework
     * UIImagePickerControllerMediaMetadata    // an NSDictionary containing metadata from a captured photo
     */
    if (self.isEditing) {
        if ([self.delegate respondsToSelector:@selector(py_ImagePickManager:cutImage:)]) {
            [self.delegate py_ImagePickManager:self cutImage:info[UIImagePickerControllerEditedImage]];
        }
    }
    if ([self.delegate respondsToSelector:@selector(py_ImagePickManager:originImage:)]) {
        [self.delegate py_ImagePickManager:self originImage:info[UIImagePickerControllerOriginalImage]];
    }
}
@end
