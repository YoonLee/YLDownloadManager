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
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, strong) NSMutableData *collectingData;

- (void)downloadCompleted;

@end

@implementation YLWebService
@synthesize URL;
@synthesize collectingData;
@synthesize fileName;

- (instancetype)initWithURL:(NSURL *)qURL
{
    if (self = [super init]) {
        URL = qURL;
    }
    
    return self;
}

- (void)start
{
    if( [self isFinished] || [self isCancelled] ) { [self downloadCompleted]; return; }
    [self setExecuting:YES];
    
    collectingData = [[NSMutableData alloc] init];
    NSURLRequest *request = [NSURLRequest requestWithURL:self.URL];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request
                                                                  delegate:self
                                                          startImmediately:NO];
    [connection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [connection start];
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

- (BOOL)isConcurrent
{
    return YES;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    YLog(@".operation: `%@` <error>\n", self.fileName);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    fileName = response.suggestedFilename;
    YLog(@".operation: `%@` <response received>\n", self.fileName);
}

static dispatch_once_t excuteOnceToken;

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    dispatch_once(&excuteOnceToken, ^{
        YLog(@".operation: `%@` <downloading>\n", self.fileName);
    });
    
    [collectingData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    YLog(@".operation: `%@` <finished>\n", self.fileName);
    NSString *targetPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSURL *targetURL = [NSURL fileURLWithPath:[targetPath stringByAppendingPathComponent:fileName]];
    CLog(@".downloaded at %@", targetURL.relativePath);
    [collectingData writeToURL:targetURL atomically:YES];
    excuteOnceToken = 0;
    [self downloadCompleted];
}

@end