//
//  YLAFNetworkingOperation.m
//  YLMultipleDownloadQueue
//
//  Created by Yoon Lee on 4/17/15.
//  Copyright (c) 2015 Yoon Lee. All rights reserved.
//

#import "YLAFNetworkingOperation.h"
#import <AFNetworking/AFNetworking.h>

@interface YLAFNetworkingOperation()
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, assign) long long expectedLength;
@end

@implementation YLAFNetworkingOperation
@synthesize downloadTask;
@synthesize expectedLength;

- (void)start
{
    // override from YLOperation
    [super start];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLRequest *request = [NSURLRequest requestWithURL:self.URL];
    
    downloadTask = [manager downloadTaskWithRequest:request
                                           progress:nil
                                        destination:^NSURL *(NSURL *destinationURL, NSURLResponse *response) {
                                            self.fileName = response.suggestedFilename;
                                            expectedLength = response.expectedContentLength;
                                            YLog(@".operation: `%@` <response received>\n", self.fileName);
                                            NSString *targetPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
                                            NSURL *targetURL = [NSURL fileURLWithPath:[targetPath stringByAppendingPathComponent:self.fileName]];
                                            return targetURL;
                                        }
                                  completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                                      if (error == nil && expectedLength == response.expectedContentLength) {
                                          YLog(@".operation: `%@` <finished>\n", self.fileName);
                                          [self downloadCompleted];
                                      }
                                      else {
                                          CLog(@".operation: `%@` <error>\n", [error description]);
                                          NSDictionary *userInfo = [error userInfo];
                                          NSData *collectedData = [userInfo objectForKey:NSURLSessionDownloadTaskResumeData];
                                      }
                                  }];
    [self.downloadTask resume];
}

- (void)suspend
{
    [self.downloadTask suspend];
}

- (void)resume
{
    [self.downloadTask resume];
}

- (void)cancel
{
    [self.downloadTask cancel];
    [self downloadCompleted];
}

@end
