//
//  obs_box.m
//  AppGame
//
//  Created by Tushar Mangwani on 4/12/14.
//  Copyright (c) 2014 Tushar Mangwani. All rights reserved.
//

#import "obs_box.h"

@implementation obs_box

-(int)getx{
    return [self x];
}

-(int)getr{
    return [self r];
}

-(id)initWithx:(int)ax
             y:(int)ay
              r:(int)ar
{
    
    self=[super init];
    if (self) {
        
    
    _x=ax;
        _y=ay;
        _r=ar;
    }
    
    return self;
}

-(int) gety{
    return [self y];
}
-(int) incrementy{
   self.y = [self gety]-1;
    return [self y];
}

-(void)setIdel:(int)i{
    self.ide = @"%i",i;
}

-(NSString*)getIDe{
    return self.ide;
}


@end
