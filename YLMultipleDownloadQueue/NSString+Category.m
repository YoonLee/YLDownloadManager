//
//  NSString+Category.m
//  BlackCloset
//
//  Created by Yoon Lee on 12/15/14.
//  Copyright (c) 2014 Yoon Lee. All rights reserved.
//

#import "NSString+Category.h"

@implementation NSString (Category)

+ (BOOL)isEmptyStr:(NSString *)string
{
     // if string is NULL object then return true
    if ([string isEqual:[NSNull null]]) {
        return YES;
    }
    
    // if string is nil then return true
    if (string == nil) {
        return YES;
    }
    
    // if string length is 0 then return true
    if (string.length == 0) {
        return YES;
    }
    
    // if string contains the white space then return true
    if ([string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isEmptyStr
{
    return [NSString isEmptyStr:self];
}

+ (NSString *)validateNonEmptyString:(NSString *)string
{
    NSString *resultString;
    
    if ([NSString isEmptyStr:string])
        resultString = @"";
    else
        resultString = string;
    
    return resultString;
}

- (NSString *)validateNonEmptyString
{
    return [NSString validateNonEmptyString:self];
}

@end
