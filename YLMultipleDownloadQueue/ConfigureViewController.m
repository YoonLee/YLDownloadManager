//
//  ConfigureViewController.m
//  YLMultipleDownloadQueue
//
//  Created by Yoon Lee on 4/17/15.
//  Copyright (c) 2015 Yoon Lee. All rights reserved.
//

#import "ConfigureViewController.h"

@interface ConfigureViewController()
@property (nonatomic, strong) NSArray *contents;
@end

@implementation ConfigureViewController
@synthesize contents;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:CWHITE()];
    [self setTitle:@"Configuration"];
    
    NSString *contentPath = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
    contents = [[NSArray alloc] initWithContentsOfFile:contentPath];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    // retina line
    [tableView setSectionFooterHeight:(1.f / [UIScreen mainScreen].scale)];
    [tableView setRowHeight:35.f];
    [self.view addSubview:tableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return contents.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *info = [contents objectAtIndex:section];
    NSArray *subContent = [info objectForKey:@"rowTitleStrs"];
    
    return subContent.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *info = [contents objectAtIndex:section];
    NSString *subContentStr = [info objectForKey:@"sectionTitleStr"];
    
    return subContentStr;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *info = [contents objectAtIndex:indexPath.section];
    NSArray *subContent = [info objectForKey:@"rowTitleStrs"];
    NSString *rowTitleStrs = [subContent objectAtIndex:indexPath.row];
    [cell.textLabel setText:rowTitleStrs];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *YLConfigurationTableViewCellIdentifier = @"YLConfigurationTableViewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:YLConfigurationTableViewCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:YLConfigurationTableViewCellIdentifier];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
