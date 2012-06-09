//
//  MapControlLayer.h
//  Monster
//
//  Created by Ryan Renna on 12-01-18.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "MSettings.h"
#import "MEntityManager.h"

@class GuiLayer;
@class ActionWheelLayer;
@class TerrainLayer;

@interface MapControlLayer : CCLayer 
{
	//Game
	MMatch *match;
	//Layers
	GuiLayer *guiLayer;
	ActionWheelLayer *actionWheelLayer;
	UnitLayer *unitLayer;
	TerrainLayer *terrainLayer;
	//Tiles
	MActionTile *selectedTile;
	NSMutableDictionary *tiles;
	//Selection Market
	CCSprite *selectionMarkerSprite;
	CCAnimation *selectionMarker;
	CCFadeIn *selectionMarkerFadeIn;
	//Movement Overlay
	CCSpriteBatchNode *movementOverlaySheet; 
	
	BOOL actionWheelVisible;
	CGPoint currentCameraPosition;
	CGPoint currentGrabPosition;
	int previousXOffset;
	int previousYOffset;
}
-(id) init : (GuiLayer*) currentGuiLayer :(MMatch*) currentMatch currentUnitLayer:(UnitLayer*) currentUnitLayer currentTerrainLayer:(TerrainLayer*) currentTerrainLayer;
-(void) bindMoveTiles;
-(void) unbindMoveTiles;
-(void) updateCameraWithOffset : (CGPoint) pPositionOffset;
-(void) updateCameraWithPosition : (CGPoint) pPosition;
-(void) updateCamera;
-(void)showActionWheel : (CGPoint) pPosition;
-(void)hideActionWheel;
-(void) unitSelection : (CGPoint)location;
-(void) actionSelection : (CGPoint)location;
-(void)deselect;
@end