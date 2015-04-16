//
//  YLWebService.m
//  YLMultipleDownloadQueue
//
//  Created by Yoon Lee on 4/16/15.
//  Copyright (c) 2015 Yoon Lee. All rights reserved.
//

#import "YLWebService.h"

@interface YLWebService()
{
    // ivars
    @private
    BOOL _isFinished;
    BOOL _isExecuting;
}

@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, copy) NSString *identityStr;

- (void)downloadCompleted;

@end

@implementation YLWebService
@synthesize URL;
@synthesize identityStr;

- (void)main
{
    DLog(@".name: %@", self.identityStr);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.URL];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request
                                                                  delegate:self
                                                          startImmediately:NO];
    [connection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [connection start];
}

- (void)start
{
    if( [self isFinished] || [self isCancelled] ) { [self downloadCompleted]; return; }
    [self setExecuting:YES];
    
    [self main];
}

#pragma marks - NSOperation Overrides
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

- (void)downloadCompleted
{
    [self setExecuting:NO];
    [self setFinished:YES];
}

- (instancetype)initWithURL:(NSURL *)qURL identity:(NSString *)qIdentityStr
{
    if (self = [super init]) {
        URL = qURL;
        self.identityStr = qIdentityStr;
    }
    
    return self;
}

- (BOOL)isConcurrent
{
    return YES;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    DLog(@"name: %@", self.identityStr);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    DLog(@"name: %@", self.identityStr);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    DLog(@"name: %@", self.identityStr);
}

- (void)connectionDidFinishDownloading:(NSURLConnection *)connection destinationURL:(NSURL *) destinationURL
{
    DLog(@"name: %@", self.identityStr);
    [self downloadCompleted];
}

@end