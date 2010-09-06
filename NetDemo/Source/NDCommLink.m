/*
 *  NDCommLink.m
 *
 *  NetDemo
 *
 *  Copyright (c) 2010 Stuart Connolly
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

#import "NDCommLink.h"

@implementation NDCommLink

@synthesize port;

/**
 *
 */
- (id)init
{
	if ((self = [super init])) {
		
		_host = [NSHost currentHost];
		
		port = -1;
	}
	
	return self;
}

- (BOOL)initStreams
{
	if (!_host || (port < 1024)) return NO;
	
	[NSStream getStreamsToHost:_host port:port inputStream:&_iStream outputStream:&_oStream];
	
	// Retain the streams as they're autoreleased
	[_iStream retain];
	[_oStream retain];
	
	// Set stream delegates
	[_iStream setDelegate:self];
	[_oStream setDelegate:self];
	
	// Schedule streams on the current run loop
	[_iStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[_oStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	
	// Open the streams
	[_iStream open];
	[_oStream open];
	
	return YES;
}

/**
 *
 */
- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent
{
	NSLog(@"%@", streamEvent);
}

/**
 *
 */
- (void)dealloc
{
	if ([_iStream streamStatus] == NSStreamStatusOpen) {
		[_iStream close];
		[_iStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		[_iStream release], _iStream = nil;
	}
	
	if ([_oStream streamStatus] == NSStreamStatusOpen) {
		[_oStream close];
		[_iStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		[_oStream release], _oStream = nil;
	}
		
	[super dealloc];
}

@end
