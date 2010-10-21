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

#import "NDNetworkNode.h"

@protocol NDNetworkClientDelegate;

@class NDMessageBroker, AsyncSocket;

/**
 * @class NDNetworkClient NDNetworkClient.h
 *
 * @author Stuart Connolly http://stuconnolly.com/
 *
 * Network client.
 */
@interface NDNetworkClient : NDNetworkNode <NSNetServiceBrowserDelegate>
{	
	id <NDNetworkClientDelegate> delegate;
	
	BOOL isConnected;
		
	NSMutableArray *_services;
	NSNetServiceBrowser *_browser;
    NSNetService *_connectedService;
	
	AsyncSocket *_socket;
    NDMessageBroker *_broker;
}

/**
 * @property delegate The client's delegate
 */
@property (readwrite, assign) id <NDNetworkClientDelegate> delegate;

/**
 * @property isConnected Indicates whether or not the client is connected to the server
 */
@property (readonly, assign) BOOL isConnected;

- (void)search;
- (void)connect;
- (void)disconnect;
- (void)sendMessage:(NSString *)message;

@end
