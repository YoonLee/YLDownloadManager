//
//  RootViewController.m
//  YLMultipleDownloadQueue
//
//  Created by Yoon Lee on 4/15/15.
//  Copyright (c) 2015 Yoon Lee. All rights reserved.
//

#import "RootViewController.h"
#import "YLDownloadManager.h"
#import "YLWebService.h"
#import "UIBarButtonItem+Category.h"

@implementation RootViewController
@synthesize contents;
@synthesize optQueue;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    optQueue = [[NSOperationQueue alloc] init];
    [optQueue setMaxConcurrentOperationCount:2];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"DownloadList" ofType:@"plist"];
    contents = [[NSArray alloc] initWithContentsOfFile:filePath];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setRowHeight:55.f];
    [tableView setTableFooterView:[UIView new]];
    [self.view addSubview:tableView];
    
    [[YLDownloadManager sharedInstance] setMaximumConcurrentOperation:1];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"ALL"
                                                                       style:UIBarButtonItemStyleDone
                                                                 actionBlock:^(UIBarButtonItem *rightBarButton) {
                                                                     // loop test
                                                                     [self.contents enumerateObjectsUsingBlock:^(NSDictionary *info, NSUInteger idx, BOOL *stop) {
                                                                         NSString *URLStr = [info objectForKey:@"URI"];
                                                                         NSURL *URL = [NSURL URLWithString:URLStr];
                                                                         [[YLDownloadManager sharedInstance] addDownloadTaskFrom:URL];
                                                                     }];
                                                                 }];
    [self.navigationItem setRightBarButtonItem:rightBarButton];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"WS"
                                                                      style:UIBarButtonItemStyleDone
                                                                actionBlock:^(UIBarButtonItem *leftBarButton) {
                                                                    CLog(@".calling custom webservices");
                                                                    NSArray *identity = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H"];
                                                                    // 5 operations enqueue and we are limiting only one at a time
                                                                    for (int i = 0; i < self.contents.count; i ++) {
                                                                        NSDictionary *info = [self.contents objectAtIndex:i];
                                                                        NSString *URLStr = [info objectForKey:@"URI"];
                                                                        // allocate instance
                                                                        YLWebService *operation = [[YLWebService alloc] initWithURL:[NSURL URLWithString:URLStr] identity:identity[i]];
                                                                        // enqueue
                                                                        [self.optQueue addOperation:operation];
                                                                    }
                                                                }];
    [self.navigationItem setLeftBarButtonItem:leftBarButton];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contents.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *info = [self.contents objectAtIndex:indexPath.row];
    NSString *URLStr = [info objectForKey:@"URI"];
    [cell.textLabel setText:URLStr];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *YLDownloadTableViewCellIdentifier = @"YLDownloadTableViewCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:YLDownloadTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:YLDownloadTableViewCellIdentifier];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *info = [self.contents objectAtIndex:indexPath.row];
    NSString *URLStr = [info objectForKey:@"URI"];
    NSURL *URL = [NSURL URLWithString:URLStr];
    [[YLDownloadManager sharedInstance] addDownloadTaskFrom:URL];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
