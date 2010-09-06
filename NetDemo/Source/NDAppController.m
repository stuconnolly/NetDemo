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

@implementation NDAppController

#pragma mark -
#pragma mark Initialisation

/**
 * Init.
 */
- (id)init
{
	if ((self = [super init])) { }
	
	return self;
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
 * Called when the application finishes launching, opens the set port sheet.
 */
- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
	[NSApp beginSheet:portPanel 
	   modalForWindow:[self window] 
		modalDelegate:self 
	   didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) 
		  contextInfo:nil];
}

#pragma mark -
#pragma mark Delegate methods

/**
 * Called when the set comm port sheet is dismissed.
 */
- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
	// Set the port
	if (returnCode == NSOKButton) {
		
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
	
}

@end
