//
//  Recording.h
//  Voice Recorder
//
//  Created by Daniela Guillen on 7/6/16.
//  Copyright © 2016 Daniela Guillen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Recording : NSObject
@property (strong,nonatomic) NSDate* date;
@property (readonly, nonatomic) NSURL* otherUrl; 


@property (readonly, nonatomic) NSString* path;

@property (readonly, nonatomic) NSURL* url;
- (Recording*) initWithDate: (NSDate*) aDate;

@end
