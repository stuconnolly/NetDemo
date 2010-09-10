/*
 *  $Id$
 *
 *  NetDemo
 *  http://stuconnolly.com/projects/code/
 *
 *  Copyright (c) 2010 Stuart Connolly. All rights reserved.
 *
 *  Permission is hereby granted, free of charge, to any person
 *  obtaining a copy of this software and associated documentation
 *  files (the "Software"), to deal in the Software without
 *  restriction, including without limitation the rights to use,
 *  copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the
 *  Software is furnished to do so, subject to the following
 *  conditions:
 *
 *  The above copyright notice and this permission notice shall be
 *  included in all copies or substantial portions of the Software.
 * 
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 *  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 *  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 *  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 *  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 *  OTHER DEALINGS IN THE SOFTWARE.
 */

#import "NDNetworkClient.h"

@interface NDNetworkClient (PrivateAPI)

@property (readwrite, assign) BOOL isConnected;

@end

@implementation NDNetworkClient

@synthesize isConnected;

#pragma mark -
#pragma mark Initialization

/**
 * Init.
 */
- (id)init
{
	if ((self = [super init])) {
		[self setIsConnected:NO];
		
		_services = [[NSMutableArray alloc] init];
		_browser = [[NSNetServiceBrowser alloc] init];
		
		[_browser setDelegate:self];
	}
}

#pragma mark -
#pragma mark Public API

/**
 * Start the search for available services.
 */
- (void)search
{
	[_browser searchForServicesOfType:@"_netdemo_.tcp." inDomain:@""];
}

/**
 *
 */
- (BOOL)connect
{
	NSNetService *service = [_services lastObject];
    
	[service setDelegate:self];
	
    [service resolveWithTimeout:0];
}

#pragma mark -
#pragma mark NSNetServiceBrowser delegate methods

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didFindDomain:(NSString *)domainName moreComing:(BOOL)moreDomainsComing
{
	
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didRemoveDomain:(NSString *)domainName moreComing:(BOOL)moreDomainsComing
{
	
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didFindService:(NSNetService *)service moreComing:(BOOL)moreServicesComing
{
	[_services addObject:service];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didRemoveService:(NSNetService *)service moreComing:(BOOL)moreServicesComing
{
	[_services removeObject:service];
	
    if (service == _connectedService) [self setIsConneced:NO];
}

- (void)netServiceBrowserWillSearch:(NSNetServiceBrowser *)netServiceBrowser
{
	
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didNotSearch:(NSDictionary *)error
{
	
}

- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)netServiceBrowser
{
	
}

#pragma mark -
#pragma mark NSNetService delegate methods

- (void)netServiceDidResolveAddress:(NSNetService *)service
{
	[self setIsConnected:YES];
	
    _connectedService = service;
}

- (void)netService:(NSNetService *)service didNotResolve:(NSDictionary *)error
{
	NSLog(@"Could not resolve service: %@", error);
}

#pragma mark -
#pragma mark Other

/**
 * Dealloc.
 */
- (void)dealloc
{
	_connectedService = nil;
	
	[_services release], _services = nil;
	[_browser release], _browser = nil;
	
	[super dealloc];
}

@end
