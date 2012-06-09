//
// cocos2d Hello World example
// http://www.cocos2d-iphone.org
//

// Import the interfaces
#import "SplashScene.h"



// HelloWorld implementation
@implementation Splash

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Splash *layer = [Splash node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		CCSprite *background = [CCSprite spriteWithFile:@"Splash.png"];
		
		
		// ask director the the window size
		
		
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		//Scale the image so that a regular size iPhone will display it at 1:1 scale
		splashScale = sqrt( screenSize.width / 460 );
		[background setScale: splashScale];
		// position the label on the center of the screen
		splashCenter = ccp(screenSize.width /2, screenSize.height/2);
		background.position = splashCenter;
 		// add the label as a child to this Layer
		//[self addChild: label];
		[self addChild:background];	
		SplashLayer *splashMenu = [SplashLayer node];
		
		[self addChild:splashMenu];
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{

	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end

@implementation SplashLayer
-(id) init{
	self = [super init];
	if(self != nil) 
	{
		MButton *start = [MButton buttonWithText:@"Start" background:true backgroundImage:@"button.png" backgroundImagePressed:@"button_pressed.png" atPosition:ccp((splashCenter.x - 160)*splashScale,(splashCenter.y + 50)*splashScale) target:self selector:@selector(startGame:)];
		[[start camera] setCenterX:0.3 centerY:0 centerZ:0];
		[[start camera] setEyeX:-0.05 eyeY:0.1 eyeZ:1];
		MButton *help = [MButton buttonWithText:@"Help" background:true backgroundImage:@"button.png" backgroundImagePressed:@"button_pressed.png" atPosition:ccp((splashCenter.x - 160)*splashScale,(splashCenter.y + 5)*splashScale) target:self selector:@selector(help:)];
		[[help camera] setCenterX:0.3 centerY:0 centerZ:0];
		[[help camera] setEyeX:-0.05 eyeY:0.1 eyeZ:1];
		[self addChild:start];
		[self addChild:help];
		
		
		
		//
		CCParticleSystemQuad *particleSystem = [[CCParticleSystemQuad alloc] initWithFile:@"SplashFire.plist"];
		CGPoint explosionPosition; explosionPosition.x = 40;
		explosionPosition.y = -10;
		[particleSystem setPosition:explosionPosition];
		[self addChild:particleSystem];
		
		particleSystem = [[CCParticleSystemQuad alloc] initWithFile:@"SplashFire.plist"];
		explosionPosition.x = 315;
		[particleSystem setPosition:explosionPosition];
		[self addChild:particleSystem];
		
		[particleSystem release];
	}
	return self;
}
- (void) dealloc
{
	[super dealloc];
}
-(void)startGame: (id)sender {
    Level *level = [Level node];
    [[CCDirector sharedDirector] replaceScene:level];
	[level release];
}
-(void)help: (id)sender {
    NSLog(@"help");
}
@end

