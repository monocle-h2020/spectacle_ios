//
//  MoonPhase.h
//  Mijn Hemel
//
//  Created by Norbert Schmidt on 26-11-12.
//  Copyright (c) 2012 Norbert Schmidt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoonPhase : NSObject {
@private
	NSDate *now;
}

- (float) phase;
- (float) elongation;

@end




