//
//  GAZZCloud.h
//  DAT
//
//  Created by Jacob Balthazor on 3/21/13.
//
//

#import <Foundation/Foundation.h>

@interface GAZZCloud : NSObject <NSURLConnectionDelegate,NSURLConnectionDataDelegate> {
    id deligate;
    NSMutableData *receivedData;
    NSURLConnection *theConnection;
}

@property (nonatomic,retain) NSString *subjectID;
@property (nonatomic,retain) NSString *studyID;

-(NSString*)JSONForArray:(NSArray*)array;
-(BOOL)postString:(NSString*)string toAdress:(NSString*)adress;

-(void)postJSONOf:(NSArray*)array toAdress:(NSString*)adress;
-(void)postJSONString:(NSString*)array toAdress:(NSString*)adress;

-(void)receivedData:(NSData*)data;
-(void)emptyReply;
-(void)timedOut;
-(void)downloadError:(NSError*)error;

-(void)setDeligate:(id)d;

@end
