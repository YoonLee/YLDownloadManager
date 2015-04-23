//
//  YLURLSessionOperation.m
//  YLMultipleDownloadQueue
//
//  Created by Yoon Lee on 4/17/15.
//  Copyright (c) 2015 Yoon Lee. All rights reserved.
//

#import "YLURLSessionOperation.h"

@interface YLURLSessionOperation()
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, assign) long long expectedLength;
@end

@implementation YLURLSessionOperation
@synthesize downloadTask;
@synthesize expectedLength;

- (void)start
{
    // override from YLOperation
    [super start];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLRequest *request = [NSURLRequest requestWithURL:self.URL];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration
                                                          delegate:self
                                                     delegateQueue:nil];
    
    downloadTask = [session downloadTaskWithRequest:request
                                  completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                      self.fileName = response.suggestedFilename;
                                      YLog(@".operation: `%@` <finished>\n", self.fileName);
                                      if (error == nil && expectedLength == response.expectedContentLength) {
                                          if (self.operationCallback) { self.operationCallback(error, location.absoluteString); };
                                          NSString *targetPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
                                          NSURL *targetURL = [NSURL fileURLWithPath:[targetPath stringByAppendingPathComponent:self.fileName]];
                                          [[NSFileManager defaultManager] moveItemAtURL:location toURL:targetURL error:NULL];
                                          
                                          [self downloadCompleted];
                                      }
                                      else {
                                          // could be file not found, time out, and connection lost
                                          CLog(@".operation: `%@` <error>\n", [error description]);
                                          NSDictionary *userInfo = [error userInfo];
                                          NSData *collectedData = [userInfo objectForKey:NSURLSessionDownloadTaskResumeData];
                                      }
                                  }];
    [self.downloadTask resume];
}

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error
{
    if (self.operationCallback) { self.operationCallback(error, nil); };
}

- (void)suspend
{
    [self.downloadTask suspend];
}

- (void)resume
{
    [self.downloadTask resume];
}

@end
