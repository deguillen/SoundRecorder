//
//  TableViewController.h
//  Voice Recorder
//
//  Created by Daniela Guillen on 7/8/16.
//  Copyright © 2016 Daniela Guillen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "Recording.h"
@interface TableViewController : UITableViewController;

@property (strong, nonatomic) NSMutableArray* otherListOfRecording;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property bool willDelete;
@property (strong, nonatomic) AVAudioPlayer* player;

@end
