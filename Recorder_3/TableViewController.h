//
//  TableViewController.h
//  Recorder_3
//
//  Created by valentina apanassenko on 7/12/16.
//  Copyright (c) 2016 valentina apanassenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Record.h"
#import <AVFoundation/AVFoundation.h>
@interface TableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray* listOfRecordings;
@property (strong, nonatomic) AVAudioPlayer* Audioplayer;
@end
