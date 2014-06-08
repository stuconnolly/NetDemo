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

#import "NDNetworkMessage.h"

// Constants
static NSString *NDMessageDate = @"NDMessageDate";
static NSString *NDMessageData = @"NDMessageData";

@implementation NDNetworkMessage

@synthesize data;
@synthesize date;

#pragma mark -
#pragma mark Initialisation

/**
 * Returns a network message with the supplied data.
 *
 * @param messageData An NSData instance encapsulating the message data
 * @param messageDate An NSDate instance representing the messages creation date
 */
+ (NDNetworkMessage *)messageWithData:(NSData *)messageData date:(NSDate *)messageDate
{
	return [[[NDNetworkMessage alloc] initWithData:messageData date:messageDate] autorelease];
}

/**
 * Initialises a network message with the supplied data.
 *
 * @param messageData An NSData instance encapsulating the message data
 * @param messageDate An NSDate instance representing the messages creation date
 */
- (id)initWithData:(NSData *)messageData date:(NSDate *)messageDate
{
	if ((self = [super init])) {
		[self setDate:messageDate];
		[self setData:messageData];
	}
	
	return self;
}

#pragma mark -
#pragma mark NSCoding protocol methods

- (id)initWithCoder:(NSCoder *)coder 
{
    if ((self = [super init])) {
		date = [[coder decodeObjectForKey:NDMessageDate] retain];
        data = [[coder decodeObjectForKey:NDMessageData] retain];
    }
	
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder 
{
	[coder encodeObject:date forKey:NDMessageDate];
    [coder encodeObject:data forKey:NDMessageData];
}

#pragma mark -
#pragma mark Other

/**
 * Dealloc.
 */
- (void)dealloc
{
	[date release], date = nil;
	[data release], data = nil;
	
	[super dealloc];
}

@end
