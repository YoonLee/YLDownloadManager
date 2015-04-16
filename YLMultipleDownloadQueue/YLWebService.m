//
//  YLWebService.m
//  YLMultipleDownloadQueue
//
//  Created by Yoon Lee on 4/16/15.
//  Copyright (c) 2015 Yoon Lee. All rights reserved.
//

#import "YLWebService.h"

@interface YLWebService()
@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, copy) NSString *identityStr;
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

- (instancetype)initWithURL:(NSURL *)qURL identity:(NSString *)qIdentityStr
{
    if (self = [super init]) {
        URL = qURL;
        self.identityStr = qIdentityStr;
    }
    
    return self;
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
}

@end