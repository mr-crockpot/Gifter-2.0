//
//  GiftsTableViewController.m
//  Gifter 2.0
//
//  Created by Adam Schor on 3/22/18.
//  Copyright © 2018 AandA Development. All rights reserved.
//

#import "GiftsTableViewController.h"
#import "GiftsDetailsViewController.h"

@interface GiftsTableViewController ()

@end

@implementation GiftsTableViewController

- (void)viewDidLoad {
    
    _dbManager = [[DBManager alloc] initWithDatabaseFilename:@"gifterDB.db"];

    [super viewDidLoad];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated{
    [self.parentViewController.navigationItem setTitle:@"Gifts"];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                  target:self
                                  action:@selector(addGift)];
    
    UIBarButtonItem *editButton          = [[UIBarButtonItem alloc]
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                            target:self
                                            action:@selector(toggleEditGifts)];
    
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
    
    return _arrGifts.count;
}

-(void)loadData{
    
    NSString *queryGifts = @"SELECT * from gifts ORDER BY gifts.price ASC";
    _arrGifts = [[NSMutableArray alloc] initWithArray:[_dbManager loadDataFromDB:queryGifts]];
    _arrIndexOfGiftsIDs = [[NSMutableArray alloc] init];
    [_tblViewGifts reloadData];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cells" forIndexPath:indexPath];
    
    NSString *title = _arrGifts[indexPath.row][1];
    cell.textLabel.text = title;
    cell.detailTextLabel.text = _arrGifts[indexPath.row][2];
    
    [_arrIndexOfGiftsIDs addObject:_arrGifts[indexPath.row][0]];
   
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    _giftID = [_arrIndexOfGiftsIDs[indexPath.row]integerValue];
    [self performSegueWithIdentifier:@"segueGiftTableToGiftDetails" sender:self];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    GiftsDetailsViewController *giftsDetailsViewController = [segue destinationViewController];
    giftsDetailsViewController.giftID = _giftID;
    
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *queryDelete;
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        queryDelete = [NSString stringWithFormat:@"DELETE FROM gifts where gifts.giftID = %li",[_arrIndexOfGiftsIDs[indexPath.row] integerValue]];
        
        [_dbManager executeQuery:queryDelete];
        [self loadData];
        [_tblViewGifts reloadData];
       
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

-(void)addGift {
   
    _giftID = -1;
    [self performSegueWithIdentifier:@"segueGiftTableToGiftDetails" sender:self];
    
}

-(void)toggleEditGifts {
    _editable = !_editable;
    [self setEditing:_editable animated:YES];
    }

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
}
@end
