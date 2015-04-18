//
//  YLOperation.m
//  YLMultipleDownloadQueue
//
//  Created by Yoon Lee on 4/17/15.
//  Copyright (c) 2015 Yoon Lee. All rights reserved.
//

#import "YLOperation.h"

@interface YLOperation()
{
    // ivars
@private
    BOOL _isFinished;
    BOOL _isExecuting;
}

@end

@implementation YLOperation
@synthesize URL;
@synthesize fileName;
@synthesize collectingData;

- (instancetype)initWithURL:(NSURL *)aURL
{
    if (self = [super init]) {
        URL = aURL;
    }
    
    return self;
}

- (void)downloadCompleted
{
    [self setExecuting:NO];
    [self setFinished:YES];
}

#pragma marks - NSOperation Overrides
// do override this start method
- (void)start
{
    if( [self isFinished] || [self isCancelled] ) { [self downloadCompleted]; return; }
    [self setExecuting:YES];
    
    collectingData = [[NSMutableData alloc] init];
}

- (BOOL)isFinished
{
    return _isFinished;
}

- (void)setFinished:(BOOL)finished
{
    // usage of key and willChangeValueForKey used for KVC & KVO
    static NSString *kFinished = @"isFinished";
    
    [self willChangeValueForKey:kFinished];
    _isFinished = finished;
    [self didChangeValueForKey:kFinished];
}

- (BOOL)isExecuting
{
    return _isExecuting;
}

- (void)setExecuting:(BOOL)executing
{
    // usage of key and willChangeValueForKey used for KVC & KVO
    static NSString *kExecuting = @"isExecuting";
    
    [self willChangeValueForKey:kExecuting];
    _isExecuting = executing;
    [self didChangeValueForKey:kExecuting];
}

- (BOOL)isConcurrent
{
    return YES;
}

@end
