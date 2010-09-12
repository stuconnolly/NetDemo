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

#import "NDMessageBroker.h"
#import "NDNetworkMessage.h"
#import "NDLogger.h"

@implementation NDMessageBroker

@synthesize delegate;

#pragma mark -
#pragma mark Initialisation

/**
 * Initialise an instance of NDMessageBroker with the supplied socket.
 *
 * @param socket The socket that the broker should use
 */
- (id)initWithSocket:(AsyncSocket *)socket
{
	if ((self = [super init])) {
		
		if ([socket canSafelySetDelegate]) {
			
			_connectionLostUnexpectedly = NO;
			
			_socket = [socket retain];
			
			[_socket setDelegate:self];
			
			_messageQueue = [[NSMutableArray alloc] init];
			
			[_socket readDataToLength:sizeof(UInt64) withTimeout:1.0 tag:0];
		}
		else {
			self = nil;
		}
		
	}
	
	return self;
}

#pragma mark -
#pragma mark Public API

/**
 *
 *
 * @param message The MDNnetwork message to be send
 */
- (void)sendMessage:(NDNetworkMessage *)message
{
	NDLog(self, @"Message broker sending message: %@", message);
	
	if (_socket == nil) {
		NDLogError(self, @"Broker failed to send message because socket doesn't exist");
		return;
	}
	
	// Add the message to the queue
	[_messageQueue addObject:message];
	
    NSData *messageData = [NSKeyedArchiver archivedDataWithRootObject:message];
    
	UInt64 header[1];
    
	header[0] = [messageData length]; 
	
	// Send header in little endian byte order
    header[0] = CFSwapInt64HostToLittle(header[0]);
    
	[_socket writeData:[NSData dataWithBytes:header length:sizeof(UInt64)] withTimeout:1.0 tag:(long)0];
    [_socket writeData:messageData withTimeout:1.0 tag:(long)1];
}

#pragma mark -
#pragma mark Socket delegate methods

- (void)onSocketDidDisconnect:(AsyncSocket *)socket
{
	NDLog(self, @"Broker socket disconnected: %@", socket);
	
    if (_connectionLostUnexpectedly) {
        if (delegate && [delegate respondsToSelector:@selector(messageBrokerDidDisconnectUnexpectedly:)] ) {
            [delegate messageBrokerDidDisconnectUnexpectedly:self];
        }
    }
}

- (void)onSocket:(AsyncSocket *)socket willDisconnectWithError:(NSError *)error 
{
	NDLogError(self, @"Broker socket disconnected with error: %@", [error localizedDescription]);
	
    _connectionLostUnexpectedly = YES;
}

- (void)onSocket:(AsyncSocket *)socket didReadData:(NSData *)data withTag:(long)tag 
{
	NDLog(self, @"Broker reading message data of length %d bytes", [data length]);
	
	// Data header
    if (tag == 0) {
		NDLog(self, @"Broker reading message data header");
		
        UInt64 header = *((UInt64*)[data bytes]);
		
		// Convert from little endian to native
        header = CFSwapInt64LittleToHost(header); 
		
        [socket readDataToLength:(CFIndex)header withTimeout:1.0 tag:(long)1];
    }
	// Data body
    else if (tag == 1) { 
		NDLog(self, @"Broker reading message data body");
		
        if (delegate && [delegate respondsToSelector:@selector(messageBroker:didReceiveMessage:)]) {
            [delegate messageBroker:self didReceiveMessage:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
        }        
    }
    else {
        NDLogError(self, @"Unknown tag when reading socket data: %d", tag);
    }
}

- (void)onSocket:(AsyncSocket *)socket didWriteDataWithTag:(long)tag 
{
    if (tag == 1) {
        NDNetworkMessage *message = [[[_messageQueue objectAtIndex:0] retain] autorelease];
        
		[_messageQueue removeObjectAtIndex:0];
        
		if (delegate && [delegate respondsToSelector:@selector(messageBroker:didSendMessage:)]) {
            [delegate messageBroker:self didSendMessage:message];
        }
    }
}

#pragma mark -
#pragma mark Other

/**
 * Dealloc.
 */
- (void)dealloc
{
	if ([_socket isConnected]) [_socket disconnect];
	
	[_socket release], _socket = nil;
	[_messageQueue release], _messageQueue = nil;
}

@end
