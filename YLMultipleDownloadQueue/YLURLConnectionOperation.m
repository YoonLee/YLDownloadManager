//
//  YLURLConnectionOperation.m
//  YLMultipleDownloadQueue
//
//  Created by Yoon Lee on 4/16/15.
//  Copyright (c) 2015 Yoon Lee. All rights reserved.
//

#import "YLURLConnectionOperation.h"

@interface YLURLConnectionOperation()
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, assign) long long expectedContentLength;
@property (nonatomic, strong) NSMutableData *downloadData;
@end

@implementation YLURLConnectionOperation
@synthesize connection;
@synthesize expectedContentLength;
@synthesize downloadData;

- (void)start
{
    // override from YLOperation
    [super start];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.URL];
    connection = [[NSURLConnection alloc] initWithRequest:request
                                                 delegate:self
                                         startImmediately:NO];
    [self.connection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [self.connection start];
    
    downloadData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    YLog(@".operation: `%@` <error>\n", error);
    if (self.operationCallback) { self.operationCallback(error, nil); };
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.fileName = response.suggestedFilename;
    self.expectedContentLength = response.expectedContentLength;
    YLog(@".operation: `%@` <response received>\n", self.fileName);
}

static dispatch_once_t excuteOnceToken;

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    dispatch_once(&excuteOnceToken, ^{
        YLog(@".operation: `%@` <downloading>\n", self.fileName);
    });
    
    [self.downloadData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    YLog(@".operation: `%@` <finished>\n", self.fileName);
    
    if (self.expectedContentLength != self.downloadData.length) {
        NSLog(@".incompleted");
    }
    
    NSString *targetPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSURL *targetURL = [NSURL fileURLWithPath:[targetPath stringByAppendingPathComponent:self.fileName]];
    [self.downloadData writeToURL:targetURL atomically:YES];
    if (self.operationCallback) { self.operationCallback(nil, targetURL.absoluteString); };
    excuteOnceToken = 0;
    [self performSelector:@selector(downloadCompleted)
                 onThread:[NSThread mainThread]
               withObject:nil
            waitUntilDone:NO];
}

- (void)suspend
{
    [self.connection cancel];
}

- (void)resume
{
    // <BRB>
    // should have use `Range` from HTML header, but will do later
    self.connection = nil;
}

@end