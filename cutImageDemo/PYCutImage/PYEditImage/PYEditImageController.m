//
//  PYEditImageController.m
//  cutImageDemo
//
//  Created by Snake on 16/12/26.
//  Copyright © 2016年 IAsk. All rights reserved.
//

#import "PYEditImageController.h"
#import "PYEditingImageView.h"

@interface PYEditImageController ()
@property (nonatomic, strong) PYEditingImageView *editingImageView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) CGFloat aspect;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, strong) void(^UserActionBlock)(NSInteger, UIImage *);
@end

@implementation PYEditImageController
- (instancetype)initWithImage:(UIImage *)image aspect:(CGFloat)aspect width:(CGFloat)width action:(void (^)(NSInteger, UIImage *))complete {
    self = [super init];
    if (self) {
        self.image = image;
        self.aspect = aspect;
        self.width = width;
        self.UserActionBlock = complete;
    }
    return self;
}

- (void)loadView {
    self.view = self.editingImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - getter 
- (PYEditingImageView *)editingImageView {
    if (_editingImageView) {
        return _editingImageView;
    }
    return _editingImageView = ({
        PYEditingImageView *view = [[PYEditingImageView alloc] initWithImage:self.image aspect:self.aspect width:self.width action:^(NSInteger action, UIImage *editedImage) {
            [self dismissViewControllerAnimated:YES completion:nil];
            if (self.UserActionBlock) {
                self.UserActionBlock(action, editedImage);
            }
        }];
        view.frame = [UIScreen mainScreen].bounds;
        view;
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
