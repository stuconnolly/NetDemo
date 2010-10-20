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

#import "NDLogControllerDataSource.h"
#import "NDLogMessage.h"

@implementation NDLogController (NDLogControllerDataSource)

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

@end
