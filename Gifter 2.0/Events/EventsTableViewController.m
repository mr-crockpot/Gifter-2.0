//
//  EventsTableViewController.m
//  Gifter 2.0
//
//  Created by Adam Schor on 3/22/18.
//  Copyright © 2018 AandA Development. All rights reserved.
//

#import "EventsTableViewController.h"

@interface EventsTableViewController ()

@end

@implementation EventsTableViewController

- (void)viewDidLoad {
    
    _dbManager = [[DBManager alloc] initWithDatabaseFilename:@"gifterDB.db"];
    
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated {
    [self.parentViewController.navigationItem setTitle:@"Events"];
    
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                  target:self
                                  action:@selector(addEvent)];
    
    UIBarButtonItem *editButton          = [[UIBarButtonItem alloc]
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                            target:self
                                            action:@selector(toggleEditEvents)];
    
    self.parentViewController.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:addButton,editButton, nil];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _arrEvents.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cells" forIndexPath:indexPath];
    
    NSString *title;
    NSString *date;
    title = _arrEvents[indexPath.row][1];
   
    cell.textLabel.text = title;
    
    NSInteger month =0;
    NSInteger day = 0;
    NSInteger year = 0;
    
    if ([_arrEvents[indexPath.row][2] integerValue] != 0) {
        month = [_arrEvents[indexPath.row][2] integerValue];
        }
    if ([_arrEvents[indexPath.row][3] integerValue] != 0) {
        day = [_arrEvents[indexPath.row][3] integerValue];
    }
    if ([_arrEvents[indexPath.row][4] integerValue] != 0) {
        year = [_arrEvents[indexPath.row][4] integerValue];
    }
        if (month+day+year==0) {
            date = @"Various";
        }
        else{
            if (year == 0) {
                date = [NSString stringWithFormat:@"%li/%li",[_arrEvents[indexPath.row][2] integerValue],[_arrEvents[indexPath.row][3]integerValue]];
            }
            if (year != 0) {
                date = [NSString stringWithFormat:@"%li/%li/%li",[_arrEvents[indexPath.row][2] integerValue],[_arrEvents[indexPath.row][3]integerValue],[_arrEvents[indexPath.row][4]integerValue]];
            }
        }
    
    cell.detailTextLabel.text =date;
    
    return cell;
}

-(void)loadData{
    NSString *queryEvents = @"select events.eventID, events.eventName,ifnull(events.month, 0), ifnull(events.day,0), ifnull(events.year,0) from events order by events.eventName ASC";
    _arrEvents = [[NSMutableArray alloc] initWithArray:[_dbManager loadDataFromDB:queryEvents]];
    [_tblViewEvents reloadData];
   
    
}

-(void)addEvent {
    [self performSegueWithIdentifier:@"segueEventsTableToEventDetails" sender:self];
}



-(void)toggleEditEvents {
    _editable = !_editable;
    [self setEditing:_editable animated:YES];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   //[self performSegueWithIdentifier:@"segueEventsTableToEventDetails" sender:self];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *queryDelete;
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        queryDelete = [NSString stringWithFormat:@"DELETE FROM events where events.eventID = %li",[_arrEvents[indexPath.row][0]integerValue]];
        [_dbManager executeQuery:queryDelete];
        [self loadData];
        [_tblViewEvents reloadData];
        
        
        //   [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
