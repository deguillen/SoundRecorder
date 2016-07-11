//
//  ViewController.m
//  Voice Recorder
//
//  Created by Daniela Guillen on 7/6/16.
//  Copyright © 2016 Daniela Guillen. All rights reserved.
//

#import "ViewController.h"
#import "TableViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.timer setProgress:0];
    
    NSString* archive = [NSString stringWithFormat:@"%@/Documents/arrayArchive", NSHomeDirectory()];
    self.listOfRecordings = [[NSKeyedUnarchiver unarchiveObjectWithFile:archive] mutableCopy];
    
    if(!self.listOfRecordings) {
        self.listOfRecordings = [[NSMutableArray alloc] init];
    }
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startRecording:(id)sender {
    
    AVAudioSession* audioSession = [AVAudioSession sharedInstance];
    NSError* error = nil;
    [audioSession setCategory: AVAudioSessionCategoryRecord error: &error];  //confused
    [audioSession setActive:YES error:nil]; 
    
    if(error) {
        NSLog(@"audioSession: %@ %ld %@",
              [error domain], [error code], [[error userInfo] description]);
        return;
    }
    
    NSMutableDictionary* settings = [[NSMutableDictionary alloc] init];
    
    //Don't get
    [settings setValue:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    
    [settings setValue:@44100.0 forKey:AVSampleRateKey];
    
    [settings setValue:@1 forKey:AVNumberOfChannelsKey];
    
    [settings setValue:@16 forKey:AVLinearPCMBitDepthKey];
    
    [settings setValue:@(NO) forKey:AVLinearPCMIsBigEndianKey];
    
    [settings setValue:@(NO) forKey:AVLinearPCMIsFloatKey];
    
    [settings setValue:@(AVAudioQualityHigh)
                         forKey:AVEncoderAudioQualityKey];
    NSDate* now = [NSDate date];
    
    self.currentRecording = [[Recording alloc] initWithDate: now];
    [self.listOfRecordings addObject: self.currentRecording];
    error = nil;

    self.recorder = [[AVAudioRecorder alloc]
                     initWithURL:self.currentRecording.url
                     settings:settings
                     error:&error];
    if(!self.recorder) {
        NSLog(@"audioSession: %@ %ld %@",
              [error domain], [error code], [[error userInfo] description]);
        UIAlertController* alert = [UIAlertController
                                    alertControllerWithTitle:@"Warning"
                                    message:[error localizedDescription]
                                    preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction
                                        actionWithTitle:@"OK"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
        
    }
    //prepare to record
    
    [self.recorder prepareToRecord];
    self.recorder.meteringEnabled = YES;
    BOOL audioHWAvailable = audioSession.inputAvailable;
    
    if( !audioHWAvailable ){
        UIAlertController* cantRecordAlert = [UIAlertController
                                              alertControllerWithTitle:@"Warning"
                                              message:@"Audio input hardware not available."
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction
                                        actionWithTitle:@"OK"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {}];
        
        [cantRecordAlert addAction:defaultAction];
        [self presentViewController:cantRecordAlert animated:YES completion:nil];
        
        
        return;
    }
    [self.recorder recordForDuration:(NSTimeInterval)10];
    
    self.count=0;
    [self.timer setProgress: 0.0];
    self.actualTimer = [NSTimer
                        scheduledTimerWithTimeInterval:0.1
                        target:self
                        selector:@selector(handleTimer:)
                        userInfo:nil
                        repeats:YES];
    

}
-(void) handleTimer:(NSTimer*) timered {
    self.count++;
    float f = self.count;
    if(self.count<=100) {
        [self.secondLabel setText: [NSString stringWithFormat: @"%0.1f", f/10]]; //edit
        [self.timer setProgress: (float) self.count/100];
        
    }
    else {
        [self.actualTimer invalidate];
        [self.recorder stop];
        self.actualTimer = nil;
        
    }
    
    
}

- (IBAction)recordingStop:(id)sender {
    [self.recorder stop];
    [self.actualTimer invalidate];
    self.actualTimer = nil;
   
    if([[NSFileManager defaultManager] fileExistsAtPath: self.currentRecording.path]){
        NSLog(@"file exists");
        
    }else{
        NSLog(@"File does not exist");
    }
    

    
    
}
-(void) viewWillDisappear:(BOOL)animated
{
    
    NSString* archive = [NSString stringWithFormat:@"%@/Documents/arrayArchive", NSHomeDirectory()];
    
    [NSKeyedArchiver archiveRootObject:self.listOfRecordings toFile: archive];
    NSLog(@"saved");
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TableViewController* tvc = (TableViewController*)segue.destinationViewController;
    tvc.otherListOfRecording = self.listOfRecordings;
    
}



@end
