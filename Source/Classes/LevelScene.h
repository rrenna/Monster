#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "MButton.h"
#import "MEntity.h"
#import "MUnit.h"
#import "Map.h"
#import "MSettings.h"
#import "MMatch.h"
#import "MActionTile.h"
#import "MAction.h"
#import "MTeam.h"
#import "MStructure.h"
#import "MEntityManager.h"
#import "MContactListener.mm"

@class MUnit;
@class UnitLayer;
@class GuiLayer;
@class MapControlLayer;
@class TerrainLayer;

// HelloWorld Layer
@interface Level : CCScene
{
	MMatch *match;
	UnitLayer *unitLayer;
	GuiLayer *guiLayer;
}
// returns a Scene that contains the HelloWorld as the only child
+(id) scene;
-(void)update : (id) sender;
-(void)startMatch;
-(void)continueMatch;
-(void)endMatch;
@end
@interface GuiLayer : CCLayer 
{
	MTeam *controlled;
	MMatch *match;
	MapControlLayer *controlLayer;
	//Hud
	CCSprite *StatusOverlay;
	CCSprite *healthBar;
	CCSprite *energyBar;
	//Controls
	MButton *btnMenu;
	MButton *btnNextTurn;
	
    CCLabelBMFont* lblTurn;
    CCLabelBMFont* lblUnitInfo;
	//CCBitmapFontAtlas *lblTurn;
	//CCBitmapFontAtlas *lblUnitInfo;
}
-(id) initWithCurrentMatch:(MMatch*) currentMatch currentUnitLayer:(UnitLayer*) currentUnitLayer currentTerrainLayer:(TerrainLayer*) currentTerrainLayer;
-(void)loadTheme : (NSString*)themeName;
-(void)btnNextTurn_Click: (id)sender;
-(void)btnMenu_Click: (id)sender;
-(void)update;
@end
@interface ActionWheelLayer : CCLayer
{
	CCSprite *actionWheel;
}
@end
@interface UnitLayer : CCLayer 
{
	GLESDebugDraw *m_debugDraw;
}
@property (readwrite) b2World *world;
-(id) init;
@end 
@interface TerrainLayer : CCLayer 
{
	MMatch *match;
}
-(id) initWithMatch : (MMatch*) pMatch;
@end


