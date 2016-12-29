//
//  ViewController.m
//  cutImageDemo
//
//  Created by Snake on 16/12/24.
//  Copyright © 2016年 IAsk. All rights reserved.
//

#import "ViewController.h"
#import "PYCutImageHeader.h"

#ifndef UI_SCREEN_WIDTH
#define UI_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#endif

#ifndef UI_SCREEN_HEIGHT
#define UI_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#endif

@interface ViewController () <PYCutImageManagerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *showImage;
@property (nonatomic, strong) PYCutImageManager *manager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.manager = [[PYCutImageManager alloc] initWithAspect:5/2.0f width:UI_SCREEN_WIDTH viewController:self];
    self.manager.delegate = self;
}

- (void)py_cutImageManagerDidEditedWithImage:(UIImage *)image {
    self.showImage.image = image;
}

- (void)py_cutImageManagerDidCancelWithOrignImage:(UIImage *)image {

}
- (IBAction)cutImage:(id)sender {
    [self.manager goSeleteImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
