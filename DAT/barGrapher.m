//
//  barGrapher.m
//  MediTrain
//
//  Created by Jacob Balthazor on 12/18/12.
//
//

#import "barGrapher.h"

@implementation barGrapher
@synthesize startDate,endDate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        /*
        maxTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [maxTimeLabel setText:@"test"];
        [maxTimeLabel setTextColor:[UIColor whiteColor]];
        
        [self addSubview:maxTimeLabel];
         */
        forceMax = NO;
        color = [[UIColor whiteColor] retain];
        
    }
    return self;
}

-(void)setMax:(int)m{
    maxS = m;
}
-(void)setMin:(int)m{
    minS = m;
}

-(void)setforceMax:(BOOL)t{
    forceMax = t;
}

-(void)setColor:(UIColor*)c{
    [color release];
    color = c;
    [color retain];
}

-(void)graphData:(NSArray*)d{
    data = d;
}

-(int)max{
    int max = 0;
    for (int i = 0; i < [data count]; i++) {
        if ([[data objectAtIndex:i] intValue] > max) {
            max = [[data objectAtIndex:i] intValue];
        }
    }
    if (forceMax == TRUE) {
        max = maxS;
    }
    return max;
}
-(int)min{
    int min = INT32_MAX;
    for (int i = 0; i < [data count]; i++) {
        if ([[data objectAtIndex:i] intValue] < min) {
            min = [[data objectAtIndex:i] intValue];
        }
    }
    if (forceMax == TRUE) {
        min = minS;
    }
    return min;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if ([data count] > 0) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, color.CGColor);
         CGContextSetLineWidth(context, 2.0);
        
        for (int i = 0; i < [data count]-1; i++) {
            float fi = i;
            float fcount = [data count] - 1;
            float fdata = [[data objectAtIndex:i] floatValue];
            float fdata2 = [[data objectAtIndex:i+1] floatValue];
            float max = [self max];

            CGContextBeginPath(context);
            CGContextMoveToPoint(context, rect.size.width*(fi/fcount), rect.size.height-rect.size.height*(fdata/max));
            CGContextAddLineToPoint(context, rect.size.width*((fi+1.f)/fcount),rect.size.height-(rect.size.height*(fdata2/max)));
            
            CGContextStrokePath(context);
        }
    }
}


@end
