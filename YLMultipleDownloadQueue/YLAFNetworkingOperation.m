//
//  YLAFNetworkingOperation.m
//  YLMultipleDownloadQueue
//
//  Created by Yoon Lee on 4/17/15.
//  Copyright (c) 2015 Yoon Lee. All rights reserved.
//

#import "YLAFNetworkingOperation.h"
#import <AFNetworking/AFNetworking.h>

@implementation YLAFNetworkingOperation

- (void)start
{
    // override from YLOperation
    [super start];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLRequest *request = [NSURLRequest requestWithURL:self.URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request
                                                                     progress:nil
                                                                  destination:^NSURL *(NSURL *destinationURL, NSURLResponse *response) {
                                                                      self.fileName = response.suggestedFilename;
                                                                      YLog(@".operation: `%@` <response received>\n", self.fileName);
                                                                      NSString *targetPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
                                                                      NSURL *targetURL = [NSURL fileURLWithPath:[targetPath stringByAppendingPathComponent:self.fileName]];
                                                                      return targetURL;
                                                                  }
                                                            completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                                                                YLog(@".operation: `%@` <finished>\n", self.fileName);
                                                                [super downloadCompleted];
                                                            }];
    [downloadTask resume];
}

@end
