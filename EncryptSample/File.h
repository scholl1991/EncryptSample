//
//  File.h
//  EncryptSample
//
//  Created by Serg Shulga on 1/7/15.
//  Copyright (c) 2015 TecSynt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Message;

@interface File : NSManagedObject

@property (nonatomic, retain) NSString * filePath;
@property (nonatomic, retain) NSString * thumbPath;
@property (nonatomic, retain) Message *message;

@end
