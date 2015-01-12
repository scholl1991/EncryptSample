//
//  ViewController.m
//  EncryptSample
//
//  Created by Serg Shulga on 1/6/15.
//  Copyright (c) 2015 TecSynt. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>
#import "DataSource.h"
#import "Stream.h"
#import "User.h"
#import "Message.h"
#import "DetaisViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, weak) IBOutlet UITableView* tableView;

@property (nonatomic, strong) NSFetchedResultsController* fetchedResultController;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass: [UITableViewCell class] forCellReuseIdentifier: @"CellIdentifier"];
    
    self.fetchedResultController = [[DataSource shared] streamsFetchedResultsController];
    self.fetchedResultController.delegate = self;
    
    NSError *error;
    if (![self.fetchedResultController performFetch:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

#pragma mark - Actions

- (IBAction) onAddUser: (id) sender
{
    [[DataSource shared] addNewUser];
}

#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.fetchedResultController.sections.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.fetchedResultController.sections.count > 0)
    {
        id <NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultController.sections[section];
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
    
    Stream* stream = [self.fetchedResultController objectAtIndexPath: indexPath];
    
    cell.textLabel.text = stream.user.name;
    cell.detailTextLabel.text = [NSString stringWithFormat: @"Messages: %lu", (unsigned long)stream.messages.count];
    
    return cell;
}

#pragma mark - Table view delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetaisViewController* vc = [[UIStoryboard storyboardWithName: @"Main" bundle: nil] instantiateViewControllerWithIdentifier: NSStringFromClass([DetaisViewController class])];
    vc.stream = [self.fetchedResultController objectAtIndexPath: indexPath];
    
    [self.navigationController pushViewController: vc animated: YES];
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
