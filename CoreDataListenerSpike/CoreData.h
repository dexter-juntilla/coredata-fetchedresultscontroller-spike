//
//  CoreData.h
//  CoreDataListenerSpike
//
//  Created by DNA on 9/1/16.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreData : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *masterObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectContext *backgroundObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectContext *fetchObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (id)sharedInstance;
- (NSManagedObjectContext *)masterObjectContext;
- (NSManagedObjectContext *)backgroundObjectContext;
- (NSManagedObjectContext *)fetchObjectContext;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
