//
//  PeopleTableViewController.m
//  Gifter 2.0
//
//  Created by Adam Schor on 3/22/18.
//  Copyright © 2018 AandA Development. All rights reserved.
//

#import "PeopleTableViewController.h"
#import "PeopleDetailsViewController.h"
#import "DBManager.h"
#import "GeneralMethods.h"

@interface PeopleTableViewController ()

@end

@implementation PeopleTableViewController

- (void)viewDidLoad {
     _arrIndexOfPeopleIDs = [[NSMutableArray alloc] init];
     _dbManager = [[DBManager alloc] initWithDatabaseFilename:@"gifterDB.db"];
 
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated{
    [self.parentViewController.navigationItem setTitle:@"People"];
 
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                             initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                             target:self
                                             action:@selector(addPeople)];
    
    UIBarButtonItem *editButton          = [[UIBarButtonItem alloc]
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                            target:self
                                            action:@selector(toggleEditing)];
    
    self.parentViewController.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:addButton,editButton, nil];
    
    [self loadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData {
    NSString *queryPeople = @"Select people.peopleID, ifnull(people.firstname,-1), ifnull (people.lastname,-1), ifnull(groups.groupname,-1), ifnull(groups.groupID,-1) from people,  peopleGroups, groups  where people.peopleID = peopleGroups.peopleID and groups.groupID = peopleGroups.groupID  order by people.lastname asc";
    NSString *queryGroups = @"Select * from groups";
    
    _arrPeople = [[NSMutableArray alloc] initWithArray:[_dbManager loadDataFromDB:queryPeople]];
    _arrGroups = [[NSMutableArray alloc] initWithArray:[_dbManager loadDataFromDB:queryGroups]];
  // NSLog(@"On loading, the people array is %@",_arrPeople);
  
    [_tblViewPeople reloadData];
    
}

-(void)addPeople{
    
    _activePerson = -1;
  [self performSegueWithIdentifier:@"seguePeopleTableToPeopleDetails" sender:self];
    
}
#pragma mark TABLE CODE

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _arrGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int sectionCount = 0;
    for (int i = 0; i < _arrPeople.count; i++){
        if (section +1 == [_arrPeople[i][4] integerValue]){
            sectionCount++;
        }
    }
   
    return sectionCount;
    
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *sectionTitle;
    
    sectionTitle = _arrGroups[section][1];
    tableView.layer.backgroundColor = [[UIColor greenColor] CGColor];
    
    return sectionTitle;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cells" forIndexPath:indexPath];
    NSString *firstName;
    NSString *lastName;
    NSString *formattedName;
  
    
    for (int i = 0; i<_arrPeople.count; i++){
        
        if ([_arrPeople[i][4] integerValue] -1 == indexPath.section){
            firstName = _arrPeople[i][1];
            lastName = _arrPeople[i][2];
          
            NSMutableArray *tempIndex = [[NSMutableArray alloc] init];
            [tempIndex addObject:_arrPeople[i][0]];
            [tempIndex addObject:@(indexPath.section)];
            [tempIndex addObject:@(indexPath.row)];
            [_arrIndexOfPeopleIDs addObject:tempIndex];
            [_arrPeople removeObjectAtIndex:i];
          
            break;
        }

    }
    
    formattedName = [NSString stringWithFormat:@"%@ %@",firstName,lastName];
    cell.textLabel.text = formattedName;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger selectedRow = indexPath.row;
    NSInteger selectedSection = indexPath.section;
    
    for (int x = 0; x<_arrIndexOfPeopleIDs.count; x++) {
       
        if ([_arrIndexOfPeopleIDs[x][1] integerValue] == selectedSection && [_arrIndexOfPeopleIDs[x][2] integerValue] == selectedRow) {
            _activePerson = [_arrIndexOfPeopleIDs[x][0] integerValue];
        }
    }
   
    [self performSegueWithIdentifier:@"seguePeopleTableToPeopleDetails" sender:self];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        for (int x = 0; x<_arrIndexOfPeopleIDs.count; x++) {
            
            if ([_arrIndexOfPeopleIDs[x][1] integerValue] == indexPath.section && [_arrIndexOfPeopleIDs[x][2] integerValue] == indexPath.row) {
                _activePerson = [_arrIndexOfPeopleIDs[x][0] integerValue];
            }
        }
     // [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
       
      // NSString *queryDeletePerson = [NSString stringWithFormat:@"DELETE FROM people WHERE people.peopleID = %li;DELETE FROM peopleEvents WHERE peopleEvents.peopleID = %li; DELETE FROM peopleGifts WHERE peopleGifts.peopleID = %li; DELETE FROM peopleGroups WHERE peopleGroups.peopleID = %li;",_activePerson,_activePerson,_activePerson,_activePerson];
        
       NSString *queryDeletePerson = [NSString stringWithFormat:@"DELETE FROM peopleGroups WHERE peopleGroups.peopleID = %li",_activePerson];
    
       [_dbManager executeQuery:queryDeletePerson];
      
    [self loadData];
     
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    NSInteger fromRow = fromIndexPath.row;
    NSInteger fromSection = fromIndexPath.section;
    NSInteger toSection = toIndexPath.section;
    
   
    
    for (int x = 0; x<_arrIndexOfPeopleIDs.count; x++) {
        
    if ([_arrIndexOfPeopleIDs[x][1] integerValue] == fromSection && [_arrIndexOfPeopleIDs[x][2] integerValue] == fromRow) {
        _activePerson = [_arrIndexOfPeopleIDs[x][0] integerValue];
            }
    }
   
    NSInteger newGroupID = toSection + 1;
    NSString *updateGroupQuery = [NSString stringWithFormat:@"update peopleGroups set groupID = %li where peopleGroups.peopleID =%li",newGroupID,_activePerson];
    [_dbManager executeQuery:updateGroupQuery];
    [self loadData];
   
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
-(void)toggleEditing{
    _editable = ! _editable;
    [self setEditing:_editable animated:YES];
}
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"seguePeopleTableToPeopleDetails"]) {
        PeopleDetailsViewController *peopleDetailVC = [segue destinationViewController];
        peopleDetailVC.activePerson = _activePerson;
    }
}




@end
