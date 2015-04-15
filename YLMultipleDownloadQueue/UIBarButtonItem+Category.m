//
//  UIBarButtonItem+Category.m
//  BlackCloset
//
//  Created by Yoon Lee on 3/3/15.
//  Copyright (c) 2015 Yoon Lee. All rights reserved.
//

#import "UIBarButtonItem+Category.h"
#import <objc/runtime.h>

static char BBBarButtonItemActionBlockKey;

@implementation UIBarButtonItem (Category)

- (instancetype)initWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style actionBlock:(void (^)(id))action
{
    if (self = [self initWithImage:image
                             style:style
                            target:nil
                            action:@selector(BBActionSelectorBlockWithSender:)]) {
        // it is block associating object. therefore, it should use `copy`
        objc_setAssociatedObject(self, &BBBarButtonItemActionBlockKey, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
        [self setTarget:objc_getAssociatedObject(self, &BBBarButtonItemActionBlockKey)];
    }
    
    return self;
}

- (instancetype)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style actionBlock:(void (^)(id))action
{
    if (self = [self initWithTitle:title style:style target:nil action:@selector(BBActionSelectorBlockWithSender:)]) {
        // it is block associating object. therefore, it should use `copy`
        objc_setAssociatedObject(self, &BBBarButtonItemActionBlockKey, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
        [self setTarget:objc_getAssociatedObject(self, &BBBarButtonItemActionBlockKey)];
    }
    
    return self;
}

- (instancetype)initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem actionBlock:(void (^)(id))action
{
    if (self = [self initWithBarButtonSystemItem:systemItem target:nil action:@selector(BBActionSelectorBlockWithSender:)]) {
        // it is block associating object. therefore, it should use `copy`
        objc_setAssociatedObject(self, &BBBarButtonItemActionBlockKey, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
        [self setTarget:objc_getAssociatedObject(self, &BBBarButtonItemActionBlockKey)];
    }
    
    return self;
}

@end
