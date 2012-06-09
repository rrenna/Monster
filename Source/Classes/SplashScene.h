#import "cocos2d.h"
#import "LevelScene.h"
#import "MButton.h"
#import "MPersona.h"

// HelloWorld Layer
static double splashScale;
static CGPoint splashCenter;

@interface Splash : CCScene
{
}
// returns the splash screen
+(id) scene;
@end
@interface SplashLayer : CCLayer {}
-(void)startGame: (id) sender;
-(void) help: (id) sender;
@end
