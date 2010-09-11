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
#import "NDLogMessage.h"
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
	// Setup data formatter
	//_dateFormatter = [[NSDateFormatter alloc] init];
	
	/*[_dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
	
	[_dateFormatter setDateStyle:NSDateFormatterNoStyle];
	[_dateFormatter setTimeStyle:NSDateFormatterMediumStyle];*/
	
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
#pragma mark Tableview datasource methods

/**
 * Table view datasource method. Returns the number of rows in the table veiw.
 */
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
	return [[[NDLogger logger] logMessages] count];
}

/**
 * Table view datasource method. Returns the specific object for the request column and row.
 */
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
	NSString *returnValue = nil;
	NSMutableDictionary *stringAtributes = nil;
	
	id object = [[[[NDLogger logger] logMessages] objectAtIndex:row] valueForKey:[tableColumn identifier]];
	
	returnValue = ([[tableColumn identifier] isEqualToString:@"messageDate"]) ? [_dateFormatter stringFromDate:(NSDate *)object] : object;
	
	// If this is an error message give it a red colour
	if ([(NDLogMessage *)[[[NDLogger logger] logMessages] objectAtIndex:row] isError]) {
		stringAtributes = [NSMutableDictionary dictionaryWithObject:[NSColor redColor] forKey:NSForegroundColorAttributeName];
	}
	
	return [[[NSAttributedString alloc] initWithString:returnValue attributes:stringAtributes] autorelease];
}

#pragma mark -
#pragma mark Logger delegate methods

- (void)logger:(NDLogger *)logger updatedWithMessage:(NDNetworkMessage *)message
{	
	[clearLogButton setEnabled:YES];
	
	[logMessagesTableView reloadData];
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
