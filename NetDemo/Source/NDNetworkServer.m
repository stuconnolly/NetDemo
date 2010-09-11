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

#import "NDNetworkServer.h"
#import "NDMessageBroker.h"
#import "NDNetworkMessage.h"
#import "NDConstants.h"
#import "NDLogger.h"

@implementation NDNetworkServer

@synthesize delegate;

#pragma mark -
#pragma mark Initialization

/**
 * Init.
 */
- (id)init
{
	if ((self = [super init])) {
		
		_serviceRunning = NO;		
	}
	
	return self;
}

#pragma mark -
#pragma mark Public API

/**
 * Starts the network server by creating a socket to listen for connections and publishing the service via
 * Bonjour (Zeroconf).
 */
- (BOOL)startService
{
	if (!_serviceRunning) {
		
		// Create and start the server's listening socket
		NSError *error;
	
		_listeningSocket = [[AsyncSocket alloc] initWithDelegate:self];
		
		NDLog(self, @"Starting server listening socket");
		
		if (![_listeningSocket acceptOnPort:(port) ? port : 0 error:&error] ) {
			NDLogError(self, @"Failed to create listening socket. Error: %@", [error localizedDescription]);
						
			return NO;
		}
				
		NDLog(self, @"Server is now listening for connections");
		NDLog(self, @"Publishing Bonjour (Zeroconf) service to advertise server on port %d.", [_listeningSocket localPort]);
		
		NSString *serviceName = [NSString stringWithFormat:@"NetDemo-%@-%d", [[NSProcessInfo processInfo] hostName], [[NSProcessInfo processInfo] processIdentifier]];
		
		// Advertise the service with Bonjour
		_service = [[NSNetService alloc] initWithDomain:NDServiceServiceDomain type:[NSString stringWithFormat:@"_%@._%@.", NDServerServiceType, NDServerTransmissionProtocol] name:serviceName port:[_listeningSocket localPort]];
		
		if (_service) {
			[_service setDelegate:self];
			[_service publish];
		}
		else {
			NDLogError(self, @"Error initializing NSNetService instance");
		}
		
		_serviceRunning = YES;
	}
	
	return _serviceRunning;
}

/**
 * Stops the network server.
 */
- (BOOL)stopService
{
	if (_serviceRunning) {
		
		if (_listeningSocket) {
			[_listeningSocket release], _listeningSocket = nil; 
		}
		
		_connectionSocket = nil;
		
		_broker = nil;
		
		[_service stop];
		[_service release], _service = nil;
		
		_serviceRunning = NO;
	}
	
	return _serviceRunning;
}

#pragma mark -
#pragma mark NSNetService delegate methods

- (void)netServiceWillPublish:(NSNetService *)service
{
	NDLog(self, @"Publising server service '%@' on domain '%@'.", [service name], [service domain]);
}

- (void)netService:(NSNetService *)service didNotPublish:(NSDictionary *)error
{
	NDLogError(self, @"Failed to publish server service. Error code %@", [error objectForKey:NSNetServicesErrorCode]);
}

- (void)netServiceDidPublish:(NSNetService *)service
{
	NDLog(self, @"Published server service '%@' on domain '%@'.", [service name], [service domain]);
}

- (void)netServiceDidStop:(NSNetService *)service
{
	NDLog(self, @"Stopped server service '%@' on domain '%@'.", [service name], [service domain]);
}

#pragma mark -
#pragma mark Socket delegate methods

-(BOOL)onSocketWillConnect:(AsyncSocket *)socket
{
	NDLog(self, @"Server socket about to connect: %@", socket);
	
    if (!_connectionSocket) {
        _connectionSocket = socket;
        
		return YES;
    }
	
    return NO;
}

- (void)onSocketDidDisconnect:(AsyncSocket *)socket 
{
	NDLog(self, @"Server socket disconnected: %@", socket);
	
    if (socket == _connectionSocket) {
        _connectionSocket = nil;
        _broker = nil;
    }
}

- (void)onSocket:(AsyncSocket *)socket didConnectToHost:(NSString *)hostName port:(UInt16)hostPort 
{
	NSLog(@"socket connect to host");
	
	/*NDMessageBroker *newBroker = [[[NDMessageBroker alloc] initWithAsyncSocket:socket] autorelease];
    
	[newBroker setDelegate:self];
    
	_broker = newBroker;*/
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)error
{
	NDLogError(self, @"Server socket error: %@", error);
}

#pragma mark -
#pragma mark Broker delegate methods

- (void)messageBroker:(NDMessageBroker *)server didReceiveMessage:(NDNetworkMessage *)message
{	
	if (delegate && [delegate respondsToSelector:@selector(networkServer:didRecieveMessage:)]) {
		[delegate networkServer:self didRecieveMessage:message];
	}
}

#pragma mark -
#pragma mark Other

/**
 * Dealloc.
 */
- (void)dealloc
{
	[self stopService];
		
	[super dealloc];
}

@end
