/*
 *  NetDemo
 *  https://github.com/stuconnolly/netdemo
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

@class NDNetworkClient;

/**
 * @protocol NDNetworkClientDelegate NDNetworkClientDelegate.h
 *
 * @author Stuart Connolly http://stuconnolly.com/ 
 *
 * Network client delegate protocol.
 */
@protocol NDNetworkClientDelegate


@optional

/**
 * Called when the client has found all available services.
 *
 * @param client   The calling client instance
 * @param services The array of services found (NSNetService instances)
 */
- (void)networkClient:(NDNetworkClient *)client didFindServices:(NSArray *)services;

/**
 * Called whenever the client connects to a server. 
 *
 * @param client The calling client instance
 * @param host   The hostname of the server the client connected to
 */
- (void)networkClient:(NDNetworkClient *)client didConnectToHost:(NSString *)host;

/**
 * Called whenever the client disconnects from a server.
 *
 * @param client The calling client instance
 * @param host   The hostname of the server the client disconnected from
 */
- (void)networkClient:(NDNetworkClient *)client didDisconnectFromHost:(NSString *)host;

@end
