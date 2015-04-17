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
#import <FontAwesomeKit/FontAwesomeKit.h>
#define HEADER_PANEL_HEIGHT             220.f
#define MAX_CONCURRENT_RUNNING_QUEUE    5

@implementation RootViewController
@synthesize contents;
@synthesize optQueue;

clock_t start;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    [self setTitle:@"Queue"];
    
    optQueue = [[NSOperationQueue alloc] init];
    [optQueue setMaxConcurrentOperationCount:1];
    // KVO
    [optQueue addObserver:self
               forKeyPath:@"operations"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"DownloadList" ofType:@"plist"];
    contents = [[NSArray alloc] initWithContentsOfFile:filePath];
    
    CGRect headerFrame = self.view.bounds;
    headerFrame.size.height = HEADER_PANEL_HEIGHT;
    
    UITextView *textView = [[UITextView alloc] initWithFrame:headerFrame];
    [textView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [textView setBackgroundColor:RGB(255, 252, 229)];
    [textView setFont:[UIFont fontWithName:@"Menlo-Bold" size:9.f]];
    [textView setEditable:NO];

    [[YLConsoleLogTextView sharedInstance] attachTextView:textView];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setSectionHeaderHeight:30];
    [tableView setTableHeaderView:textView];
    [self.view addSubview:tableView];
    
    [[YLDownloadManager sharedInstance] setMaximumConcurrentOperation:1];
    
    FAKFontAwesome *downloadIcon = [FAKFontAwesome downloadIconWithSize:20];
    UIImage *downloadImage = [downloadIcon imageWithSize:CGSizeMake(20, 20)];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithImage:downloadImage
                                                                       style:UIBarButtonItemStyleDone
                                                                 actionBlock:^(UIBarButtonItem *rightBarButton) {
                                                                     start = clock();
                                                                     // 5 operations enqueue and we are limiting only one at a time
                                                                     for (int i = 0; i < self.contents.count; i ++) {
                                                                         NSDictionary *info = [self.contents objectAtIndex:i];
                                                                         NSString *URLStr = [info objectForKey:@"URI"];
                                                                         // allocate instance
                                                                         YLWebService *operation = [[YLWebService alloc] initWithURL:[NSURL URLWithString:URLStr]];
                                                                         // enqueue
                                                                         [self.optQueue addOperation:operation];
                                                                     }
                                                                 }];
    [self.navigationItem setRightBarButtonItem:rightBarButton];
    
    UIImage *clearImage = [[FAKFontAwesome eraserIconWithSize:20] imageWithSize:CGSizeMake(20, 20)];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:clearImage
                                     style:UIBarButtonItemStyleDone
                               actionBlock:^(UIBarButtonItem *leftBarButton) {
                                   NSString *targetPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
                                   NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:targetPath error:nil];
                                   [files enumerateObjectsUsingBlock:^(NSString *file, NSUInteger idx, BOOL *stop) {
                                       // remove each file
                                       [[NSFileManager defaultManager] removeItemAtPath:[targetPath stringByAppendingPathComponent:file] error:nil];
                                   }];
                                   
                                   [[YLConsoleLogTextView sharedInstance] clearConsoleScreen];
                               }];
    
    [self.navigationItem setLeftBarButtonItem:leftBarButton];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"operations"]) {
        NSOperationQueue *queue = (NSOperationQueue *)object;
        NSUInteger numOfOperations = [queue operationCount];
        if (numOfOperations == 0) {
            clock_t finish = clock();
            NSString *targetPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
            YLog(@"\n.download completed!\n.time took at %@ secs", @(getEstimateTime(start, finish)));
            YLog(@"\n.num of max concurrent used = %@\n", @(self.optQueue.maxConcurrentOperationCount));
            YLog(@"LINK: %@\n\nINSTRUCTIONS\n1)copy the link\n2)go to terminal->cd [directory path]\n3)type open .\n\n", targetPath);
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headerLabel = [[UILabel alloc] init];
    [headerLabel setFont:[UIFont systemFontOfSize:15]];
    [headerLabel setText:[NSString stringWithFormat:@"Max Concurrent Operation"]];
    [headerLabel sizeToFit];
    
    return headerLabel;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return MAX_CONCURRENT_RUNNING_QUEUE;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger maxConcurrent = [self.optQueue maxConcurrentOperationCount] -1;
    [cell.textLabel setText:[NSString stringWithFormat:@"%@", @(indexPath.row + 1)]];
    
    if (maxConcurrent == indexPath.row)
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    else
        [cell setAccessoryType:UITableViewCellAccessoryNone];
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
    [self.optQueue setMaxConcurrentOperationCount:indexPath.row + 1];
    [tableView reloadData];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
