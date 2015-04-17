//
//  NSString+Category.h
//  BlackCloset
//
//  Created by Yoon Lee on 12/15/14.
//  Copyright (c) 2014 Yoon Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Category)
+ (BOOL)isEmptyStr:(NSString *)string;

// reason for declarare as class method
// if string is nil then the object no longer count as string object
+ (NSString *)validateNonEmptyString:(NSString *)string;
@end
