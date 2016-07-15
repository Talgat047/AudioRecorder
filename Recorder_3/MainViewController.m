//
//  ViewController.m
//  Recorder_3
//
//  Created by valentina apanassenko on 7/12/16.
//  Copyright (c) 2016 valentina apanassenko. All rights reserved.
//

#import "MainViewController.h"
#import "Record.h"
#import <AVFoundation/AVAudioSession.h>
#import "TableViewController.h"
@interface MainViewController ()

@end

@implementation MainViewController
@synthesize timer;
@synthesize recording;
@synthesize recordingDuration;
@synthesize listOfRecordings;
@synthesize currentRecording;
@synthesize recorder;
@synthesize myProgressView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(MainViewController*) initWithCoder: (NSCoder*) aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    NSString* archive = [NSString stringWithFormat:@"%@/Documents/RecordingArchive", NSHomeDirectory()];
    if([[NSFileManager defaultManager] fileExistsAtPath: archive]){
        self.listOfRecordings = [NSKeyedUnarchiver unarchiveObjectWithFile:archive];
        [[NSFileManager defaultManager] removeItemAtPath:archive error:nil];
    }else{
        NSLog(@"Impossible to open file");
        self.listOfRecordings = [[NSMutableArray alloc] init];
    }
    return self;
}

- (IBAction)stopButtonPressed:(id)sender {
    [self.recorder stop];
    
    [self.timer invalidate];
    self.statusLabel.text = @"Stopped";
    self.myProgressView.progress = 1.0;
    
    if([[NSFileManager defaultManager] fileExistsAtPath: self.currentRecording.path]){
        NSLog(@"File exists");
        
    }else{
        NSLog(@"File does not exist");
    }
}



- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *) aRecorder successfully:(BOOL)flag
{
    NSLog (@"audioRecorderDidFinishRecording:successfully:");
    [self.timer invalidate];
    self.statusLabel.text = @"Stopped";
    self.myProgressView.progress = 1.0;
    
    if([[NSFileManager defaultManager] fileExistsAtPath: self.currentRecording.path]){
        NSLog(@"File exists");
    }else{
        NSLog(@"File does not exist");
    }
    
}

- (IBAction)startButtonPressed:(id)sender {
    {
        AVAudioSession* audioSession = [AVAudioSession sharedInstance];
        NSError* err = nil;
        [audioSession setCategory: AVAudioSessionCategoryRecord error: &err];
        if(err){
            NSLog(@"audioSession: %@ %ld %@",
                  [err domain], [err code], [[err userInfo] description]);
            return;
        }
        err = nil;
        [audioSession setActive:YES error:&err];
        if(err){
            NSLog(@"audioSession: %@ %ld %@",
                  [err domain], [err code], [[err userInfo] description]);
            return;
        }
        
        
        NSMutableDictionary* recordingSettings = [[NSMutableDictionary alloc] init];
        
        [recordingSettings setValue:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
        
        [recordingSettings setValue:@44100.0 forKey:AVSampleRateKey];
        
        [recordingSettings setValue:@1 forKey:AVNumberOfChannelsKey];
        
        [recordingSettings setValue:@16 forKey:AVLinearPCMBitDepthKey];
        
        [recordingSettings setValue:@(NO) forKey:AVLinearPCMIsBigEndianKey];
        
        [recordingSettings setValue:@(NO) forKey:AVLinearPCMIsFloatKey];
        
        [recordingSettings setValue:@(AVAudioQualityHigh)
                             forKey:AVEncoderAudioQualityKey];
        
        
        NSDate* now = [NSDate date];
        
        self.currentRecording = [[Record alloc] initWithDate: now];
        [self.listOfRecordings addObject: self.currentRecording];
        
        NSLog(@"%@",self.currentRecording);
        
        err = nil;
        
        self.recorder = [[AVAudioRecorder alloc]
                         initWithURL:self.currentRecording.url
                         settings:recordingSettings
                         error:&err];
        
        if(!self.recorder){
            NSLog(@"recorder: %@ %ld %@",
                  [err domain], [err code], [[err userInfo] description]);
            UIAlertController* alert = [UIAlertController
                                        alertControllerWithTitle:@"Warning"
                                        message:[err localizedDescription]
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
        [self.recorder setDelegate:self];
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
        
        // start recording
        [self.recorder recordForDuration:(NSTimeInterval)10];
        
        self.statusLabel.text = @"Recording...";
        self.myProgressView.progress = 0.0;
        self.timer = [NSTimer
                      scheduledTimerWithTimeInterval:0.2
                      target:self
                      selector:@selector(handleTimer)
                      userInfo:nil
                      repeats:YES];
        
    }
    
}
-(void) handleTimer
{
    self.myProgressView.progress += .01;
    if(self.myProgressView.progress == 10.0)
    {
        [self.timer invalidate];
        self.statusLabel.text = @"Stopped";
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TableViewController* tvc = (TableViewController*)segue.destinationViewController;
    tvc.listOfRecordings = self.listOfRecordings;
    
}

    @end
    
    
