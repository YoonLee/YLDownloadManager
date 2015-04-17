//
//  YLConsoleLogTextView.h
//  YLMultipleDownloadQueue
//
//  Created by Yoon Lee on 4/16/15.
//  Copyright (c) 2015 Yoon Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLConsoleLogTextView : NSObject
+ (instancetype)sharedInstance;

- (void)attachTextView:(UITextView *)textView;
- (void)appendConsoleLog:(NSString *)consoleLogStr;
- (void)clearConsoleScreen;
@end
