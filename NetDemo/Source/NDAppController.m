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

#import "NDAppController.h"
#import "NDNetworkServer.h"
#import "NDNetworkClient.h"
#import "NDNetworkMessage.h"
#import "NDNetworkUtils.h"
#import "NDLogger.h"

@implementation NDAppController

#pragma mark -
#pragma mark IB action methods

/**
 * Opens the network log panel.
 */
- (IBAction)showNetworkLog:(id)sender
{
	[_logController showWindow:self];
}

/**
 * Opens the set comm port sheet.
 */
- (IBAction)setPort:(id)sender
{
	[NSApp beginSheet:portPanel 
	   modalForWindow:[self window] 
		modalDelegate:self 
	   didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) 
		  contextInfo:nil];
}

/**
 * Close the calling sheet.
 */
- (IBAction)closeSheet:(id)sender
{
	[NSApp endSheet:[sender window] returnCode:[sender tag]];
	[[sender window] orderOut:self];
}

/**
 * Sends the current message via the client.
 */
- (IBAction)sendMessage:(id)sender
{
	NSString *message = [[inputTextView string] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	if (![message length]) {
		NDLogError(self, @"Attempting to send empty message");
		NSBeep();
		return;
	}
	
	NDLog(self, @"Preparing to send message '%@'", message);
	
	if (!NDIsStringValidASCII(message)) {
		NDLogError(self, @"Message is not valid. Message can only contain 64 ASCII characters (0-9, a-z or A-Z). Not sending.");
		NSBeep();
		return;
	}
	
	[_client sendMessage:[inputTextView string]];
}

#pragma mark -
#pragma mark Application notifications

/**
 * Called when the application finishes launching.
 */
- (void)applicationDidFinishLaunching:(NSNotification *)notification
{		
	NSArray *args = [[NSProcessInfo processInfo] arguments];
	
	BOOL noServer = [args containsObject:@"--no-server"];
	BOOL noClient = [args containsObject:@"--no-client"];
	
	if (noServer && noClient) {
		NDLogError(self, @"Application started with no client or server");
		return;
	}
	
	// If required start the server
	if (!noServer) {
		_server = [[NDNetworkServer alloc] init];
		
		[_server setDelegate:self];
		
		// Start the server
		[_server startService];
	}
	
	// If required start the client
	if (!noClient) {
		_client = [[NDNetworkClient alloc] init];
		
		[_client setDelegate:self];
		
		// Start the client's search for services
		[_client search];
	}
}

/**
 * Called when the application is about to terminate.
 */
- (void)applicationWillTerminate:(NSNotification *)notification
{
	[_server stopService];
}

#pragma mark -
#pragma mark Server delegate methods

- (void)networkServer:(NDNetworkServer *)server didRecieveMessage:(NDNetworkMessage *)message
{
	NSString *messageString = [[NSString alloc] initWithBytes:[[message data] bytes] length:[[message data] length] encoding:NSUTF8StringEncoding];
	
	[outputTextView setEditable:YES];
	[outputTextView setString:@""];
	[outputTextView setString:messageString];
	[outputTextView setEditable:NO];
	
	[messageString release];
}

#pragma mark -
#pragma mark Client delegate methods

- (void)networkClient:(NDNetworkClient *)client didFindServices:(NSArray *)services
{
	// When the client has found the right service, try to connect to it
	[_client connect];
}

#pragma mark -
#pragma mark General delegate methods

/**
 * Called when the set comm port sheet is dismissed.
 */
- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
	// Set the port and restart the server
	if (returnCode == NSOKButton) {
		[_server stopService];
		[_server setPort:[portTextField integerValue]];
		[_server startService];
	}
}

/**
 * Enable/disable the set port button depending on the port number entered.
 */
- (void)controlTextDidChange:(NSNotification *)notification
{	
	if ([notification object] == portTextField) {
		[setPortButton setEnabled:(([[portTextField stringValue] length] > 0) && ([portTextField integerValue] > 1024))];
	}
}

#pragma mark -
#pragma mark Other

/**
 * Dealloc.
 */
- (void)dealloc
{
	[_server release], _server = nil;
	[_client release], _client = nil;
}

@end
