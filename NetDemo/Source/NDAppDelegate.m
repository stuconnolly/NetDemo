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

#import "NDAppDelegate.h"

@implementation NDAppController (NDAppDelegate)

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

@end
