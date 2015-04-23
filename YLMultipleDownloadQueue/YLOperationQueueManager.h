//
//  YLOperationQueueManager.h
//  YLMultipleDownloadQueue
//
//  Created by Yoon Lee on 4/23/15.
//  Copyright (c) 2015 Yoon Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YLOperation.h"

@interface YLOperationQueueManager : NSObject
+ (instancetype)sharedInstance;
@property (nonatomic, strong) NSOperationQueue *operationQueue;

- (void)pauseOperations;
- (void)continueOperations;
- (void)cancelAllOperations;

- (void)setNumOfMaximumConcurrent:(NSInteger)max;
- (NSInteger)numOfOperations;

- (void)enqueueOperation:(YLOperation *)operation;
- (void)enqueueOperations:(NSArray *)operations;
@end
