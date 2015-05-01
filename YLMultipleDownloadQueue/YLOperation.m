//
//  YLOperation.m
//  YLMultipleDownloadQueue
//
//  Created by Yoon Lee on 4/17/15.
//  Copyright (c) 2015 Yoon Lee. All rights reserved.
//

#import "YLOperation.h"

@interface YLOperation()

@end

@implementation YLOperation
@synthesize URL;
@synthesize fileName;
@synthesize operationCallback;
@synthesize operationStatus;

- (instancetype)initWithURL:(NSURL *)aURL
{
    if (self = [super init]) {
        URL = aURL;
    }
    
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        // operation starts waiting status
        self.operationStatus = YLOperationStatusWaiting;
    }
    
    return self;
}

- (void)downloadCompleted
{
    
}

#pragma marks - NSOperation Overrides
// do override this start method
- (void)start
{
    self.operationStatus = YLOperationStatusExecuting;
}

- (BOOL)isReady
{
    return self.operationStatus == YLOperationStatusReady;
}

- (BOOL)isExecuting
{
    return self.operationStatus == YLOperationStatusExecuting;
}

- (BOOL)isCancelled
{
    return self.operationStatus == YLOperationStatusCancelled;
}

- (BOOL)isFinished
{
    return self.operationStatus == YLOperationStatusFinished;
}

- (void)suspend {}
- (void)resume  {}

- (void)cancel
{
    @synchronized (self) {
        [super cancel];
    }
}

- (BOOL)isConcurrent
{
    return YES;
}

@end
