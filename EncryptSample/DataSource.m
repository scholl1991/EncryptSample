//
//  DataSource.m
//  EncryptSample
//
//  Created by Serg Shulga on 1/6/15.
//  Copyright (c) 2015 TecSynt. All rights reserved.
//

#import "DataSource.h"
#import <CoreData/CoreData.h>
#import "EncryptedStore.h"

#import "Stream.h"
#import "User.h"
#import "File.h"
#import "Message.h"

static DataSource* dataSourceInstance = nil;

@interface DataSource ()

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) NSArray* photoPaths;

@end

@implementation DataSource

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (instancetype) shared
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataSourceInstance = [[self alloc] init];
    });
    
    return dataSourceInstance;
}

#pragma mark - Public stuff

- (void) fillData
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSArray* names = @[@"eliz", @"yura", @"franko"];
    NSMutableArray* paths = [NSMutableArray array];
    
    for (int i = 0; i < names.count; i++)
    {
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDir = [documentPaths objectAtIndex:0];
        NSString *newPath = [documentsDir stringByAppendingPathComponent: [NSString stringWithFormat: @"%@.png", names[i]]];

        NSString* curPath = [[NSBundle mainBundle] pathForResource: names[i] ofType: @"png"];
        
        NSError* error = nil;
        
        [[NSFileManager defaultManager] copyItemAtPath: curPath
                                                toPath: newPath
                                                 error: &error];
        [paths addObject: newPath];
    }
    
    self.photoPaths = paths;
    
    // Files
    File* file1 = [NSEntityDescription
                   insertNewObjectForEntityForName:@"File"
                   inManagedObjectContext:context];
    file1.filePath = [self randomFilePath];
    file1.thumbPath = [self randomFilePath];
    
    File* file2 = [NSEntityDescription
                   insertNewObjectForEntityForName:@"File"
                   inManagedObjectContext:context];
    file2.filePath = [self randomFilePath];
    file2.thumbPath = [self randomFilePath];
    
    File* file3 = [NSEntityDescription
                   insertNewObjectForEntityForName:@"File"
                   inManagedObjectContext:context];
    file3.filePath = [self randomFilePath];
    file3.thumbPath = [self randomFilePath];
    
    File* file4 = [NSEntityDescription
                   insertNewObjectForEntityForName:@"File"
                   inManagedObjectContext:context];
    file4.filePath = [self randomFilePath];
    file4.thumbPath = [self randomFilePath];
    
    File* file5 = [NSEntityDescription
                   insertNewObjectForEntityForName:@"File"
                   inManagedObjectContext:context];
    file5.filePath = [self randomFilePath];
    file5.thumbPath = [self randomFilePath];
    
    // Messages
    Message* message1 = [NSEntityDescription
                         insertNewObjectForEntityForName:@"Message"
                         inManagedObjectContext:context];
    message1.messageId = @"1";
    message1.date = [NSDate date];
    message1.file = file1;
    
    Message* message2 = [NSEntityDescription
                         insertNewObjectForEntityForName:@"Message"
                         inManagedObjectContext:context];
    message2.messageId = @"2";
    message2.date = [NSDate date];
    message2.file = file2;
    
    Message* message3 = [NSEntityDescription
                         insertNewObjectForEntityForName:@"Message"
                         inManagedObjectContext:context];
    message3.messageId = @"3";
    message3.date = [NSDate date];
    message3.file = file3;
    
    Message* message4 = [NSEntityDescription
                         insertNewObjectForEntityForName:@"Message"
                         inManagedObjectContext:context];
    message4.messageId = @"4";
    message4.date = [NSDate date];
    message4.file = file4;
    
    Message* message5 = [NSEntityDescription
                         insertNewObjectForEntityForName:@"Message"
                         inManagedObjectContext:context];
    message5.messageId = @"5";
    message5.date = [NSDate date];
    message5.file = file5;
    
    // Users
    User* user1 = [NSEntityDescription
                   insertNewObjectForEntityForName:@"User"
                   inManagedObjectContext:context];
    user1.userId = @"1";
    user1.name = @"User 1";
    [user1 addOutgoingMessagesObject: message1];
    
    User* user2 = [NSEntityDescription
                   insertNewObjectForEntityForName:@"User"
                   inManagedObjectContext:context];
    user2.userId = @"2";
    user2.name = @"User 2";
    [user2 addOutgoingMessages: [NSSet setWithArray: @[message2, message3]]];
    
    User* user3 = [NSEntityDescription
                   insertNewObjectForEntityForName:@"User"
                   inManagedObjectContext:context];
    user3.userId = @"3";
    user3.name = @"User 3";
    [user3 addOutgoingMessages: [NSSet setWithArray: @[message4, message5]]];
    
    // Streams
    Stream* stream1 = [NSEntityDescription
                       insertNewObjectForEntityForName:@"Stream"
                       inManagedObjectContext:context];
    stream1.streamId = @"1";
    stream1.user = user1;
    [stream1 addMessages: user1.outgoingMessages];
    
    Stream* stream2 = [NSEntityDescription
                       insertNewObjectForEntityForName:@"Stream"
                       inManagedObjectContext:context];
    stream2.streamId = @"2";
    stream2.user = user2;
    [stream2 addMessages: user2.outgoingMessages];
    
    Stream* stream3 = [NSEntityDescription
                       insertNewObjectForEntityForName:@"Stream"
                       inManagedObjectContext:context];
    stream3.streamId = @"3";
    stream3.user = user3;
    [stream3 addMessages: user3.outgoingMessages];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

- (void) clearDatabase
{
    // Remove persistent store (underlying sqlite database)
    [[NSFileManager defaultManager] removeItemAtURL: self.persistentStoreURL
                                              error: nil];
    
    // Null database linked objects
    _managedObjectContext       = nil;
    _managedObjectModel         = nil;
    _persistentStoreCoordinator = nil;
}

#pragma mark - Private stuff

- (NSString*) randomFilePath
{
    return self.photoPaths[arc4random()%self.photoPaths.count];
}

#pragma mark - Fetching data

- (NSArray*) getStreams
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Stream" inManagedObjectContext: self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"user.name" ascending: YES];
    [fetchRequest setSortDescriptors:@[sort]];
    
    NSError* error;
    NSArray* results = [self.managedObjectContext executeFetchRequest: fetchRequest error: &error];
    
    return results;
}

- (NSArray*) getUsers
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"User" inManagedObjectContext: self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"name" ascending: YES];
    [fetchRequest setSortDescriptors:@[sort]];
    
    NSError* error;
    NSArray* results = [self.managedObjectContext executeFetchRequest: fetchRequest error: &error];
    
    return results;
}

- (Message*) getMessageById: (NSString*) messageId
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"User" inManagedObjectContext: self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat: @"messageId == %@", messageId];
    fetchRequest.predicate = predicate;
    
    NSError* error;
    NSArray* results = [self.managedObjectContext executeFetchRequest: fetchRequest error: &error];
    
    NSAssert(results.count < 2, @"there are more than one entity with same messageId");
    
    Message* message = nil;
    if (results.count > 0)
    {
        message = [results lastObject];
    }
    
    return message;
}

- (Stream*) getStreamById: (NSString*) streamId
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Stream" inManagedObjectContext: self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat: @"streamId == %@", streamId];
    fetchRequest.predicate = predicate;
    
    NSError* error;
    NSArray* results = [self.managedObjectContext executeFetchRequest: fetchRequest error: &error];
    
    NSAssert(results.count < 2, @"there are more than one entity with same streamId");
    
    Stream* stream = nil;
    if (results.count > 0)
    {
        stream = [results lastObject];
    }
    
    return stream;
}

- (User*) getUserById: (NSString*) userId
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"User" inManagedObjectContext: self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat: @"userId == %@", userId];
    fetchRequest.predicate = predicate;
    
    NSError* error;
    NSArray* results = [self.managedObjectContext executeFetchRequest: fetchRequest error: &error];
    
    NSAssert(results.count < 2, @"there are more than one entity with same userId");
    
    User* user = nil;
    if (results.count > 0)
    {
        user = [results lastObject];
    }
    
    return user;
}

- (NSFetchedResultsController*) streamsFetchedResultsController
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName: @"Stream"
                                              inManagedObjectContext: self.managedObjectContext];
    fetchRequest.entity = entity;
    
    // Create the sort descriptors array.
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"user.name" ascending:YES];
    fetchRequest.sortDescriptors = @[sort];
    
    // Create and initialize the fetch results controller.
    NSFetchedResultsController* frc = [[NSFetchedResultsController alloc] initWithFetchRequest: fetchRequest
                                                                          managedObjectContext: self.managedObjectContext
                                                                            sectionNameKeyPath: nil
                                                                                     cacheName: nil];
    return frc;
}

- (NSFetchedResultsController*) messagesFetchedResultsControllerForStream: (Stream*) stream
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName: @"Message"
                                              inManagedObjectContext: self.managedObjectContext];
    fetchRequest.entity = entity;
    
    // Predicate
    NSPredicate* predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"ANY streams.streamId like '%@'", stream.streamId]];
    fetchRequest.predicate = predicate;
    
    // Create the sort descriptors array.
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey: @"date" ascending:NO];
    fetchRequest.sortDescriptors = @[sort];
    
    // Create and initialize the fetch results controller.
    NSFetchedResultsController* frc = [[NSFetchedResultsController alloc] initWithFetchRequest: fetchRequest
                                                                          managedObjectContext: self.managedObjectContext
                                                                            sectionNameKeyPath: nil
                                                                                     cacheName: nil];
    return frc;
}

#pragma mark - ONLY FOR TEST

- (void) getStreamsWithCompletion:(void (^)(NSArray *objects, NSError *error))completion
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Stream" inManagedObjectContext: self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"user.name" ascending: YES];
    [fetchRequest setSortDescriptors:@[sort]];
    
    NSManagedObjectContext *backgroundContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    backgroundContext.parentContext = self.managedObjectContext;
    
    [backgroundContext performBlock:^{
        
        // Fetch into shared persistent store in background thread
        NSError *error = nil;
        NSArray *fetchedObjects = [backgroundContext executeFetchRequest: fetchRequest error:&error];
        
        [self.managedObjectContext performBlock:^{
            if (fetchedObjects) {
                // Collect object IDs
                NSMutableArray *mutObjectIds = [[NSMutableArray alloc] initWithCapacity:[fetchedObjects count]];
                for (NSManagedObject *obj in fetchedObjects) {
                    [mutObjectIds addObject:obj.objectID];
                }
                
                // Fault in objects into current context by object ID as they are available in the shared persistent store
                NSMutableArray *mutObjects = [[NSMutableArray alloc] initWithCapacity:[mutObjectIds count]];
                for (NSManagedObjectID *objectID in mutObjectIds) {
                    NSManagedObject *obj = [self.managedObjectContext objectWithID:objectID];
                    [mutObjects addObject:obj];
                }
                
                if (completion) {
                    NSArray *objects = [mutObjects copy];
                    completion(objects, nil);
                }
            } else {
                if (completion) {
                    completion(nil, error);
                }
            }
        }];
    }];
}

#pragma mark - Add data

static int userId = 4;
static int messageId = 6;

- (void) addMessage: (NSDictionary*) messageInfo
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    File* file = [NSEntityDescription
                   insertNewObjectForEntityForName:@"File"
                   inManagedObjectContext:context];
    file.filePath = [self randomFilePath];
    file.thumbPath = [self randomFilePath];
    
    Message* message = [NSEntityDescription
                         insertNewObjectForEntityForName:@"Message"
                         inManagedObjectContext:context];
    message.messageId = [NSString stringWithFormat: @"%d", messageId];
    message.file = file;
    message.date = [NSDate date];
    
    messageId++;
    
    User* user = [self getUserById: messageInfo[@"senderId"]];
    
    NSAssert(user != nil, @"user should not be nil");
    
    message.sender = user;
    
    if (user.stream == nil)
    {
        Stream* stream = [NSEntityDescription
                           insertNewObjectForEntityForName:@"Stream"
                           inManagedObjectContext:context];
        stream.streamId = user.userId;
        stream.user = user;
        [stream addMessagesObject: message];
    }
    else
    {
        [message addStreamsObject: user.stream];
    }

    [self saveContext];
}

- (User*) addUser: (NSDictionary*) userInfo
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    User* user = [NSEntityDescription
                   insertNewObjectForEntityForName:@"User"
                   inManagedObjectContext:context];
    user.userId = [NSString stringWithFormat: @"%d", userId];
    user.name = [NSString stringWithFormat: @"User %d", userId];
    
    userId++;
    
    [self saveContext];
    
    return user;
}

- (void) addNewUser
{
    [self addNewUserWithCompletion: nil];
}

- (void) addNewUserWithCompletion: (void(^)(NSError* error)) completionBlock
{
    NSManagedObjectContext *temporaryContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    temporaryContext.parentContext = self.managedObjectContext;
    
    [temporaryContext performBlock: ^
     {
         User* user = [NSEntityDescription
                       insertNewObjectForEntityForName:@"User"
                       inManagedObjectContext: temporaryContext];
         user.userId = [NSString stringWithFormat: @"%d", userId];
         user.name = [NSString stringWithFormat: @"User %d", userId];
         
         userId++;
         
         // Stream for user
         Stream* stream = [NSEntityDescription
                           insertNewObjectForEntityForName:@"Stream"
                           inManagedObjectContext: temporaryContext];
         stream.streamId = user.userId;
         stream.user = user;
         
         // Message
         File* file = [NSEntityDescription
                       insertNewObjectForEntityForName:@"File"
                       inManagedObjectContext: temporaryContext];
         file.filePath = [self randomFilePath];
         file.thumbPath = [self randomFilePath];
         
         Message* message = [NSEntityDescription
                             insertNewObjectForEntityForName:@"Message"
                             inManagedObjectContext: temporaryContext];
         message.messageId = [NSString stringWithFormat: @"%d", messageId];
         message.date = [NSDate date];
         message.file = file;
         message.sender = user;
         [message addStreamsObject: stream];
         
         messageId++;
         
         // push to parent
         NSError *error;
         if (![temporaryContext save: &error])
         {
             // handle error
         }
         
         // save parent to disk asynchronously
         [self.managedObjectContext performBlock:^{
             NSError *error;
             [self.managedObjectContext save: &error];
             if (completionBlock != nil)
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     completionBlock(error);
                 });
             }
         }];
     }];
}

#pragma mark - Core Data Context Management

- (void)saveContext
{
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void) resetContext
{
    [self.managedObjectContext reset];
}

#pragma mark - Core Data setup

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.tecsynt.EncryptSample" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSURL*) persistentStoreURL
{
    return [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"EncryptSample.sqlite"];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"EncryptSample" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [self persistentStoreURL];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext
{
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [EncryptedStore makeStore:[self managedObjectModel] passcode:@"1234"];
    
//    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType: NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

@end




