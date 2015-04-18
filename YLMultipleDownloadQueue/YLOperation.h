//
//  YLOperation.h
//  YLMultipleDownloadQueue
//
//  Created by Yoon Lee on 4/17/15.
//  Copyright (c) 2015 Yoon Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLOperation : NSOperation
@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, strong) NSMutableData *collectingData;

- (instancetype)initWithURL:(NSURL *)aURL;
- (void)downloadCompleted;
@end
