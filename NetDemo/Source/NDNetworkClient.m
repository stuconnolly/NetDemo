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
#import "NDNetworkMessage.h"
#import "NDLogger.h"
#import "NDConstants.h"

@interface NDNetworkClient (PrivateAPI)

@property (readwrite, assign) BOOL isConnected;

@end

@implementation NDNetworkClient

@synthesize delegate;
@synthesize isConnected;

#pragma mark -
#pragma mark Initialization

/**
 * Init.
 */
- (id)init
{
	if ((self = [super init])) {
		isConnected = NO;
		
		_services = [[NSMutableArray alloc] init];
		_browser = [[NSNetServiceBrowser alloc] init];
		
		[_browser setDelegate:self];
	}
	
	return self;
}

#pragma mark -
#pragma mark Public API

/**
 * Start the search for available services.
 */
- (void)search
{	
	[_browser searchForServicesOfType:[NSString stringWithFormat:@"_%@._%@.", NDServerServiceType, NDServerTransmissionProtocol] inDomain:@""];
}

/**
 * Connect to the last service found.
 */
- (void)connect
{
	NSNetService *service = [_services lastObject];
    
	[service setDelegate:self];
	
    [service resolveWithTimeout:10.0];
}

/**
 * Sends the supplied message to the connected server.
 *
 * @param message The message that is to be sent
 */
- (void)sendMessage:(NSString *)message
{
	if (_broker && [_socket isConnected]) {
		// Send the UTF-8 encoded message via the message broker
		[_broker sendMessage:[NDNetworkMessage messageWithData:[message dataUsingEncoding:NSUTF8StringEncoding] date:[NSDate date]]];
	}
}

#pragma mark -
#pragma mark Socket delegate methods

- (BOOL)onSocketWillConnect:(AsyncSocket *)socket 
{
	NDLog(self, @"Client socket about to connect: %@", socket);
	
    if ((!isConnected) && (!_broker)) {
        [socket retain];
        
		return YES;
    }
	
    return NO;
}

- (void)onSocketDidDisconnect:(AsyncSocket *)socket
{
    NDLog(self, @"Client socket disconnected: %@", socket);
	
	isConnected = NO;
}

- (void)onSocket:(AsyncSocket *)socket didConnectToHost:(NSString *)hostName port:(UInt16)hostPort 
{      
	NDLog(self, @"Client socket connected to host '%@' on port %d", hostName, hostPort);
	
    NDMessageBroker *broker = [[NDMessageBroker alloc] initWithSocket:socket];
	
	NDLog(self, @"Client created communication broker %@ with socket on host %@, port %d", broker, [socket connectedHost], [socket connectedPort]);
	
	[socket release];
    
	[broker setDelegate:self];
	
	if (_broker) [_broker release], _broker = nil;
    
	_broker = broker;
    
	isConnected = YES;
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)error
{
	NDLogError(self, @"Client socket disconnected with error: %@", error);
}

#pragma mark -
#pragma mark NSNetServiceBrowser delegate methods

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didFindDomain:(NSString *)domainName moreComing:(BOOL)moreDomainsComing
{
	NDLog(self, @"Client found service in domain '%@'", domainName);
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didRemoveDomain:(NSString *)domainName moreComing:(BOOL)moreDomainsComing
{
	NDLog(self, @"Client removed service in domain '%@'", domainName);
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didFindService:(NSNetService *)service moreComing:(BOOL)moreServicesComing
{
	// Check that the name of the service we just found doesn't have a suffix of our process ID. If it does
	// then it's our server and we don't want to connect to it.
	if (![[service name] hasSuffix:[[NSNumber numberWithInt:[[NSProcessInfo processInfo] processIdentifier]] stringValue]]) {
		NDLog(self, @"Client found service '%@' of type '%@' in domain '%@'", [service name], [service type], [service domain]);
		
		[_services addObject:service];
	}
	
	// If there are no more servers to be supplied then stop searching
	if (([_services count] > 0) && (!moreServicesComing)) {
		
		// Stop looking for services
		[netServiceBrowser stop];
		
		// Inform the delegate that we found a service
		if (delegate && [delegate respondsToSelector:@selector(networkClient:didFindServices:)]) {
			[delegate networkClient:self didFindServices:_services];
		}
	}
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didRemoveService:(NSNetService *)service moreComing:(BOOL)moreServicesComing
{
	NDLog(self, @"Client removed service '%@' of type '%@' in domain '%@'", [service name], [service type], [service domain]);
	
	[_services removeObject:service];
	
    if (service == _connectedService) [self setIsConneced:NO];
}

- (void)netServiceBrowserWillSearch:(NSNetServiceBrowser *)netServiceBrowser
{
	NDLog(self, @"Client starting to search for services");
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didNotSearch:(NSDictionary *)error
{
	NDLog(self, @"Client failed to search for services. Error %@", [error objectForKey:NSNetServicesErrorCode]);
}

- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)netServiceBrowser
{
	NDLog(self, @"Client stopped searching for services");
}

#pragma mark -
#pragma mark NSNetService delegate methods

- (void)netServiceDidResolveAddress:(NSNetService *)service 
{
	NDLog(self, @"Client resolved service '%@' of type '%@' in domain '%@' from host '%@'", [service name], [service type], [service domain], [service hostName]);
	
    NSError *error = nil;
    
	_connectedService = service;
	
	if (_socket) [_socket release], _socket = nil;
    
	_socket = [[AsyncSocket alloc] initWithDelegate:self];
    	
	[_socket connectToAddress:[[service addresses] lastObject] error:&error];
		
	if (error) NDLogError(self, @"Client failed to creat socket connection to server. Error: %@", error);
}

- (void)netService:(NSNetService *)service didNotResolve:(NSDictionary *)error
{
	NDLogError(self, @"Failed to resolve service. Error: %@", [error objectForKey:NSNetServicesErrorCode]);
}

#pragma mark -
#pragma mark Other

/**
 * Dealloc.
 */
- (void)dealloc
{
	_connectedService = nil;
	
	if ([_socket isConnected]) [_socket disconnect];
	
	[_services release], _services = nil;
	[_browser release], _browser = nil;
	
	[super dealloc];
}

@end
