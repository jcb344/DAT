//
//  DATQue.m
//  DAT
//
//  Created by Jacob  Balthazor on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DATQue.h"

@implementation DATQue
@synthesize isFixedMode;
@synthesize startAngle;
@synthesize endAngle;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.opaque = YES;
        self.backgroundColor = [UIColor clearColor];
        PI = 3.14159;
        
        // Defaults
        queColorInside = [UIColor greenColor];
        queColorOutside = [UIColor redColor];
        unsertainty = .5;
        angle = 1;
        isCross = YES;
        isFixedMode = NO;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (isCross) {
        
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, rect.size.width/2, rect.size.height*.25);
        CGContextAddLineToPoint(context, rect.size.width/2, rect.size.height*(1-.25));
        CGContextStrokePath(context);
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, rect.size.width*.25, rect.size.height/2);
        CGContextAddLineToPoint(context, rect.size.width*(1-.25), rect.size.height/2);
        CGContextStrokePath(context);
        
    }
    else {
        if (!isFixedMode) {
            int range = unsertainty*360;
            int plus = arc4random()%range;
            int minus = range-plus;
            endAngle = PI/180*angle+PI/180*plus;
            startAngle = PI/180*angle-PI/180*minus;
        }
        
        
        //NSLog(@"range:%d,plus:%d,minus:%d",range,plus,minus);
        //NSLog(@"start:%f end:%f",startAngle,endAngle);
        
        
        CGContextSetLineWidth(context, 80);
        
        // Draw inside
        
        CGContextSetFillColorWithColor(context, queColorInside.CGColor);
        CGContextMoveToPoint(context, rect.size.width/2, rect.size.height/2);
        CGContextAddArc(context, rect.size.width/2, rect.size.width/2, rect.size.height/2, startAngle, 1*endAngle, 0);
        CGContextDrawPath(context,kCGPathFill);
         
        // Draw Outside
        
        CGContextSetFillColorWithColor(context, queColorOutside.CGColor);
        CGContextMoveToPoint(context, rect.size.width/2, rect.size.height/2);
        CGContextAddArc(context, rect.size.width/2, rect.size.width/2, rect.size.height/2, startAngle, 1*endAngle, 1);
         
        CGContextDrawPath(context,kCGPathFill);
    }

}

-(void)displayCross {
    isCross = YES;
}
-(void)displayQue {
    isCross = NO;
}

-(BOOL)isCross{
    return isCross;
}

-(void)setInsideColor:(UIColor*)color{
    queColorInside = color;
}
-(void)setOutSideColor:(UIColor*)color {
    queColorOutside = color;
}

-(void)setAngle:(CGFloat)theta {
    angle = theta;
}

-(void)setUnsertainty:(float)percent {
    unsertainty = percent;
}

-(CGFloat)getSartingAngle{
    return startAngle;
}

-(CGFloat)getEndingAngle{
    return endAngle;
}

@end
