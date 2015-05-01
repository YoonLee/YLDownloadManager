//
//  YLOperation.h
//  YLMultipleDownloadQueue
//
//  Created by Yoon Lee on 4/17/15.
//  Copyright (c) 2015 Yoon Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, YLOperationStatus) {
    YLOperationStatusReady = 0,
    YLOperationStatusWaiting,
    YLOperationStatusExecuting,
    YLOperationStatusCancelled,
    YLOperationStatusFinished,
};

@interface YLOperation : NSOperation
typedef void (^YLOperationBlock) (NSError *error, NSString *filePath);
@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) YLOperationBlock operationCallback;
@property (nonatomic, assign) YLOperationStatus operationStatus;

- (instancetype)initWithURL:(NSURL *)aURL;
- (void)downloadCompleted;
- (void)suspend;
- (void)resume;
- (void)cancel;
@end
