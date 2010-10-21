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

@class NDNetworkServer, NDNetworkClient, NDLogController;

@protocol NDNetworkServerDelegate, NDNetworkClientDelegate;

/**
 * @class NDAppController NDAppController.h
 *
 * @author Stuart Connolly http://stuconnolly.com/
 *
 * Core application controller class.
 */
@interface NDAppController : NSWindowController <NDNetworkServerDelegate, NDNetworkClientDelegate> 
{		
	// Core instances
	NDNetworkServer *_server;
	NDNetworkClient *_client;
	
	// Messages array
	NSMutableArray *_messages;
	
	// Date formatter
	NSDateFormatter *_dateFormatter;
	
	// Controllers
	IBOutlet NDLogController *_logController;
	
	// Panels
	IBOutlet NSPanel *portPanel;
	
	// Buttons
	IBOutlet NSButton *sendButton;
	IBOutlet NSButton *setPortButton;
	IBOutlet NSButton *clearButton;
	
	// Input/output views
	IBOutlet NSTextView *inputTextView;
	IBOutlet NSTableView *outputTableView;
	
	// Other
	IBOutlet NSTextField *portTextField;
}

- (IBAction)showNetworkLog:(id)sender;
- (IBAction)setPort:(id)sender;
- (IBAction)closeSheet:(id)sender;
- (IBAction)sendMessage:(id)sender;
- (IBAction)clearMessages:(id)sender;

@end
