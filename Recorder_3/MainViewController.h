//
//  ViewController.h
//  Recorder_3
//
//  Created by valentina apanassenko on 7/12/16.
//  Copyright (c) 2016 valentina apanassenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Record.h"
#import <AVFoundation/AVFoundation.h>
@interface MainViewController : UIViewController <AVAudioRecorderDelegate>

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) NSTimer* timer;
@property (strong, nonatomic) NSMutableArray* listOfRecordings;
@property (strong, nonatomic) AVAudioSession* recording;
@property (strong, nonatomic) AVAudioRecorder* recordingDuration;
@property (weak, nonatomic) IBOutlet UIProgressView *myProgressView;
@property (strong, nonatomic) AVAudioRecorder* recorder;
@property (strong, nonatomic) Record* currentRecording;
- (IBAction)startButtonPressed:(id)sender;

- (IBAction)stopButtonPressed:(id)sender;


@end

