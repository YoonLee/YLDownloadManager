//
//  YLOperationQueueManager.m
//  YLMultipleDownloadQueue
//
//  Created by Yoon Lee on 4/23/15.
//  Copyright (c) 2015 Yoon Lee. All rights reserved.
//

#import "YLOperationQueueManager.h"

@interface YLOperationQueueManager()
@property (nonatomic, strong, readwrite) NSRecursiveLock *lock;
@end

@implementation YLOperationQueueManager
@synthesize operationQueue;

+ (instancetype)sharedInstance
{
    static dispatch_once_t queueToken;
    static YLOperationQueueManager *shared = nil;
    
    dispatch_once(&queueToken, ^{
        shared = [[YLOperationQueueManager alloc] init];
        [shared setOperationQueue:[[NSOperationQueue alloc] init]];
        [shared setLock:[[NSRecursiveLock alloc] init]];
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
    [self.lock lock];
    [self.operationQueue addOperation:operation];
    
    // dequeue
    [operation setCompletionBlock:^{
        CLog(@".dequeue");
    }];
     
    [self.lock unlock];
}

- (void)enqueueOperations:(NSArray *)operations
{
    [self.lock lock];
    [self.operationQueue setSuspended:NO];
    [self.operationQueue addOperations:operations waitUntilFinished:NO];
    [self.lock unlock];
}

- (void)pauseOperations
{
    [self.lock lock];
    [self.operationQueue.operations enumerateObjectsUsingBlock:^(YLOperation *operation, NSUInteger idx, BOOL *stop) {
        [operation suspend];
    }];
    
    [self.operationQueue setSuspended:YES];
    [self.lock unlock];
}

- (void)continueOperations
{
    [self.lock lock];
    [self.operationQueue.operations enumerateObjectsUsingBlock:^(YLOperation *operation, NSUInteger idx, BOOL *stop) {
        [operation resume];
    }];
    
    [self.operationQueue setSuspended:NO];
    [self.lock unlock];
}

- (void)cancelAllOperations
{
    [self.lock lock];
    [self.operationQueue cancelAllOperations];
    [self.lock unlock];
}

@end
