//
//  ViewController.h
//  Voice Recorder
//
//  Created by Daniela Guillen on 7/6/16.
//  Copyright © 2016 Daniela Guillen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recording.h"
#import <AVFoundation/AVFoundation.h>
@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIProgressView *timer;

@property (weak, nonatomic) IBOutlet UIButton *startButton;

@property (weak, nonatomic) IBOutlet UIButton *stopButton;


@property (strong) Recording *currentRecording;
@property (strong) NSMutableArray *listOfRecordings;
@property (strong) AVAudioRecorder* recorder;
@property (strong) NSTimer* actualTimer;
@property int count;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;

@end

