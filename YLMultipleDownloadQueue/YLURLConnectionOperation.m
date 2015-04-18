//
//  YLURLConnectionOperation.m
//  YLMultipleDownloadQueue
//
//  Created by Yoon Lee on 4/16/15.
//  Copyright (c) 2015 Yoon Lee. All rights reserved.
//

#import "YLURLConnectionOperation.h"

@implementation YLURLConnectionOperation
- (void)start
{
    // override from YLOperation
    [super start];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.URL];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request
                                                                  delegate:self
                                                          startImmediately:NO];
    [connection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [connection start];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    YLog(@".operation: `%@` <error>\n", self.fileName);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.fileName = response.suggestedFilename;
    YLog(@".operation: `%@` <response received>\n", self.fileName);
}

static dispatch_once_t excuteOnceToken;

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    dispatch_once(&excuteOnceToken, ^{
        YLog(@".operation: `%@` <downloading>\n", self.fileName);
    });
    
    [self.collectingData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    YLog(@".operation: `%@` <finished>\n", self.fileName);
    NSString *targetPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSURL *targetURL = [NSURL fileURLWithPath:[targetPath stringByAppendingPathComponent:self.fileName]];
    CLog(@".downloaded at %@", targetURL.relativePath);
    [self.collectingData writeToURL:targetURL atomically:YES];
    excuteOnceToken = 0;
    [self downloadCompleted];
}

@end