//
//  YLURLConnectionOperation.h
//  YLMultipleDownloadQueue
//
//  Created by Yoon Lee on 4/16/15.
//  Copyright (c) 2015 Yoon Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YLOperation.h"

@class YLOperation;
@interface YLURLConnectionOperation : YLOperation <NSURLConnectionDataDelegate>
@end
