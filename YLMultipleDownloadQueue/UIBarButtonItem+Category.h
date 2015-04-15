//
//  UIBarButtonItem+Category.h
//  BlackCloset
//
//  Created by Yoon Lee on 3/3/15.
//  Copyright (c) 2015 Yoon Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+Category.h"

@interface UIBarButtonItem (Category)

// default image initialization with action block
- (instancetype)initWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style actionBlock:(void (^)(id))action;

// default title initialization with action block
- (instancetype)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style actionBlock:(void (^)(id))action;

// default system button initialization with action block
- (instancetype)initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem actionBlock:(void (^)(id))action;

@end
