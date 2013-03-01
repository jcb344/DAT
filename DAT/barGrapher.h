//
//  barGrapher.h
//  MediTrain
//
//  Created by Jacob Balthazor on 12/18/12.
//
//

#import <UIKit/UIKit.h>

@interface barGrapher : UIView{
    NSArray *data;
    NSArray *bars;
    
    UILabel *maxTimeLabel;
    UILabel *minTImeLabel;
    
    UIColor *color;
    BOOL forceMax;
    int minS;
    int maxS;
}

@property (nonatomic,retain) NSString *startDate;
@property (nonatomic,retain) NSString *endDate;

-(void)graphData:(NSArray*)d;
-(void)setColor:(UIColor*)c;
-(void)setMax:(int)m;
-(void)setMin:(int)m;
-(void)setforceMax:(BOOL)t;
-(int)max;
-(int)min;

@end
