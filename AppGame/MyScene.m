//
//  MyScene.m
//  AppGame
//
//  Created by Tushar Mangwani on 4/12/14.
//  Copyright (c) 2014 Tushar Mangwani. All rights reserved.
//

#import "MyScene.h"
#import "obs_box.h"

@implementation MyScene

int count = 0;
double jradius;
double mradius;
double oradius;

-(id)initWithSize:(CGSize)size {
    if(self = [super initWithSize:size] ) {
        SKSpriteNode *bg1 = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
        bg1.position = CGPointMake(self.size.width/2, self.size.height/2);
        bg1.xScale = 0.50;
        bg1.yScale = bg1.xScale;
        bg1.name = @"bg1";
        [self addChild:bg1];
        SKAction *pulseRed = [SKAction sequence:@[
                                                  [SKAction colorizeWithColor:[SKColor redColor] colorBlendFactor:1.0 duration:1.0],
                                                  [SKAction waitForDuration:0.0],
                                                  [SKAction colorizeWithColorBlendFactor:0.0 duration:2.0]]];     [bg1 runAction: pulseRed];

        
        /*SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        myLabel.text = score;
        myLabel.fontSize = 10;
        myLabel.position = CGPointMake(300, 500);
        [self addChild:myLabel];*/
        
        [self addChild: [self createJulia]  ];
        [self addChild: [self createMandelbrot]  ];
        
        [self performSelector:@selector(createObstacle) withObject:nil afterDelay:2.0];
    }
    return self;
}

-(SKSpriteNode*) createJulia{
    SKSpriteNode *Julia = [SKSpriteNode spriteNodeWithImageNamed:@"Julia"];
    Julia.position = CGPointMake (999, 100);
    jradius = 29.7222222222;
    Julia.xScale = 0.4;
    Julia.yScale = Julia.xScale;
    Julia.name = @"Julia";
    Julia.zPosition = 0;
    return  Julia;
}
-(SKSpriteNode*) createMandelbrot{
    SKSpriteNode *Mandelbrot = [SKSpriteNode spriteNodeWithImageNamed:@"Mandelbrot"];
    Mandelbrot.position = CGPointMake(999, 300);
    mradius = 29.7222222222;
    Mandelbrot.xScale = 0.4;
    Mandelbrot.yScale = Mandelbrot.xScale;
    Mandelbrot.name = @"Mandelbrot";
    Mandelbrot.zPosition = 0;
    return  Mandelbrot;
}

-(void) createObstacle {
    int lowerBound = 0;
    int upperBound = 300;
    int rndValue = lowerBound + arc4random_uniform(upperBound - lowerBound);
    double size = (arc4random_uniform(150));
    CGPoint startPoint = CGPointMake(rndValue,650);
    
    
    SKSpriteNode *Obstacle = [SKSpriteNode spriteNodeWithImageNamed:@"Obstacle"];
    Obstacle.position = CGPointMake( startPoint.x, startPoint.y );
    Obstacle.name = @"Obstacle";
    Obstacle.xScale =0.05 + (size/1000);
    Obstacle.yScale = Obstacle.xScale;
    Obstacle.zPosition = 0;
    Obstacle.zRotation = 1.0;
    [self addChild:Obstacle];
    
    
    // after adding the children, we want to call this same method again at a random interval
    
    float randomNum = arc4random_uniform(3)+ 3;
    [self performSelector:@selector(createObstacle) withObject:nil afterDelay:randomNum];
    
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    SKNode* Julia = [self childNodeWithName:@"Julia"];
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        [Julia setPosition:CGPointMake(location.x, 100)];
    }
    
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    int touchCount = 0;
    SKNode* Julia = [self childNodeWithName:@"Julia"];
    SKNode* Mandelbrot = [self childNodeWithName:@"Mandelbrot"];
    for (UITouch *touch in touches) {
        touchCount++;
        if (touchCount==1){
            CGPoint location = [touch locationInNode:self];
            if (location.y<200)
            [Julia setPosition:CGPointMake(location.x, 100)];
        }
        else if (touchCount==2){
            CGPoint location = [touch locationInNode:self];
            if (location.y>200)
            [Mandelbrot setPosition:CGPointMake(location.x, 300)];
        }
    }
}


-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered
    
    SKNode* Julia = [self childNodeWithName:@"Julia"];
    SKNode* Mandelbrot = [self childNodeWithName:@"Mandelbrot"];
    [self enumerateChildNodesWithName:@"Obstacle" usingBlock:^(SKNode *node, BOOL *stop) {
        double originalradius = 294.4954128;
        oradius = originalradius * node.xScale;
        // do something if boulder is found
        
        if (node.position.y < 0) {
            
            [node removeFromParent];
        }
        
        else {
            int t = currentTime;
            double pulserate = 0.005;
                if(t % 2){
                node.xScale = node.xScale * (1 - pulserate);
                node.yScale = node.xScale;
                }
                else{
                node.XScale = node.xScale *(1 + pulserate);
                node.yScale = node.xScale;
                }
            
            double rotationalspeed = 0.1;
            node.zRotation = node.zRotation + rotationalspeed;
            
            node.position = CGPointMake(node.position.x, node.position.y - 1);
            
        }
        //change colision to equation with radius of xscale/2 see if an image.size thingy exists
       /*if ( [Julia intersectsNode:node]) {
            
            [self gameOver];
            NSLog(@" YOU SUCK AT THIS");
        }
        if ( [Mandelbrot intersectsNode:node]) {
            
            [self gameOver];
            NSLog(@" YOU SUCK AT THIS");
        }*/
        if ((sqrt(pow((Julia.position.x - node.position.x),2) + pow((Julia.position.y - node.position.y),2)) < jradius + oradius) || (sqrt(pow((Mandelbrot.position.x - node.position.x),2) + pow((Mandelbrot.position.y - node.position.y),2)) < mradius + oradius)) {

            [self gameOver];
        }
        else{
            count++;
        }
        

    }];

    }

-(void) gameOver {
    count = 0;
    SKScene *nextScene = [[MyScene alloc] initWithSize:self.size];
    SKTransition *doors = [SKTransition doorsOpenVerticalWithDuration:0.5];
    [self.view presentScene:nextScene transition:doors];
}


@end
