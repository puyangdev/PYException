//
//  PYImageTransitionElement.m
//  PYToolsDemo
//
//  Created by mac on 2017/10/4.
//  Copyright © 2017年 于浦洋. All rights reserved.
//

#import "PYImageTransitionElement.h"
#import "UIView+PYSubview.h"

@implementation PYImageTransitionElement
@synthesize fromView = _fromView;

- (instancetype)initWithController:(UIViewController *)controller isPop:(BOOL)isPop {
    self = [super init];
    if (self) {
        _controller = controller;
        _isPop = isPop;
    }
    return self;
}

- (void)update {
    if (self.updateAction) {
        self.updateAction(self);
    }
}

- (void)beginFromTransition {
    if (self.beginFromTransitionAction) {
        self.beginFromTransitionAction(self);
    }
}

- (void)beginToTransition {
    if (self.beginToTransitionAction) {
        self.beginToTransitionAction(self);
    }
}

- (void)endFromTransition {
    if (self.isPop) {
        self.fromView = nil;
        self.image = nil;
    }
    
    if (self.endFromTransitionAction) {
        self.endFromTransitionAction(self);
    }
}

- (void)endToTransition {
    if (!self.isPop) {
        if (!self.controller.pyPopElement.image) {
            if ([self getFromImage]) {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.targetFrame];
                imageView.image = [self getFromImage];
                
                UIView *view = self.toView;
                if (!view) {
                    view = self.controller.view;
                    for (UIView *subview in [view.subviews copy]) {
                        if ([subview isKindOfClass:[UIScrollView class]]) {
                            view = subview;
                            break;
                        }
                    }
                }
                [view addSubview:imageView];
                
                self.controller.pyPopElement.bePushedPreloadingImageView = imageView;
            }
        }
    }
    
    if (self.isPop) {
        self.controller.pyPushElement.fromView = nil;
        self.controller.pyPushElement.image = nil;
    }
    
    if (self.endToTransitionAction) {
        self.endToTransitionAction(self);
    }
}

- (void)setFromView:(UIView *)fromView {
    _fromView = fromView;
    
    if (!fromView) {
        self.fromViewPlaceholderView = nil;
    }
    
    if (!self.isPop && _fromView) {
        // push时添加占位视图，用于POP定位
        self.fromViewPlaceholderView = [[UIView alloc] initWithFrame:_fromView.bounds];
        self.fromViewPlaceholderView.userInteractionEnabled = NO;
        UIView *superView = [_fromView superview];
        UIScrollView *superScrollView = nil;
        do {
            if ([superView isKindOfClass:[UIScrollView class]]) {
                superScrollView = (UIScrollView *) superView;
                break;
            }
            superView = [superView superview];
        } while (superView);
        
        if (superScrollView) {
            [superScrollView addSubview:self.fromViewPlaceholderView];
            CGRect frame = [_fromView convertRect:_fromView.bounds toView:superScrollView];
            self.fromViewPlaceholderView.frame = frame;
        }
        else {
            [fromView addSubview:self.fromViewPlaceholderView];
            self.fromViewPlaceholderView.frame = fromView.bounds;
        }
    }
    
    if (self.isPop && _fromView) {
        if (!self.image) {
            [self.bePushedPreloadingImageView removeFromSuperview];
            [_fromView py_addSubviewSpreadAutoLayout:self.bePushedPreloadingImageView];
        }
    }
}

- (UIView *)fromView {
    if (!self.isPop) {
        CGRect fromViewFrame = [_fromView convertRect:_fromView.bounds toView:self.controller.view];
        CGRect fromViewPlaceholderViewFrame = [self.fromViewPlaceholderView convertRect:self.fromViewPlaceholderView.bounds toView:self.controller.view];
        
        // fromView的frame与预期不同，可能在CELL中因重用变更了位置
        if (!CGRectEqualToRect(fromViewFrame, fromViewPlaceholderViewFrame)) {
            // 系统可能有微小偏差
            if (fabs(CGRectGetMinX(fromViewFrame) - CGRectGetMinX(fromViewPlaceholderViewFrame)) > 2.0f ||
                fabs(CGRectGetMinY(fromViewFrame) - CGRectGetMinY(fromViewPlaceholderViewFrame)) > 2.0f) {
                _fromView = nil;
                self.fromViewPlaceholderView = nil;
            }
        }
    }
    
    return _fromView;
}

- (void)setFromViewPlaceholderView:(UIView *)fromViewPlaceholderView {
    if (_fromViewPlaceholderView != fromViewPlaceholderView) {
        [_fromViewPlaceholderView removeFromSuperview];
    }
    
    _fromViewPlaceholderView = fromViewPlaceholderView;
}

- (void)setToView:(UIView *)toView {
    _toView = toView;
    if (!self.isPop &&
        toView &&
        self.controller.pyPopElement.bePushedPreloadingImageView.superview) {
        [self.controller.pyPopElement.bePushedPreloadingImageView removeFromSuperview];
        [toView addSubview:self.controller.pyPopElement.bePushedPreloadingImageView];
    }
}

- (void)setImage:(UIImage *)image {
    _image = image;
    
    if (self.isPop && _image) {
        [self.bePushedPreloadingImageView removeFromSuperview];
    }
}

- (UIImage *)getFromImage {
    if (self.isPop) {
        return self.fromController.pyPopElement.image;
    }
    else {
        return self.fromController.pyPushElement.image;
    }
}

@end

@implementation UIViewController (PYImageTransition)

@dynamic pyPushElement;
@dynamic pyPopElement;

- (PYImageTransitionElement *)pyPushElement {
    
    PYImageTransitionElement *element = objc_getAssociatedObject(self, @selector(pyPushElement));
    
    if (!element) {
        element = [[PYImageTransitionElement alloc] initWithController:self isPop:NO];
        objc_setAssociatedObject(self, @selector(pyPushElement), element, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return element;
}

- (PYImageTransitionElement *)pyPopElement {
    
    PYImageTransitionElement *element = objc_getAssociatedObject(self, @selector(pyPopElement));
    if (!element) {
        element = [[PYImageTransitionElement alloc] initWithController:self isPop:YES];
        objc_setAssociatedObject(self, @selector(pyPopElement), element, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return element;
}
@end
