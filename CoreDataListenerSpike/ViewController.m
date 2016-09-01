//
//  ViewController.m
//  CoreDataListenerSpike
//
//  Created by DNA on 9/1/16.
//
//

#import "ViewController.h"
#import "Helper.h"
#import "CoreData.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize tableView;
@synthesize fetchedResultsController;

#pragma mark -
#pragma mark View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, [Helper getScreenWidth], [Helper getScreenHeight] - 20) style:UITableViewStylePlain];
    [self tableView].delegate = self;
    [self tableView].dataSource = self;
    [[self tableView] reloadData];
    [[self tableView] registerClass:[UITableViewCell self] forCellReuseIdentifier:@"CellIdentifier"];
    [[self view] addSubview:tableView];
    [self getDataFromDB];
    
    UIBarButtonItem *createItem = [[UIBarButtonItem alloc] initWithTitle: @"Add" style:UIBarButtonItemStylePlain target: self action:@selector(rightBarButtonPressed)];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    [self.navigationItem setRightBarButtonItem:createItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Table View Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[[self fetchedResultsController] sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sections = [[self fetchedResultsController] sections];
    id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
    return  [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [NSString stringWithFormat:@"CellIdentifier"];
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
    }
    else {
        for (UIView *view in [[cell contentView] subviews]) {
            [view removeFromSuperview];
        }
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSManagedObject *record = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    [cell textLabel].text = [record valueForKey:@"title"];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, [[cell contentView] bounds].size.height - 1, [Helper getScreenWidth], 1)];
    
    bottomLine.backgroundColor = [UIColor grayColor];
    [[cell contentView] addSubview:bottomLine];
    
    return cell;
}

#pragma mark -
#pragma mark Fetch Results Controller Delegate methods

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(nullable NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(nullable NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeDelete: {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeUpdate: {
//            [self configureCell:(TSPToDoCell *)[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            [[self tableView] reloadData];
            break;
        }
        case NSFetchedResultsChangeMove: {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
    }
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [[self tableView] beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [[self tableView] endUpdates];
}

#pragma mark -
#pragma mark Custom Methods

- (void)getDataFromDB {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"createdDate" ascending:YES]]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[[CoreData sharedInstance] masterObjectContext] sectionNameKeyPath:nil cacheName:nil];
    [[self fetchedResultsController] setDelegate:self];
    
    NSError *error = nil;
    [[self fetchedResultsController] performFetch:&error];
    
    if (error) {
        NSLog(@"Unable to perform fetch.");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
//    
//    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:[[CoreData sharedInstance] masterObjectContext]];
//    [fetchRequest setEntity:entityDescription];
//    
//    NSError *error = nil;
//    NSArray *result = [[[[CoreData sharedInstance] masterObjectContext] executeRequest:fetchRequest error:&error] finalResult];
//    
//    NSMutableArray *temp = [[NSMutableArray alloc] init];
//    
//    for (NSManagedObject *obj in result) {
//        NSArray *keys = [[[obj entity] attributesByName] allKeys];
//        NSDictionary *dict = [obj dictionaryWithValuesForKeys:keys];
//        [temp addObject:dict];
//    }
}

- (void)rightBarButtonPressed {
    NSLog(@"%@", @"rightBarButtonPressed");
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Title"
                                                                              message: nil
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"title";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * titleField = textfields[0];
        NSLog(@"%@",titleField.text);
        [self saveItemPressed:titleField.text];
    }]];
    
    [self presentViewController:alertController animated:YES completion:^{}];
}

- (void)saveItemPressed:(NSString *)title {
    
    if (title && title.length) {
        // Create Entity
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:[[CoreData sharedInstance] masterObjectContext]];
        
        // Initialize Record
        NSManagedObject *record = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:[[CoreData sharedInstance] masterObjectContext]];
        
        // Populate Record
        [record setValue:title forKey:@"title"];
        [record setValue:[NSDate date] forKey:@"createdDate"];
        [record setValue:@NO forKey:@"done"];
        
        // Save Record
        NSError *error = nil;
        [[CoreData sharedInstance] saveContext];
        if (error) {
            NSLog(@"%@", error);
        }
    }
}

@end
