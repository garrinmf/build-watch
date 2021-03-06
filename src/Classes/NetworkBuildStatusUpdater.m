//
//  Copyright High Order Bit, Inc. 2009 . All rights reserved.
//

#import "NetworkBuildStatusUpdater.h"

@interface NetworkBuildStatusUpdater (Private)
- (void)setData:(NSData *)someData;
@end


@implementation NetworkBuildStatusUpdater

@synthesize url;
@synthesize delegate;

- (id)initWithUrl:(NSURL *)aUrl
         delegate:(NSObject<BuildStatusUpdaterDelegate> *)aDelegate
{
    if (self = [super init]) {
        url = [aUrl retain];
        delegate = [aDelegate retain];
    }

    return self;
}

- (void) dealloc
{
    [delegate release];
    [url release];
    [connection release];
    [data release];
    [super dealloc];
}

#pragma mark BuildStatusUpdater implementation

- (void) startUpdate
{
    NSAssert(connection == nil, @"Starting an update when an update already "
        "exists.");
    [self setData:[NSData data]];
    NSURLRequest * req = [NSURLRequest requestWithURL:url];
    connection = [[NSURLConnection alloc] initWithRequest:req
                                                 delegate:self
                                         startImmediately:YES];
}

- (void) cancelUpdate
{
    NSLog(@"%@: canceling operation on connection: '%@'.", self, connection);
    [connection cancel];
}

#pragma mark NSURLConnection protocol functions

- (void) connection:(NSURLConnection *)conn didReceiveData:(NSData *)moreData
{
    NSLog(@"Appending data with %d bytes.", moreData.length);
    [data appendData:moreData];
}

/*
- (void) connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {

	NSLog(@"challenged %@",[challenge proposedCredential]);
	
	if ([challenge previousFailureCount] == 0) {
		NSURLCredential *newCredential = [NSURLCredential credentialWithUser:@"USERNAME" password:@"PASSWORD" persistence:NSURLCredentialPersistenceNone];
		
		[[challenge sender] useCredential:newCredential forAuthenticationChallenge:challenge];
	} else {
		[[challenge sender] cancelAuthenticationChallenge:challenge];
		NSLog(@"Invalid Username & Password");
	}
}*/

- (void) connectionDidFinishLoading:(NSURLConnection *)conn
{
    [delegate updater:self didReceiveData:data];
}

- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error
{
    [delegate updater:self didReceiveError:error];
}

#pragma mark Accessors

- (void)setData:(NSData *)someData
{
    NSMutableData * tmp = [someData mutableCopy];
    [data release];
    data = tmp;
}

@end
