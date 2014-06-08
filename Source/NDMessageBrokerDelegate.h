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

@class NDMessageBroker, NDNetworkMessage, AsyncSocket;

/**
 * @protocol NDLoggerDelegate NDLoggerDelegate.h
 *
 * @author Stuart Connolly http://stuconnolly.com/ 
 *
 * Message broker delegate protocol.
 */
@protocol NDMessageBrokerDelegate

@optional

/**
 * Called whenever the message broker sends a new message.
 *
 * @param broker  The calling broker instance 
 * @param message The message that the broker sent
 */
- (void)messageBroker:(NDMessageBroker *)broker didSendMessage:(NDNetworkMessage *)message;

/**
 * Called whenever the message broker receives a new message.
 *
 * @param broker  The calling broker instance
 * @param message The message that the broker received
 */ 
- (void)messageBroker:(NDMessageBroker *)broker didReceiveMessage:(NDNetworkMessage *)message;

/**
 * Called whenever the message broker loses it's socket connection to the client/server.
 *
 * @param broker The calling broker instance
 * @param socet  The socket that disconnected
 */
- (void)messageBroker:(NDMessageBroker *)broker lostSocketConnection:(AsyncSocket *)socket;

@end
