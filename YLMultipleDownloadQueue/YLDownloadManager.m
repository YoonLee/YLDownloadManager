//
//  YLDownloadManager.m
//  YLMultipleDownloadQueue
//
//  Created by Yoon Lee on 4/15/15.
//  Copyright (c) 2015 Yoon Lee. All rights reserved.
//

#import "YLDownloadManager.h"
#import <AFNetworking/AFNetworking.h>

@interface YLDownloadManager()
- (AFURLSessionManager *)sessionManager;
@end

@implementation YLDownloadManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t managerToken;
    static YLDownloadManager *manager = nil;
    
    dispatch_once(&managerToken, ^{
        manager = [[YLDownloadManager alloc] init];
    });
    
    return manager;
}

- (AFURLSessionManager *)sessionManager
{
    static dispatch_once_t sessionToken;
    static AFURLSessionManager *sessionManager = nil;
    
    dispatch_once(&sessionToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    });
    
    return sessionManager;
}

- (void)setMaximumConcurrentOperation:(NSInteger)numOfMaxOperation
{
    AFURLSessionManager *sessionManager = [self sessionManager];
    NSOperationQueue *operationQueue = [sessionManager operationQueue];
    [operationQueue setMaxConcurrentOperationCount:numOfMaxOperation];
}

- (void)addDownloadTaskFrom:(NSURL *)URL
{
    // https://github.com/AFNetworking/AFNetworking
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFURLSessionManager *sessionManager = [self sessionManager];
    
    NSProgress *progress = nil;
    NSURLSessionDownloadTask *downloadTask = [sessionManager downloadTaskWithRequest:request
                                                                            progress:&progress
                                                                         destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                                                                             NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                                                                                                                   inDomain:NSUserDomainMask
                                                                                                                                          appropriateForURL:nil
                                                                                                                                                     create:NO
                                                                                                                                                      error:nil];
                                                                             
                                                                             return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
                                                                         }
                                                                   completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                                                                       CLog(@".completed at %@", filePath);
                                                                   }];
    [downloadTask resume];
    
    [progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"fractionCompleted"]) {
        NSProgress *progress = object;
        CLog(@"%@", @(progress.fractionCompleted));
    }
}

@end
