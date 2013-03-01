//
//  DATQue.h
//  DAT
//
//  Created by Jacob  Balthazor on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/CoreAnimation.h>



@interface DATQue : UIView{
    
    CGFloat PI;
    
    UIColor *queColorInside;
    UIColor *queColorOutside;
    
    CGFloat startAngle;
    CGFloat endAngle;
    
    CGFloat angle;
    float unsertainty;
    
    BOOL isCross;
    
    BOOL isFixedMode;
}

@property (assign) BOOL isFixedMode;
@property (assign) float startAngle;
@property (assign) float endAngle;


-(void)setInsideColor:(UIColor*)color;
-(void)setOutSideColor:(UIColor*)color;

-(void)setAngle:(CGFloat)theta;
-(void)setUnsertainty:(float)percent;
-(CGFloat)getSartingAngle;
-(CGFloat)getEndingAngle;

-(void)displayCross;
-(void)displayQue;
-(BOOL)isCross;


@end
