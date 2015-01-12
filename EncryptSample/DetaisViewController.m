//
//  DetaisViewController.m
//  EncryptSample
//
//  Created by Serg Shulga on 1/9/15.
//  Copyright (c) 2015 TecSynt. All rights reserved.
//

#import "DetaisViewController.h"
#import <CoreData/CoreData.h>
#import "DataSource.h"
#import "Message.h"
#import "Stream.h"
#import "User.h"
#import "File.h"

@interface DetaisViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, weak) IBOutlet UITableView* tableView;

@property (nonatomic, strong) NSFetchedResultsController* fetchedResultsController;

@end

@implementation DetaisViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass: [UITableViewCell class] forCellReuseIdentifier: @"CellIdentifier"];
    
    self.fetchedResultsController = [[DataSource shared] messagesFetchedResultsControllerForStream: self.stream];
    self.fetchedResultsController.delegate = self;
    
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

#pragma mark - Actions

- (IBAction) onAddMessage: (id) sender
{
    [[DataSource shared] addMessage: @{@"senderId" : self.stream.user.userId}];
}

#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.fetchedResultsController.sections.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.fetchedResultsController.sections.count > 0)
    {
        id <NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
        return [sectionInfo numberOfObjects];
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CellIdentifier = @"CellIdentifier";
    
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier: CellIdentifier forIndexPath: indexPath];
    
    Message* message = [self.fetchedResultsController objectAtIndexPath: indexPath];
    
    cell.imageView.image = [UIImage imageWithContentsOfFile: message.file.thumbPath];
    
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
//    
//    dispatch_async(queue, ^
//    {
//        UIImage *image = [UIImage imageWithContentsOfFile: message.file.thumbPath];
//        
//        dispatch_sync(dispatch_get_main_queue(), ^
//        {
//            cell.imageView.image = image;
//            [cell setNeedsLayout];
//        });
//    });
    
    return cell;
}

#pragma mark - Table view delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void) controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void) controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
        {
            [self.tableView insertRowsAtIndexPaths: @[newIndexPath] withRowAnimation: UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeUpdate:
        {
            [self.tableView reloadRowsAtIndexPaths: @[newIndexPath] withRowAnimation: UITableViewRowAnimationNone];
            break;
        }
        case NSFetchedResultsChangeDelete:
        {
            [self.tableView deleteRowsAtIndexPaths: @[indexPath] withRowAnimation: UITableViewRowAnimationRight];
        }
            
        default:
            break;
    }
}

- (void) controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

@end
