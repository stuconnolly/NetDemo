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
 *
 */
- (BOOL)startService
{
	if (!_serviceRunning) {
		
		// Create and start the server's listening socket
		NSError *error;
	
		_listeningSocket = [[[AsyncSocket alloc] initWithDelegate:self] autorelease];
		
		if (![_listeningSocket acceptOnPort:0 error:&error] ) {
			[NDLogger logError:[NSString stringWithFormat:@"Failed to created listening socket. Error: %@", [error localizedDescription]]];
			
			return NO;
		}
		
		// Advertise the service with Bonjour
		_service = [[NSNetService alloc] initWithDomain:@"local." type:@"_netdemo_.tcp." name:@"" port:1987];
		
		[_service setDelegate:self];
		[_service publish];
		
		_serviceRunning = YES;
	}
	
	return _serviceRunning;
}

/**
 *
 */
- (BOOL)stopService
{
	if (_serviceRunning) {
		_listeningSocket = nil;
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
	
}

- (void)netService:(NSNetService *)service didNotPublish:(NSDictionary *)error
{
	[NDLogger logError:[NSString stringWithFormat:@"Failed to publish service. Error (%@): %@", [error objectForKey:NSNetServicesErrorCode], [error objectForKey:NSNetServicesErrorDomain]]];
}

- (void)netServiceDidPublish:(NSNetService *)service
{
	
}

- (void)netServiceWillResolve:(NSNetService *)service
{
	
}

- (void)netService:(NSNetService *)service didNotResolve:(NSDictionary *)error
{
	
}

- (void)netServiceDidResolveAddress:(NSNetService *)service
{
	
}

- (void)netServiceDidStop:(NSNetService *)service
{
	
}

#pragma mark -
#pragma mark Socket delegate methods

-(BOOL)onSocketWillConnect:(AsyncSocket *)socket
{
    if (!_connectionSocket) {
        _connectionSocket = socket;
        
		return YES;
    }
	
    return NO;
}

-(void)onSocketDidDisconnect:(AsyncSocket *)socket 
{
    if (socket == _connectionSocket) {
        _connectionSocket = nil;
        _broker = nil;
    }
}

- (void)onSocket:(AsyncSocket *)socket didConnectToHost:(NSString *)host port:(UInt16)port 
{
	NDMessageBroker *newBroker = [[[NDMessageBroker alloc] initWithAsyncSocket:socket] autorelease];
    
	[newBroker setDelegate:self];
    
	_broker = newBroker;
}

#pragma mark -
#pragma mark Broker delegate methods

- (void)messageBroker:(NDMessageBroker *)server didReceiveMessage:(NDNetworkMessage *)message
{
	NSLog(@"received, sending to delegate.");
	
	
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
