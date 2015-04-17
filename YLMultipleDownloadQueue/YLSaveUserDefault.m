//
//  YLSaveUserDefault.m
//  YLMultipleDownloadQueue
//
//  Created by Yoon Lee on 4/17/15.
//  Copyright (c) 2015 Yoon Lee. All rights reserved.
//

#import "YLSaveUserDefault.h"
#import "NSString+Category.h"
@implementation YLSaveUserDefault

+ (instancetype)sharedInstance
{
    static dispatch_once_t token;
    static YLSaveUserDefault *sharedInstance = nil;
    
    dispatch_once(&token, ^{
        sharedInstance = [[YLSaveUserDefault alloc] init];
    });
    
    return sharedInstance;
}

- (void)setDefaultMethod:(NSNumber *)methodNum
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:methodNum forKey:DEFAULT_METHOD];
}

- (NSNumber *)getDefaultMethod
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *methodNum = [userDefaults objectForKey:DEFAULT_METHOD];
    
    return methodNum;
}

- (void)setDefaultConCurNum:(NSNumber *)concurNum
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:concurNum forKey:DEFAULT_CONCUR];
}

- (NSNumber *)getDefaultConCurNum
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *concurNum = [userDefaults objectForKey:DEFAULT_CONCUR];
    
    return concurNum;
}

@end
