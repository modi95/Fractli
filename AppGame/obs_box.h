//
//  obs_box.h
//  AppGame
//
//  Created by Tushar Mangwani on 4/12/14.
//  Copyright (c) 2014 Tushar Mangwani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface obs_box : NSObject

-(int)getx;
-(int)getr;
-(int)incrementy;

-(id)initWithx:(int)ax
             y:(int)ay
             r:(int)ar;


@property   int x;
@property int y;
@property int r;
@property NSString* ide;

-(int)gety;

-(void)setIdel:(int)i;
-(NSString*)getIDe;

@end
