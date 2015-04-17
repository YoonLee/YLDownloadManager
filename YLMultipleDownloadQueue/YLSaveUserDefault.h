//
//  YLSaveUserDefault.h
//  YLMultipleDownloadQueue
//
//  Created by Yoon Lee on 4/17/15.
//  Copyright (c) 2015 Yoon Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#define DEFAULT_METHOD      @"DEFAULT_METHOD"
#define DEFAULT_CONCUR      @"DEFAULT_CONCUR"

@interface YLSaveUserDefault : NSObject
+ (instancetype)sharedInstance;

- (void)setDefaultMethod:(NSNumber *)methodStr;
- (NSNumber *)getDefaultMethod;
- (void)setDefaultConCurNum:(NSNumber *)concurNum;
- (NSNumber *)getDefaultConCurNum;
@end
