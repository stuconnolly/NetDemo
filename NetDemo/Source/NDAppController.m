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

@implementation NDAppController

#pragma mark -
#pragma mark Initialisation

/**
 * Init.
 */
- (id)init
{
	if ((self = [super initWithWindowNibName:@"NetDemo"])) {
		_messages = [[NSMutableArray alloc] init];
	}
	
	return self;
}

/**
 * UI initialisation.
 */
- (void)awakeFromNib
{	
	_dateFormatter = [[NSDateFormatter alloc] initWithDateFormat:@"%H:%M:%S" allowNaturalLanguage:NO];
	
	for (NSTableColumn *column in [outputTableView tableColumns])
	{
		[[column dataCell] setFont:[NSFont fontWithName:@"Courier" size:12.0]];
	}		
}

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
		return;
	}
		
	if ([_client isConnected]) {
		NDLog(self, @"Preparing to send message '%@'", message);
		
		[_client sendMessage:[inputTextView string]];
	}
}

/**
 * Clears the messages table view.
 */
- (IBAction)clearMessages:(id)sender
{
	[_messages removeAllObjects];
	
	[clearButton setEnabled:NO];
	
	[outputTableView reloadData];
}

#pragma mark -
#pragma mark Server delegate methods

- (void)networkServer:(NDNetworkServer *)server didRecieveMessage:(NDNetworkMessage *)message
{
	[_messages addObject:message];
	
	[clearButton setEnabled:YES];
	
	[outputTableView reloadData];
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
	if (_server) [_server release], _server = nil;
	if (_client) [_client release], _client = nil;
	
	[_messages release], _messages = nil;
}

@end
