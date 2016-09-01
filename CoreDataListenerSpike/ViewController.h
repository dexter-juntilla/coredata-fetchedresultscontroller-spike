//
//  ViewController.h
//  CoreDataListenerSpike
//
//  Created by DNA on 9/1/16.
//
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property UITableView *tableView;
@property NSManagedObject *selectedRecord;
@property NSFetchedResultsController *fetchedResultsController;

- (void)getDataFromDB;
- (void)rightBarButtonPressed;
- (void)saveItemPressed:(NSString *)title;
- (void)updateItemPressed:(NSString *)title didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

