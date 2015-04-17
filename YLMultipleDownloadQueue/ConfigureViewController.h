//
//  ConfigureViewController.h
//  YLMultipleDownloadQueue
//
//  Created by Yoon Lee on 4/17/15.
//  Copyright (c) 2015 Yoon Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_OPTIONS(NSInteger, DEFAULT_LOAD_OPTIONS) {
    METHODS = 0,
    NUM_OF_MAX_CONCURRENT,
};

@interface ConfigureViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
typedef void (^ConfigurationBlock) (void);
@property (nonatomic, copy) ConfigurationBlock changeCallback;
@end
