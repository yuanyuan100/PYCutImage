//
//  PYEditingImageView.m
//  cutImageDemo
//
//  Created by Snake on 16/12/26.
//  Copyright © 2016年 IAsk. All rights reserved.
//

#import "PYEditingImageView.h"
#import "UIImage+PYEditImage.h"

@interface PYEditingImageView ()
/** show image view */
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
/** edit image view rect */
@property (weak, nonatomic) IBOutlet UIView *edtiImageView;
/** 待裁剪图片 */
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) void(^UserActionBlock)(NSInteger, UIImage *);
@end

@implementation PYEditingImageView
{
    CGPoint _startPoint;
    __weak IBOutlet NSLayoutConstraint *_edtiImageConstraintWidth;
    __weak IBOutlet NSLayoutConstraint *_edtiImageConstraintAspect;
    CGFloat _aspect;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"PYEditingImageView" owner:nil options:nil][0];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:pan];
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
        [self addGestureRecognizer:pinch];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image aspect:(CGFloat)aspect width:(CGFloat)width action:(void (^)(NSInteger, UIImage *))complete {
    self = [self init];
    self.image = [image py_fixOrientation];
    _edtiImageConstraintWidth.constant = width;
    _aspect = aspect;
    self.UserActionBlock = complete;
    
    self.showImageView.image = self.image;
    self.showImageView.frame = CGRectMake(0,\
                                          0,\
                                          [UIScreen mainScreen].bounds.size.width,\
                                          [self fitHeight:[UIScreen mainScreen].bounds.size.width]);
    self.showImageView.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2);
    return self;
}

- (void)pan:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan translationInView:self];
    static CGPoint onceOrgin;
    if (pan.state == UIGestureRecognizerStateBegan) {
        onceOrgin = self.showImageView.frame.origin;
    }
    self.showImageView.frame = CGRectMake(point.x + onceOrgin.x,\
                                          point.y + onceOrgin.y,\
                                          self.showImageView.frame.size.width,\
                                          self.showImageView.frame.size.height);
    if (pan.state == UIGestureRecognizerStateEnded\
        || pan.state == UIGestureRecognizerStateCancelled\
        || pan.state ==UIGestureRecognizerStateFailed) {
        [self checkFrame];
    }
}

- (void)pinch:(UIPinchGestureRecognizer *)pinch {
    static CGRect frame;
    if (pinch.state == UIGestureRecognizerStateBegan) {
        frame = self.showImageView.frame;
    }
    self.showImageView.frame = CGRectMake(-frame.size.width * (pinch.scale - 1) / 2 + frame.origin.x,\
                                          -frame.size.height * (pinch.scale - 1) / 2 + frame.origin.y,\
                                          frame.size.width * pinch.scale,\
                                          frame.size.height * pinch.scale);
    if (pinch.state == UIGestureRecognizerStateEnded\
        || pinch.state == UIGestureRecognizerStateCancelled\
        || pinch.state ==UIGestureRecognizerStateFailed) {
        [self checkFrame];
    }
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    [self removeConstraint:_edtiImageConstraintAspect];
    [self.edtiImageView addConstraint:[NSLayoutConstraint constraintWithItem:self.edtiImageView
                                                                   attribute:NSLayoutAttributeHeight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.edtiImageView
                                                                   attribute:NSLayoutAttributeWidth
                                                                  multiplier:_aspect
                                                                    constant:0]];
    
    [super updateConstraints];
}


/**
 检查当前图片的frame是否在裁剪框内
 */
- (void)checkFrame {
    CGRect frame = self.showImageView.frame;
    CGRect frameCut = self.edtiImageView.frame;
    [UIView animateWithDuration:0.3F animations:^{
        if (frame.size.width < frameCut.size.width || frame.size.height < frameCut.size.height) {
            
            CGFloat height;
            CGFloat width;
            if ([self fitHeight:frameCut.size.width] < frameCut.size.height) {
                height = frameCut.size.height;
                width = [self fitWidth:height];
            } else {
                width = frameCut.size.width;
                height = [self fitHeight:width];
            }
            self.showImageView.frame = CGRectMake(self.edtiImageView.center.x - width / 2,\
                                                  self.edtiImageView.center.y - height / 2,\
                                                  width,\
                                                  height);
            
        } else if (frame.origin.x > frameCut.origin.x || frame.origin.y > frameCut.origin.y) {
            
            CGFloat x = frame.origin.x;
            CGFloat y = frame.origin.y;
            if (frame.origin.x > frameCut.origin.x) {
                x = frameCut.origin.x;
            } else if (CGRectGetMaxX(frame) < CGRectGetMaxX(frameCut)) {
                x += CGRectGetMaxX(frameCut) - CGRectGetMaxX(frame);
            }
            if (frame.origin.y > frameCut.origin.y) {
                y = frameCut.origin.y;
            } else if (CGRectGetMaxY(frame) < CGRectGetMaxY(frameCut)) {
                y += CGRectGetMaxY(frameCut) - CGRectGetMaxY(frame);
            }
            self.showImageView.frame = CGRectMake(x,\
                                                  y,\
                                                  frame.size.width,\
                                                  frame.size.height);
            
        } else if (CGRectGetMaxX(frame) < CGRectGetMaxX(frameCut) || CGRectGetMaxY(frame) < CGRectGetMaxY(frameCut)) {
            
            CGFloat x = frame.origin.x;
            CGFloat y = frame.origin.y;
            if (CGRectGetMaxX(frame) < CGRectGetMaxX(frameCut)) {
                x += CGRectGetMaxX(frameCut) - CGRectGetMaxX(frame);
            } else if (frame.origin.x > frameCut.origin.x) {
                x = frameCut.origin.x;
            }
            if (CGRectGetMaxY(frame) < CGRectGetMaxY(frameCut)) {
                y += CGRectGetMaxY(frameCut) - CGRectGetMaxY(frame);
            } else if (frame.origin.y > frameCut.origin.y) {
                y = frameCut.origin.y;
            }
            self.showImageView.frame = CGRectMake(x,\
                                                  y,\
                                                  frame.size.width,\
                                                  frame.size.height);
            
        }
    }];
   
}

- (CGFloat)fitHeight:(CGFloat)width {
    return width * self.image.size.height / self.image.size.width;
}

- (CGFloat)fitWidth:(CGFloat)height {
    return height * self.image.size.width / self.image.size.height;
}

- (CGRect)view:(UIView *)view inView:(UIView *)inView {
    
    // 重叠部分 在共同的父视图中的位置
    return CGRectIntersection(view.frame, inView.frame);
}
//转为在showImageView 中的位置
- (CGRect)imageRect:(CGRect)rect {
    return [self convertRect:rect toView:self.showImageView];
}
- (CGRect)imageRealIntersection:(CGRect)rect {
    CGFloat x       = rect.origin.x;
    CGFloat y       = rect.origin.y;
    CGFloat width   = rect.size.width;
    CGFloat height  = rect.size.height;
    return CGRectMake([self fitImageRealIntersection:x], [self fitImageRealIntersection:y], [self fitImageRealIntersection:width], [self fitImageRealIntersection:height]);
}

- (CGRect)finalImageRect {
    return [self imageRealIntersection:[self imageRect:[self view:self.edtiImageView inView:self.showImageView]]];
}

- (CGFloat)fitImageRealIntersection:(CGFloat)f {
    return f * self.image.size.width / self.showImageView.frame.size.width;
}

- (IBAction)cancel:(id)sender {
    if (self.UserActionBlock) {
        self.UserActionBlock(0, self.image);
    }
}

- (IBAction)sure:(id)sender {
    if (self.UserActionBlock) {
        self.UserActionBlock(1, [self.image py_getSubImage:[self finalImageRect]]);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
