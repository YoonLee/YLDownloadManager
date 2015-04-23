//
//  YLOperation.h
//  YLMultipleDownloadQueue
//
//  Created by Yoon Lee on 4/17/15.
//  Copyright (c) 2015 Yoon Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLOperation : NSOperation
typedef void (^YLOperationBlock) (NSError *error, NSString *filePath);
@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) YLOperationBlock operationCallback;
- (instancetype)initWithURL:(NSURL *)aURL;
- (void)downloadCompleted;
- (void)suspend;
- (void)resume;
- (void)cancel;
@end
