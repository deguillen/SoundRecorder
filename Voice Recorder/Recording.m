//
//  Recording.m
//  Voice Recorder
//
//  Created by Daniela Guillen on 7/6/16.
//  Copyright © 2016 Daniela Guillen. All rights reserved.
//

#import "Recording.h"

@implementation Recording
@synthesize date;

-(Recording*) initWithDate:(NSDate*) aDate {
    self = [super init];
    if(self) { //makes sure it is not nil
        self.date = aDate;
        
    }
    return self;
    
}

-(NSString*) path { //this is the getter, no setter because it is readonly
    NSString* home = NSHomeDirectory();
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddhhmmss"];
    NSString* dateString = [formatter stringFromDate:self.date];
    return [NSString stringWithFormat:@"%@/Documents/%@.caf", home, dateString];
}

-(NSURL*) url {
    return [NSURL fileURLWithPath:[self path]];
}
- (void)encodeWithCoder:(NSCoder *)encoder
{
    
    [encoder encodeObject: self.date forKey: @"date"];
    
}
- (Recording*)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if(self){
        self.date =  [decoder decodeObjectOfClass: [Recording class] forKey: @"date"];
    }
    return self;
}
-(NSURL*) otherUrl {
    NSString* home = NSHomeDirectory();
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddhhmmss"];
    NSString* dateString = [formatter stringFromDate:self.date];
    NSString* tempPath = [NSString stringWithFormat:@"%@/Documents/%@.m4a", home, dateString];
    return [NSURL fileURLWithPath:tempPath];
}

@end
