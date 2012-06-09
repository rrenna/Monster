//
//  Monster_99_3AppDelegate.m
//  Monster-99.3
//
//  Created by Ryan Renna on 10-06-01.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "Monster_AppDelegate.h"
#import "cocos2d.h"
#import "SplashScene.h"
#import "LevelScene.h"
#import "MEntityManager.h"

@implementation Monster_AppDelegate

@synthesize window;

- (void) applicationDidFinishLaunching:(UIApplication*)application
{
    // Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// cocos2d will inherit these values
	[window setUserInteractionEnabled:YES];	
	[window setMultipleTouchEnabled:YES];
    
    CC_DIRECTOR_INIT();
    [[CCDirector sharedDirector] enableRetinaDisplay:YES];
    [CCDirector setDirectorType:CCDirectorTypeDisplayLink];
	[[CCDirector sharedDirector] setAnimationInterval:1.0/30];
    [[CCDirector sharedDirector] setDeviceOrientation:CCDeviceOrientationLandscapeLeft];
    [[CCDirector sharedDirector] setAlphaBlending:YES];
    [[CCDirector sharedDirector] setContentScaleFactor:1];
    
    /*
	
	// Try to use CADisplayLink director
	// if it fails (SDK < 3.1) use the default director
	if( ! [CCDirector setDirectorType:CCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:CCDirectorTypeDefault];
	
	// Use RGBA_8888 buffers
	// Default is: RGB_565 buffers
	
    //[[CCDirector sharedDirector] setPixelFormat:kPixelFormatRGBA8888];
	
	// Create a depth buffer of 16 bits
	// Enable it if you are going to use 3D transitions or 3d objects
//	[[CCDirector sharedDirector] setDepthBufferFormat:kDepthBuffer16];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA8888];
	
	// before creating any layer, set the landscape mode
	[[CCDirector sharedDirector] setDeviceOrientation:CCDeviceOrientationLandscapeLeft];
	[[CCDirector sharedDirector] setAnimationInterval:1.0/30];
	[[CCDirector sharedDirector] setDisplayFPS:YES];	
     */
     
     
	//Initialize static content
	[MSettings initialize];
	[[CCDirector sharedDirector] runWithScene: [Level scene]];
}


- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCTextureCache sharedTextureCache] removeUnusedTextures];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	[[CCDirector sharedDirector] end];
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)dealloc {
	[[CCDirector sharedDirector] release];
	[window release];
	[super dealloc];
}

@end
