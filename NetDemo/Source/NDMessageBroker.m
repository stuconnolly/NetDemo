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

/**
 *
 */
- (id)initWithSocket:(AsyncSocket *)socket
{
	if ((self = [super init])) {
		
		if ([socket canSafelySetDelegate]) {
			_socket = [socket retain];
			[_socket setDelegate:self];
			
			_messageQueue = [[NSMutableArray alloc] init];
			
			[_socket readDataToLength:sizeof(UInt64) withTimeout:-1.0 tag:0];
		}
		else {
			self = nil;
		}
		
	}
	
	return self;
}

/**
 *
 *
 * @param message
 */
- (void)sendMessage:(NDNetworkMessage *)message
{
	NDLog(self, @"Message broker sending message: %@", message);
}

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
