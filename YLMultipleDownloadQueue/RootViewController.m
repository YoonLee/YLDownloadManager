//
//  RootViewController.m
//  YLMultipleDownloadQueue
//
//  Created by Yoon Lee on 4/15/15.
//  Copyright (c) 2015 Yoon Lee. All rights reserved.
//

#import "RootViewController.h"
#import "YLURLConnectionOperation.h"
#import "YLURLSessionOperation.h"
#import "YLSaveUserDefault.h"
#import "YLAFNetworkingOperation.h"
#import "UIBarButtonItem+Category.h"
#import "ConfigureViewController.h"
#import "YLOperationQueueManager.h"
#import <FontAwesomeKit/FontAwesomeKit.h>
#define HEADER_PANEL_HEIGHT             220.f

@implementation RootViewController
@synthesize contents;
@synthesize fileURIs;
@synthesize typeOfOperations;

clock_t start;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    [self setTitle:@"OperationQueue"];
    
    NSInteger defaultConcurrentNum = [[[YLSaveUserDefault sharedInstance] getDefaultConCurNum] integerValue] + 1;
    [[YLOperationQueueManager sharedInstance] setNumOfMaximumConcurrent:defaultConcurrentNum];
    
    typeOfOperations = @[[YLURLConnectionOperation class], [YLURLSessionOperation class], [YLAFNetworkingOperation class]];
    
    // KVO
    [[[YLOperationQueueManager sharedInstance] operationQueue] addObserver:self
               forKeyPath:@"operations"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"RootDisplay" ofType:@"plist"];
    contents = [[NSArray alloc] initWithContentsOfFile:filePath];
    
    NSString *URIsPath = [[NSBundle mainBundle] pathForResource:@"DownloadList" ofType:@"plist"];
    fileURIs = [[NSArray alloc] initWithContentsOfFile:URIsPath];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    
    // retina line
    [tableView setSectionFooterHeight:(1.f / [UIScreen mainScreen].scale)];
    [self.view addSubview:tableView];
    
    FAKFontAwesome *downloadIcon = [FAKFontAwesome downloadIconWithSize:20];
    UIImage *downloadImage = [downloadIcon imageWithSize:CGSizeMake(20, 20)];
    UIBarButtonItem *downloadBarButton = [[UIBarButtonItem alloc] initWithImage:downloadImage
                                                                          style:UIBarButtonItemStyleDone
                                                                    actionBlock:^(UIBarButtonItem *downloadBarButton) {
                                                                        start = clock();
                                                                        YLog(@".enuquing %@ operation(s)\n", @(self.fileURIs.count));
                                                                        NSInteger selected = [[[YLSaveUserDefault sharedInstance] getDefaultMethod] integerValue];
                                                                        NSString *nameOfOperationClass = NSStringFromClass(self.typeOfOperations[selected]);
                                                                        
                                                                        for (int i = 0; i < self.fileURIs.count; i ++) {
                                                                            NSDictionary *info = [self.fileURIs objectAtIndex:i];
                                                                            NSString *URLStr = [info objectForKey:@"URI"];
                                                                            // allocate instance
                                                                            Class class = NSClassFromString(nameOfOperationClass);
                                                                            YLOperation *operation = [(YLOperation *)[class alloc] initWithURL:[NSURL URLWithString:URLStr]];
                                                                            // enqueue
                                                                            [[YLOperationQueueManager sharedInstance] enqueueOperation:operation];
                                                                        }
                                                                    }];
    UIImage *options = [[FAKFontAwesome gearsIconWithSize:20] imageWithSize:CGSizeMake(20, 20)];
    UIBarButtonItem *optionBarButton = [[UIBarButtonItem alloc] initWithImage:options
                                                                        style:UIBarButtonItemStyleDone
                                                                  actionBlock:^(UIBarButtonItem *optionBarButton) {
                                                                      ConfigureViewController *configureVC = [[ConfigureViewController alloc] init];
                                                                      [configureVC setChangeCallback:^(NSIndexPath *indexPath) {
                                                                          switch (indexPath.section) {
                                                                              case METHODS:
                                                                                  
                                                                                  break;
                                                                              case NUM_OF_MAX_CONCURRENT: {
                                                                                  NSInteger defaultConcurrentNum = [[[YLSaveUserDefault sharedInstance] getDefaultConCurNum] integerValue] + 1;
                                                                                  [[YLOperationQueueManager sharedInstance] setNumOfMaximumConcurrent:defaultConcurrentNum];
                                                                                  break;
                                                                              }
                                                                          }
                                                                          
                                                                          [tableView reloadData];
                                                                      }];
                                                                      
                                                                      [self.navigationController pushViewController:configureVC animated:YES];
                                                                  }];
    [self.navigationItem setRightBarButtonItems:@[optionBarButton, downloadBarButton]];
    
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
            YLog(@"\n.num of max concurrent used = %@\n", @([[YLOperationQueueManager sharedInstance] numOfOperations]));
            CLog(@"LINK: %@\n\nINSTRUCTIONS\n1)copy the link\n2)go to terminal->cd [directory path]\n3)type open .\n\n", targetPath);
        }
    }
}

- (BOOL)isPaused:(NSString *)cellStr
{
    return [cellStr isEqualToString:@"Pause"];
}

#pragma marks - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = HEADER_PANEL_HEIGHT;
    if (indexPath.section == INFO || indexPath.section == TASK_OPERATION) {
        rowHeight = 35.f;
    }
    
    return rowHeight;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *info = [self.contents objectAtIndex:section];
    NSString *subContentStr = [info objectForKey:@"sectionStr"];
    
    return subContentStr;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.contents.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *info = [self.contents objectAtIndex:section];
    NSInteger numOfRows = [[info objectForKey:@"rowTitleStrs"] count];
    
    return numOfRows;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (indexPath.section == TASK_OPERATION) {
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
    }
    [cell.textLabel setFont:[UIFont systemFontOfSize:14.f]];
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:14.f]];
    cell.imageView.image = nil;
    
    NSDictionary *info = [self.contents objectAtIndex:indexPath.section];
    NSString *rowTitleStr = [[info objectForKey:@"rowTitleStrs"] objectAtIndex:indexPath.row];
    [cell.textLabel setText:rowTitleStr];
    
    NSString *detailStr = @"";
    
    if (indexPath.section == CONSOLE) {
        CGRect consoleFrame = cell.bounds;
        consoleFrame.size.height = HEADER_PANEL_HEIGHT;
        UITextView *textView = [[UITextView alloc] initWithFrame:consoleFrame];
        [textView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [textView setBackgroundColor:RGB(255, 252, 229)];
        [textView setFont:[UIFont fontWithName:@"Menlo-Bold" size:9.f]];
        [textView setEditable:NO];
        
        [[YLConsoleLogTextView sharedInstance] attachTextView:textView];
        [cell.contentView addSubview:textView];
    }
    else if (indexPath.section == INFO) {
        switch (indexPath.row) {
            case METHODS:
                detailStr = [self defaultMethodTranslation:[[YLSaveUserDefault sharedInstance] getDefaultMethod]];
                break;
            case NUM_OF_MAX_CONCURRENT:
                detailStr = [NSString stringWithFormat:@"%@", @([[[YLSaveUserDefault sharedInstance] getDefaultConCurNum] integerValue] + 1)];
                break;
        }
        
        [cell.detailTextLabel setText:detailStr];
    }
    else if (indexPath.section == TASK_OPERATION) {
        UIImage *cellImage = [[FAKFontAwesome playIconWithSize:20] imageWithSize:CGSizeMake(20, 20)];
        if ([self isPaused:cell.textLabel.text]) {
            cellImage = [[FAKFontAwesome pauseIconWithSize:20] imageWithSize:CGSizeMake(20, 20)];
        }
        
        [cell.imageView setImage:cellImage];
    }
}

- (NSString *)defaultMethodTranslation:(NSNumber *)selectedMethod
{
    NSString *methodStr = @"";
    NSInteger selected = [selectedMethod integerValue];
    switch (selected) {
        case URLConnection:
            methodStr = @"NSURLConnection";
            break;
        case URLSession:
            methodStr = @"NSURLSession";
            break;
        case AFNetworking_2:
            methodStr = @"AFNetworking";
            break;
    }
    
    return methodStr;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *YLDownloadTableViewCellIdentifier = @"YLDownloadTableViewCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:YLDownloadTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:YLDownloadTableViewCellIdentifier];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == TASK_OPERATION) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIImage *cellImage = [[FAKFontAwesome pauseIconWithSize:20] imageWithSize:CGSizeMake(20, 20)];
        
        if ([self isPaused:cell.textLabel.text]) {
            CLog(@".Pausing ...");
            [cell.textLabel setText:@"Resume"];
            cellImage = [[FAKFontAwesome playIconWithSize:20] imageWithSize:CGSizeMake(20, 20)];
            [[YLOperationQueueManager sharedInstance] pauseOperations];
        }
        else {
            CLog(@".Resuming ...");
            YLog(@".remaining operations are %@\n", @([[YLOperationQueueManager sharedInstance] numOfOperations]));
            [cell.textLabel setText:@"Pause"];
            [[YLOperationQueueManager sharedInstance] continueOperations];
        }
        
        [cell.imageView setImage:cellImage];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
