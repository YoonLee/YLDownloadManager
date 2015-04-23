//
//  RootViewController.h
//  YLMultipleDownloadQueue
//
//  Created by Yoon Lee on 4/15/15.
//  Copyright (c) 2015 Yoon Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, METHODS_KINDS) {
    URLConnection = 0,
    URLSession,
    AFNetworking_2,
};

typedef NS_ENUM(NSInteger, SECTIONS) {
    CONSOLE = 0,
    INFO,
    TASK_OPERATION,
    DISPLAY,
};

@interface RootViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *contents;
}

@property (nonatomic, strong) NSArray *contents;
@property (nonatomic, strong) NSArray *fileURIs;
@property (nonatomic, strong) NSArray *typeOfOperations;

- (NSString *)defaultMethodTranslation:(NSNumber *)selectedMethod;
- (BOOL)isPaused:(NSString *)cellStr;
@end
