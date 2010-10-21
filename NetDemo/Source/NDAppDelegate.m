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
