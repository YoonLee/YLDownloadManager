//
//  RootViewController.h
//  YLMultipleDownloadQueue
//
//  Created by Yoon Lee on 4/15/15.
//  Copyright (c) 2015 Yoon Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *contents;
    
    NSOperationQueue *optQueue;
}

@property (nonatomic, strong) NSArray *contents;
@property (nonatomic, strong) NSOperationQueue *optQueue;

@end
