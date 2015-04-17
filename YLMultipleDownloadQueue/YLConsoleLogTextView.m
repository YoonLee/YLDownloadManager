//
//  YLConsoleLogTextView.m
//  YLMultipleDownloadQueue
//
//  Created by Yoon Lee on 4/16/15.
//  Copyright (c) 2015 Yoon Lee. All rights reserved.
//

#import "YLConsoleLogTextView.h"

@interface YLConsoleLogTextView()
@property (nonatomic) NSMutableString *entireConsoleLog;
@property (nonatomic, strong) UITextView *consoleTextView;
@end

@implementation YLConsoleLogTextView

+ (instancetype)sharedInstance
{
    static dispatch_once_t token;
    static YLConsoleLogTextView *consoleLogManager = nil;
    
    dispatch_once(&token, ^{
        consoleLogManager = [[YLConsoleLogTextView alloc] init];
        consoleLogManager.entireConsoleLog = [[NSMutableString alloc] init];
    });
    
    return consoleLogManager;
}

- (void)attachTextView:(UITextView *)textView
{
    self.consoleTextView = textView;
    [self.consoleTextView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
}

- (void)appendConsoleLog:(NSString *)consoleLogStr
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.entireConsoleLog appendString:consoleLogStr];
        [self.consoleTextView setText:self.entireConsoleLog];
        [self.consoleTextView scrollRangeToVisible:NSMakeRange(self.consoleTextView.text.length, 0)];
    });
}

- (void)clearConsoleScreen
{
    [self.entireConsoleLog setString:@""];
    [self.consoleTextView setText:@".cleared"];
}

@end
