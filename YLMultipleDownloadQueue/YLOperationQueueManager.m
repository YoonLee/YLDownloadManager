//
//  YLOperationQueueManager.m
//  YLMultipleDownloadQueue
//
//  Created by Yoon Lee on 4/23/15.
//  Copyright (c) 2015 Yoon Lee. All rights reserved.
//

#import "YLOperationQueueManager.h"

@implementation YLOperationQueueManager
@synthesize operationQueue;

+ (instancetype)sharedInstance
{
    static dispatch_once_t queueToken;
    static YLOperationQueueManager *shared = nil;
    
    dispatch_once(&queueToken, ^{
        shared = [[YLOperationQueueManager alloc] init];
        [shared setOperationQueue:[[NSOperationQueue alloc] init]];
    });
    
    return shared;
}

- (void)setNumOfMaximumConcurrent:(NSInteger)max
{
    [self.operationQueue setMaxConcurrentOperationCount:max];
}

- (NSInteger)numOfOperations
{
    return self.operationQueue.operationCount;
}

- (void)enqueueOperation:(YLOperation *)operation
{
    [self.operationQueue addOperation:operation];
}

- (void)enqueueOperations:(NSArray *)operations
{
    [self.operationQueue addOperations:operations waitUntilFinished:NO];
}

- (void)pauseOperations
{
    [self.operationQueue.operations enumerateObjectsUsingBlock:^(YLOperation *operation, NSUInteger idx, BOOL *stop) {
        [operation suspend];
    }];
    
    [self.operationQueue setSuspended:YES];
}

- (void)continueOperations
{
    [self.operationQueue.operations enumerateObjectsUsingBlock:^(YLOperation *operation, NSUInteger idx, BOOL *stop) {
        [operation resume];
    }];
    
    [self.operationQueue setSuspended:NO];
}

- (void)cancelAllOperations
{
    [self.operationQueue.operations enumerateObjectsUsingBlock:^(YLOperation *operation, NSUInteger idx, BOOL *stop) {
        [operation suspend];
    }];
}

@end
