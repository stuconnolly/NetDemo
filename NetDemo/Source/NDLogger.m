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

#import "NDLogMessage.h"

static NDLogger *logger = nil;

@interface NDLogger (PrivateAPI)

void _NDLogMessage(id caller, BOOL isError, NSString *message, va_list arguments);

@end

@implementation NDLogger

@synthesize delegate;
@synthesize logMessages;

#pragma mark -
#pragma mark Initialisation

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

/**
 * Init.
 */
- (id)init
{
	if ((self = [super init])) {
		logMessages = [[NSMutableArray alloc] init];
	}
	
	return self;
}

/*
 * The following base protocol methods are implemented to ensure the singleton status of this class.
 */

- (id)copyWithZone:(NSZone *)zone { return self; }

- (id)retain { return self; }

- (NSUInteger)retainCount { return NSUIntegerMax; }

- (id)autorelease { return self; }

- (void)release { }

#pragma mark -
#pragma mark Public API

/**
 * Clears the log by removing all messages.
 */
- (void)clearLog
{
	[logMessages removeAllObjects];
}

/**
 * Logs the supplied message.
 *
 * @param caller  The caller that logged the message
 * @param message The message that is to be logged
 * @param args    A variable number of arguments that are to be interpolated into the message string
 */
void NDLog(id caller, NSString *message, ...)
{		
	va_list arguments;
	
	va_start(arguments, message);
	va_end(arguments);
	
	_NDLogMessage(caller, NO, message, arguments);
}

/**
 * Logs the supplied message as an error.
 *
 * @param caller  The caller that logged the message
 * @param message The message that is to be logged
 * @param args    A variable number of arguments that are to be interpolated into the message string
 */
void NDLogError(id caller, NSString *message, ...)
{		
	va_list arguments;
	
	va_start(arguments, message);
	va_end(arguments);
	
	_NDLogMessage(caller, YES, message, arguments);
}

#pragma mark -
#pragma mark Private API

/**
 * Logs the supplied message from the supplied caller.
 */
void _NDLogMessage(id caller, BOOL isError, NSString *message, va_list arguments)
{
	// Extract any supplied arguments and build the formatted log string
	NSString *logString = [[NSString alloc] initWithFormat:message arguments:arguments];
		
	NDLogMessage *logMessage = [NDLogMessage logMessageFromCaller:[caller description] withMessage:logString date:[NSDate date]];
	
	[logMessage setIsError:isError];
	
	[[logger logMessages] addObject:logMessage];
	
	if ([logger delegate] && [[logger delegate] respondsToSelector:@selector(logger:updatedWithMessage:)]) {
		[[logger delegate] logger:logger updatedWithMessage:logMessage];
	}
	
	[logString release];
}

#pragma mark -
#pragma mark Other

/**
 * Dealloc.
 */
- (void)dealloc
{
	[logMessages release], logMessages = nil;
	
	[super dealloc];
}

@end
