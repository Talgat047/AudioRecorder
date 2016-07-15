//
//  Record.m
//  Recorder_3
//
//  Created by valentina apanassenko on 7/12/16.
//  Copyright (c) 2016 valentina apanassenko. All rights reserved.
//

#import "Record.h"

@implementation Record
@synthesize date;



-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    
    self = [super init];
    if(self){
        self.date = [aDecoder decodeObjectOfClass: [Record class] forKey: @"date"];
    }
    return self;
    
}

-(void) encodeWithCoder: (NSCoder*) encoder
{
    [encoder encodeObject: self.date forKey: @"date"];
    
}

-(Record*) initWithDate:(NSDate*) aDate
{
    
    self=[super init];
    if (self) self.date = aDate;
    return self;
}

-(NSString*) path{
    
    NSString* home = NSHomeDirectory();
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString* dateString = [formatter stringFromDate: self.date];
    return [NSString stringWithFormat:@"%@/Documents/%@.caf",home, dateString];
}

-(NSURL*) url {
    return [NSURL URLWithString:self.path];
    
}

-(NSString*) name{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString* dateString = [dateFormatter stringFromDate: self.date];
    return dateString;
}

@end
