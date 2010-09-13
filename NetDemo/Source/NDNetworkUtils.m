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

#import "NDNetworkUtils.h"

/**
 *
 */
BOOL NDIsStringValidASCIIAndLength(NSString *string)
{
	NSUInteger i;
	NSUInteger len = [string length];
	
	// First check to see if the string has no more than 64 characters
	if (len > 64) return NO;
	
	// Assume it's initially valid
	BOOL isValid = YES;
	
	char s[(len + 1)];
	
	// Copy the string to a C buffer
	strcpy(s, [string UTF8String]);
	
	// Check that the string only contains valid ASCII characters (A-Z, 0-9 & space)
	for (i = 0; i < len; i++)
	{		
		isValid = (((s[i] >= 0x30) && (s[i] <= 0x39)) || // 0-9 
				   ((s[i] >= 0x41) && (s[i] <= 0x5A)) || // A-Z
				   ((s[i] >= 0x61) && (s[i] <= 0x7A)) || // a-z
				   (s[i] == 0x20));                      // space 
	}
	
	return isValid;
}
