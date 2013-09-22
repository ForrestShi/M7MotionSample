//
//  SecondViewController.m
//  M7MotionSample
//
//  Created by griffin-stewie on 2013/09/20.
//  Copyright (c) 2013年 cyan-stivy.net. All rights reserved.
//

#import "MotionActivityViewController.h"
#import "ActivityCell.h"
#import "Logger.h"

@interface MotionActivityViewController ()
@property (nonatomic, strong) CMMotionActivityManager *motionActivitiyManager;
@property (nonatomic, strong) NSMutableArray *activities;
@property (nonatomic, strong) Logger *logger;
@end

@implementation MotionActivityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Start", nil)
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(startUpdateActivity)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (Logger *)logger
{
    if (_logger == nil) {
        _logger = [[Logger alloc] init];
    }
    return _logger;
}

- (void)startUpdateActivity
{
    if ([CMMotionActivityManager isActivityAvailable]) {
        self.motionActivitiyManager = [[CMMotionActivityManager alloc] init];
        [self.motionActivitiyManager startActivityUpdatesToQueue:[NSOperationQueue mainQueue]
                                                     withHandler:^(CMMotionActivity *activity) {
                                                         NSLog(@"%s %@", __PRETTY_FUNCTION__, activity);
                                                         [self.logger appendText:[activity description]];
                                                         [self.activities insertObject:activity atIndex:0];
                                                         [self.tableView beginUpdates];
                                                         [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                                                         [self.tableView endUpdates];
                                                     }];
        [self.navigationItem.rightBarButtonItem setTitle:NSLocalizedString(@"Stop", nil)];
        [self.navigationItem.rightBarButtonItem setAction:@selector(stopUpdateActivity)];
    }
}

- (void)stopUpdateActivity
{
    [self.navigationItem.rightBarButtonItem setTitle:NSLocalizedString(@"Start", nil)];
    [self.navigationItem.rightBarButtonItem setAction:@selector(startUpdateActivity)];
    [self.motionActivitiyManager stopActivityUpdates];
    [self.logger writeToFile];
}

- (NSMutableArray *)activities
{
    if (_activities == nil) {
        _activities = [NSMutableArray array];
    }
    return _activities;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.activities count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ActivityCell *cell = (ActivityCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    CMMotionActivity *activity = [self.activities objectAtIndex:indexPath.row];
    cell.activity = activity;
    return cell;
}

@end