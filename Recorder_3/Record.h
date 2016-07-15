//
//  Record.h
//  Recorder_3
//
//  Created by valentina apanassenko on 7/12/16.
//  Copyright (c) 2016 valentina apanassenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Record : NSObject
@property(strong, nonatomic) NSDate* date;
@property(readonly, nonatomic) NSURL* url;
@property(readonly, nonatomic) NSString* name;
@property(readonly, nonatomic) NSString* path;
-(Record*) initWithDate: (NSDate*) aDate;
@end
