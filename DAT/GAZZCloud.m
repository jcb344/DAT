//
//  GAZZCloud.m
//  DAT
//
//  Created by Jacob Balthazor on 3/21/13.
//
//

#import "GAZZCloud.h"

@implementation GAZZCloud

-(void)postJSONOf:(NSArray*)array toAdress:(NSString*)adress{
    [self postString:[self JSONForArray:array] toAdress:adress];
}

-(BOOL)postString:(NSString*)string toAdress:(NSString*)adress{
    BOOL sucsess = NO;
    
    NSData *postData = [ [NSString stringWithFormat:@"%@",string]  dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest requestWithURL:[NSURL URLWithString:adress] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60] autorelease];
    //[request setURL:[NSURL URLWithString:adress]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    //[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"MyApp-V1.0" forHTTPHeaderField:@"User-Agent"];
    [request setHTTPBody:postData];
    [theConnection release];
    theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    if (theConnection) {
        sucsess = YES;
        receivedData = [[NSMutableData data] retain];
    } else {
        sucsess = NO;
    }
    return sucsess;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
    [connection release];
    [receivedData release];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if ([response respondsToSelector:@selector(statusCode)])
    {
        int statusCode = [((NSHTTPURLResponse *)response) statusCode];
        if (statusCode == 404)
        {
            [connection cancel];  // stop connecting; no more delegate messages
            NSLog(@"Error statusCode %i", statusCode);
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
    
    NSString *response = [[NSString alloc] initWithData:receivedData encoding:NSASCIIStringEncoding];
    NSLog(response);
    // release the connection, and the data object
    //[connection release];
    [receivedData release];
}


-(NSString*)JSONForArray:(NSArray*)array{
    
    NSString *outString = @"{\n\"data\": [";
    for (int i = 0; i<[array count]-1; i++) {
        outString = [outString stringByAppendingString:@"\n\t{"];
        
        NSArray *keys = [[array objectAtIndex:i] allKeys];
        
        for (int j = 0; j<[keys count]; j++) {
            if (j != ([keys count]-1) ) {
                outString = [outString stringByAppendingFormat:@" \"%@\":%f,",[keys objectAtIndex:j],[[[array objectAtIndex:i] objectForKey:[keys objectAtIndex:j]] floatValue]];
            }
            else{
                outString = [outString stringByAppendingFormat:@" \"%@\":%f",[keys objectAtIndex:j],[[[array objectAtIndex:i] objectForKey:[keys objectAtIndex:j]] floatValue]];
            }
        }
        if (i != ([array count]-2) ) {
            outString = [outString stringByAppendingString:@"},"];
        }
        else{
            outString = [outString stringByAppendingString:@"}"];
        }
    }
    outString = [outString stringByAppendingString:@"\n]\n}"];
    return outString;
}

@end
