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

#import "NDLogController.h"
#import "NDNetworkMessage.h"
#import "NDLogger.h"

@implementation NDLogController

#pragma mark -
#pragma mark Initialisation

/**
 * UI initialisation.
 */
- (void)awakeFromNib
{	
	_dateFormatter = [[NSDateFormatter alloc] initWithDateFormat:@"%H:%M:%S.%F" allowNaturalLanguage:NO];
	
	for (NSTableColumn *column in [logMessagesTableView tableColumns])
	{
		[[column dataCell] setFont:[NSFont fontWithName:@"Courier" size:12.0]];
	}	
	
	[[NDLogger logger] setDelegate:self];
}

#pragma mark -
#pragma mark IB action methods

/**
 * Clears the network log of all messages.
 */
- (IBAction)clearLog:(id)sender
{
	[[NDLogger logger] clearLog];
	
	[clearLogButton setEnabled:NO];
	
	[logMessagesTableView reloadData];
}

/**
 * Closes the log panel.
 */
- (IBAction)closeLogPanel:(id)sender
{
	[self close];
}

#pragma mark -
#pragma mark Logger delegate methods

- (void)logger:(NDLogger *)logger updatedWithMessage:(NDLogMessage *)message
{	
	[clearLogButton setEnabled:YES];
	
	[logMessagesTableView reloadData];
	
	[logMessagesTableView scrollRowToVisible:([logMessagesTableView numberOfRows] - 1)];
}

#pragma mark -
#pragma mark Other

/**
 * Dealloc.
 */
- (void)dealloc
{
	[_dateFormatter release], _dateFormatter = nil;
	
	[super dealloc];
}

@end
