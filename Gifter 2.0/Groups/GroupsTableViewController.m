//
//  GroupsTableViewController.m
//  Gifter 2.0
//
//  Created by Adam Schor on 3/22/18.
//  Copyright © 2018 AandA Development. All rights reserved.
//

#import "GroupsTableViewController.h"

@interface GroupsTableViewController ()

@end

@implementation GroupsTableViewController

- (void)viewDidLoad {
    
    _dbManager = [[DBManager alloc] initWithDatabaseFilename:@"gifterDB.db"];
    [super viewDidLoad];
    
   [self loadData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated {
    
   [self.parentViewController.navigationItem setTitle:@"Groups"];
    
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                  target:self
                                  action:@selector(addGroup)];
    
    UIBarButtonItem *editButton          = [[UIBarButtonItem alloc]
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                            target:self
                                            action:@selector(toggleEditGroups)];
    
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

    return _arrayGroups.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cells" forIndexPath:indexPath];
    
    NSString *title;
    title = _arrayGroups[indexPath.row][1];
    cell.textLabel.text = title;
    
    return cell;
}

-(void)loadData {
    
    NSString *queryLoadGroups = @"SELECT * FROM groups";
    _arrayGroups = [[NSMutableArray alloc] initWithArray:[_dbManager loadDataFromDB:queryLoadGroups]];
    
    NSLog(@"The array groups is %@",_arrayGroups);
    [_tblViewGroups reloadData];
    
}



-(void)addGroup{
    [self performSegueWithIdentifier:@"segueGroupsTableToGroupDetails" sender:self];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSInteger selectedGroupID = [_arrayGroups[indexPath.row][0]integerValue];
        NSString *queryDeleteGroup =[NSString stringWithFormat:@"delete from groups where groups.groupID = %li",selectedGroupID];
        NSString *quearyDeletePeopleGroup = [NSString stringWithFormat:@"update peopleGroups set groupID = 1 where peopleGroups.groupID = %li",selectedGroupID];
        
        
        [_dbManager executeQuery:queryDeleteGroup];
        [_dbManager executeQuery:quearyDeletePeopleGroup];
        
     //   NSLog( @"The row deleted is %li and the group is %@",indexPath.row,_arrayGroups[indexPath.row][1]);
        
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    
    [self loadData];
    [_tblViewGroups reloadData];

}


-(void)toggleEditGroups {
    _editable = !_editable;
    [self setEditing:_editable animated:YES];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
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
