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

#import "NDLogger.h"
#import "NDLogMessage.h"

static NDLogger *logger = nil;

@implementation NDLogger

@synthesize logMessages;

/*
 * Returns the shared query console.
 */
+ (NDLogger *)logger
{
	@synchronized(self) {
		if (logger == nil) {
			logger = [[super allocWithZone:NULL] init];
		}
	}
	
	return logger;
}

+ (id)allocWithZone:(NSZone *)zone
{    
	@synchronized(self) {
		return [[self logger] retain];
	}
}

/*
 * The following base protocol methods are implemented to ensure the singleton status of this class.
 */

- (id)copyWithZone:(NSZone *)zone { return self; }

- (id)retain { return self; }

- (NSUInteger)retainCount { return NSUIntegerMax; }

- (id)autorelease { return self; }

- (void)release { }

/**
 * Clears the log by removing all messages.
 */
- (void)clearLog
{
	[logMessages removeAllObjects];
}

/**
 * Logs the supplied message.
 */
+ (void)log:(NSString *)message
{	
	[[[NDLogger logger] logMessages] addObject:[NDLogMessage logMessageWithMessage:message date:[NSDate date]]];
}

/**
 * Logs the supplied message.
 */
+ (void)logError:(NSString *)message
{	
	NDLogMessage *logMessage = [NDLogMessage logMessageWithMessage:message date:[NSDate date]];
	
	[logMessage setIsError:YES];
	
	[[[NDLogger logger] logMessages] addObject:logMessage];	
}

/**
 * Dealloc.
 */
- (void)dealloc
{
	[logMessages release], logMessages = nil;
	
	[super dealloc];
}

@end
