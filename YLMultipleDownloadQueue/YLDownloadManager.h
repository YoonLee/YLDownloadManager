//
//  YLDownloadManager.h
//  YLMultipleDownloadQueue
//
//  Created by Yoon Lee on 4/15/15.
//  Copyright (c) 2015 Yoon Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLDownloadManager : NSObject

+ (instancetype)sharedInstance;

- (void)setMaximumConcurrentOperation:(NSInteger)numOfMaxOperation;
- (void)addDownloadTaskFrom:(NSURL *)URL;

@end
