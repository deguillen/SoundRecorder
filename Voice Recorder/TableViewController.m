//
//  TableViewController.m
//  Voice Recorder
//
//  Created by Daniela Guillen on 7/8/16.
//  Copyright © 2016 Daniela Guillen. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.willDelete = NO;
    
    /*NSLog(@"unarhived");
    NSString* archive = [NSString stringWithFormat:@"%@/Documents/arrayArchive", NSHomeDirectory()];
    self.otherListOfRecording = [[NSKeyedUnarchiver unarchiveObjectWithFile:archive] mutableCopy];*/
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1; //change to 1
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.otherListOfRecording count]; //size of list
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddhhmmss"];
    
    
     cell.textLabel.text = [formatter stringFromDate: [[self.otherListOfRecording objectAtIndex: indexPath.row] date]];
    
    //configure rows to array
    
    return cell;
}

-(void) play: (Recording*) aRecording
{
    NSError* error;
    if( self.player && self.player.playing){
        NSLog(@"Player exists and it's busy!");
        return;
    }else if( self.player && !self.player.playing){
        NSLog(@"player exists and not playing");
        self.player = [self.player initWithContentsOfURL:[aRecording url]
                                                   error:&error];
    }else{
        NSLog(@"Making a player");
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[aRecording url]
                                                             error:&error];

    }
    self.player.numberOfLoops = 0;
    [self.player prepareToPlay];
    [self.player play];
    NSLog(@"sound played");

    
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //play audio recording by getting it from the
    [self.tableView deselectRowAtIndexPath: indexPath animated:YES];
    
    
    if(self.willDelete) {
        [self.otherListOfRecording removeObjectAtIndex:(indexPath.row)];
        self.willDelete =NO;
        
    }
    else {
    [self play: [self.otherListOfRecording objectAtIndex: indexPath.row]];    
    }
    
}



-(void) viewWillDisappear:(BOOL)animated
{
    
    NSString* archive = [NSString stringWithFormat:@"%@/Documents/arrayArchive", NSHomeDirectory()];
    
    [NSKeyedArchiver archiveRootObject:self.otherListOfRecording toFile: archive];
    NSLog(@"saved");
    
}





// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSFileManager *manager = [NSFileManager defaultManager];
        NSError *err;
        [manager removeItemAtURL:[[self.otherListOfRecording objectAtIndex:indexPath.row] url] error: &err];
        [self.otherListOfRecording removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
