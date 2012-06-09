//
//  MapControlLayer.m
//  Monster
//
//  Created by Ryan Renna on 12-01-18.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapControlLayer.h"
#import "LevelScene.h"

@implementation MapControlLayer
-(id) init : (GuiLayer*) currentGuiLayer :(MMatch*) currentMatch currentUnitLayer:(UnitLayer*) currentUnitLayer currentTerrainLayer:(TerrainLayer*) currentTerrainLayer
{
	self = [super init];
	if(self != nil) 
	{
		match = currentMatch;
        
		//Tiles
		selectedTile = nil;
		tiles = [[NSMutableDictionary alloc]init];
		//Layers
		guiLayer = currentGuiLayer;
		actionWheelLayer = [[[ActionWheelLayer alloc] init] retain];
		unitLayer = currentUnitLayer;
		terrainLayer = currentTerrainLayer;
		//Sprites
		movementOverlaySheet = [CCSpriteBatchNode batchNodeWithFile:@"Monster-Map-Actions.png"];
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Monster-Map-Actions.plist"];
		[self addChild:movementOverlaySheet];
		//Sets the unit selection marker animation
		selectionMarkerSprite = [CCSprite spriteWithFile:@"SelectionMarker1.png"];
		selectionMarkerFadeIn = [[CCFadeIn alloc] initWithDuration:0.1f];
		selectionMarker = [[[CCAnimation alloc] init] autorelease];
		[selectionMarker addFrameWithFilename:@"SelectionMarker1.png"];
		[selectionMarker addFrameWithFilename:@"SelectionMarker2.png"];
		[selectionMarker addFrameWithFilename:@"SelectionMarker3.png"];
		[selectionMarker addFrameWithFilename:@"SelectionMarker4.png"];
		[selectionMarker addFrameWithFilename:@"SelectionMarker5.png"];
		[selectionMarker addFrameWithFilename:@"SelectionMarker6.png"];
		[selectionMarker addFrameWithFilename:@"SelectionMarker7.png"];
		[selectionMarker addFrameWithFilename:@"SelectionMarker8.png"];
		[selectionMarker addFrameWithFilename:@"SelectionMarker7.png"];
		[selectionMarker addFrameWithFilename:@"SelectionMarker6.png"];
		[selectionMarker addFrameWithFilename:@"SelectionMarker5.png"];
		[selectionMarker addFrameWithFilename:@"SelectionMarker4.png"];
		[selectionMarker addFrameWithFilename:@"SelectionMarker3.png"];
		[selectionMarker addFrameWithFilename:@"SelectionMarker2.png"];
        
        
        
		[selectionMarkerSprite setVisible:NO];
		[self addChild:selectionMarkerSprite z:5];
		id action = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:selectionMarker]];
		[selectionMarkerSprite runAction:action];
		
		//Sets the initial point of the camera
		currentCameraPosition.x = 0;
		currentCameraPosition.y = 0;
		//Sets the initial point of the scroll "grabber"
		currentGrabPosition.x = 0;
		currentGrabPosition.y = 0;
		
		actionWheelVisible = NO;
		self.isTouchEnabled = true;
        
	}
	return self;
}
- (void) dealloc
{
	[selectionMarker release];
	[selectionMarkerSprite release];
	[ActionWheelLayer release];
	[super dealloc];
}
-(void) bindMoveTiles
{
	MEntity* focusEntity = [MEntityManager getFocusEntity];
	NSMutableArray *actionsForCurrentUnit = [focusEntity getActions:[match map]];
	for(MAction* action in actionsForCurrentUnit)
	{
		//Get final move
		int finalMovePosition = [[action moves] count] -1;
		MMove *move = [[action moves] objectAtIndex:finalMovePosition];
		
		NSString *key = [MVertexUtil VertexLocationKey:move.destinationPosition];
		MActionTile *tile;
		tile = [tiles objectForKey:key];
		if(tile != nil)
		{
			[[tile actions] addObject:action];
		}
		else 
		{
			MActionTile *moveHighlight = [MActionTile alloc];
            
			if([[move skill] type] == MovementSkill)
			{
				[moveHighlight initWithType:MovementAction];
			}
			else 
			{
				[moveHighlight initWithType:MeleeAttackAction];
			}
			[[moveHighlight actions] addObject:action];
			[moveHighlight sprite].position = ccp((move.destinationPosition.x * TILEXSIZE) + 32,(move.destinationPosition.y * TILEYSIZE) + 32);
            
			[tiles setObject:moveHighlight forKey:key];
			[self addChild:[moveHighlight sprite]];	
		}
	}
}
-(void) update
{	
	if([selectionMarkerSprite visible])
	{
		if([MEntityManager getFocusEntity] != nil)
		{
			[selectionMarkerSprite setPosition:[[MEntityManager getFocusEntity].sprite position]];
		}
	}
}
-(void) unbindMoveTiles
{
	selectedTile = nil;
	
	for(NSString *tileKey in tiles)
	{
		MActionTile *tile = [tiles objectForKey:tileKey];
		[self removeChild:[tile sprite] cleanup:true];
	}
	[tiles removeAllObjects];
}
-(void) updateCameraWithOffset : (CGPoint) pPositionOffset
{
	currentCameraPosition.x += (int)pPositionOffset.x;
	currentCameraPosition.y += (int)pPositionOffset.y;
	[self updateCamera];
}
-(void) updateCameraWithPosition : (CGPoint) pPosition
{
	currentCameraPosition.x = (int)pPosition.x - ([[CCDirector sharedDirector] winSize].width/2);
	currentCameraPosition.y = (int)pPosition.y - ([[CCDirector sharedDirector] winSize].height/2);
	[self updateCamera];
}
-(void)updateCamera
{
	[self.camera setCenterX:currentCameraPosition.x centerY:currentCameraPosition.y centerZ:0];
	[self.camera setEyeX:currentCameraPosition.x eyeY:currentCameraPosition.y eyeZ:1];
	//Update terrain
	[terrainLayer.camera setCenterX:currentCameraPosition.x centerY:currentCameraPosition.y centerZ:0];
	[terrainLayer.camera setEyeX:currentCameraPosition.x eyeY:currentCameraPosition.y eyeZ:1];
	//Update units
	[unitLayer.camera setCenterX:currentCameraPosition.x centerY:currentCameraPosition.y centerZ:0];
	[unitLayer.camera setEyeX:currentCameraPosition.x eyeY:currentCameraPosition.y eyeZ:1];
    
}
-(void)showActionWheel : (CGPoint) pPosition
{
	actionWheelVisible = true;
	[guiLayer addChild:actionWheelLayer];
	[self updateCameraWithPosition:pPosition];			
}
-(void)hideActionWheel
{
	actionWheelVisible = false;
	[guiLayer removeChild:actionWheelLayer cleanup:YES];
	[self deselect];
}
-(void) unitSelection : (CGPoint)location
{
	for(NSString *entityKey in [MEntityManager allUnits])
	{
		MActor *actor = [[MEntityManager allUnits] objectForKey:entityKey];
		MUnit *entity = [actor object];
		CGRect rect = [entity rect];
		if(CGRectContainsPoint(rect, location))
		{
			//Set the unit as the focus entity
			[MEntityManager setFocusEntity: entity];
			//Show & place the selection marker
			[selectionMarkerSprite runAction:selectionMarkerFadeIn];
			
			[selectionMarkerSprite setPosition:[entity.sprite position]];
			[selectionMarkerSprite setVisible:YES];
			//Show unit's preview icon
			//TODO: Add focus entity logic
			
			//Only consider entities on the same team as the player
			if([entity team] == [match currentTeam])
			{
				//If unit has moves
				if([entity moves ] > 0)
				{
					[self bindMoveTiles];
				}
			}
			break;
		}
	}
}
-(void) actionSelection : (CGPoint)location
{
	BOOL actionSelected = NO;
	for (NSString *tileKey in tiles) 
	{
		MActionTile *tile = [tiles objectForKey:tileKey];
		CGRect rect = [tile rect];
		if(CGRectContainsPoint(rect, location))
		{
			NSMutableArray *actions = [tile actions];
			//If there's multiple actions tied to this tile, show the action wheel
			if([actions count] > 1)
			{
				[self showActionWheel : ccp(tile.sprite.position.x,tile.sprite.position.y)];
				[self unbindMoveTiles];
			}
			//If there's only 1 action tied to this tile
			else 
			{
				MAction *action = [actions objectAtIndex:0];
				[action retain];
				//No action selected
				// or different action is selected, queue current action
				if(selectedTile == nil || selectedTile != tile)
				{
					[selectedTile setSelected:NO];
					selectedTile = tile;
					[selectedTile setSelected:YES];
				}
				else
				{
					//Same action is selected, perform
					//Must double select the action to perform
					[[MEntityManager getFocusEntity] queueAction:action];
					selectedTile = nil;
					//Unbind movement tiles for currently selected unit
					[self unbindMoveTiles];
				}
				[action release];
				actionSelected = YES;
			}
			break;
		}
	}
	//If no action was selected, a deselection was intended
	if(actionSelected == NO)
	{
		[self deselect];
	}
}
-(void)deselect
{
	[selectionMarkerSprite setVisible:NO];
	//If movement tiles have be bound, remove them
	if([tiles count] >0)
	{
		[self unbindMoveTiles];
	}
	[MEntityManager clearFocusEntity];	
}
//Initial touch, used for scrolling, detecting selection
- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch* myTouch = [touches anyObject];
	CGPoint location = [myTouch locationInView: [myTouch view]];
	location = [[CCDirector sharedDirector]convertToUI:location];
    
	currentGrabPosition.x = location.x;
	currentGrabPosition.y = location.y;
	previousXOffset = 0;
	previousYOffset = 0;
}
//End of Touch, should only initiated actions during Human player turn
- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
	//Only allows interaction during a human player's turn
	// and if the EntityManager is not currently processing (a action is being carried out)
	if([match controlstate] == PlayerControl && ![MEntityManager isProcessing])
	{
		UITouch* myTouch = [touches anyObject];
		CGPoint location = [myTouch locationInView: [myTouch view]];
		location = [[CCDirector sharedDirector]convertToUI:location];
		double deltaX = currentGrabPosition.x - location.x;
		double deltaY = currentGrabPosition.y - location.y;
		//If releasing the cursor within 2 pixels of the starting handle, it's a selection order
		if(-SELECTIONPIXELPRECISION < deltaX && deltaX < SELECTIONPIXELPRECISION)
		{
			if(-SELECTIONPIXELPRECISION < deltaY && deltaY < SELECTIONPIXELPRECISION)
			{
				//If any type of selection, and the action wheel is visible, hide the action wheel
				if(actionWheelVisible)
				{
					[self hideActionWheel];
				}
				else 
				{
					location.x += currentCameraPosition.x;
					location.y -= currentCameraPosition.y;
					if([MEntityManager getFocusEntity] == nil)
					{
						[self unitSelection:location];
					}
					else {
						[self actionSelection:location];
					}
				}
			}
		}
	}
}
- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event 
{
}
//Scrolling
- (void)ccTouchesMoved:(NSSet*)touches withEvent:(UIEvent*)event{
	UITouch* myTouch = [touches anyObject];
	CGPoint location = [myTouch locationInView: [myTouch view]];
	location = [[CCDirector sharedDirector]convertToUI:location];
	
	CGPoint difference;
	difference.x = (currentGrabPosition.x - location.x);
	difference.y = (currentGrabPosition.y - location.y);
	
	double deltaX = -(previousXOffset - difference.x) * FINGERSCROLLMULTIPLYER;
	double deltaY = -(previousYOffset - difference.y) * FINGERSCROLLMULTIPLYER;
	
	CGPoint offset;
	if(deltaX >-MINSCROLLSPEED && deltaX < MINSCROLLSPEED)
	{
		offset.x = 0;
	}
	else 
    {
		if(deltaX > 0)
		{
			if(deltaX > MAXSCROLLSPEED)
				
			{
				offset.x = MAXSCROLLSPEED;
			}
			else 
			{
				offset.x = deltaX/(MAXSCROLLSPEED/4);
			}
		}
		else 
		{
			if(deltaX < -MAXSCROLLSPEED)
			{
				offset.x = -MAXSCROLLSPEED;
			}
			else {
				offset.x = deltaX/(MAXSCROLLSPEED/4);
			}
		}
	}
	if(deltaY >-MINSCROLLSPEED && deltaY < MINSCROLLSPEED)
	{
		offset.y = 0;
	}
	else {
		if(deltaY > 0)
		{
			if(deltaY > MAXSCROLLSPEED)
			{
				offset.y = MAXSCROLLSPEED;
			}
			else 
			{
				offset.y = deltaY/(MAXSCROLLSPEED/4);
			}
		}
		else {
			if(deltaY < -MAXSCROLLSPEED)
			{
				offset.y = -MAXSCROLLSPEED;
			}
			else {
				offset.y = deltaY/(MAXSCROLLSPEED/4);
			}
		}
	}
	
	if(actionWheelVisible)
	{
		[self hideActionWheel];
	}
	[self updateCameraWithOffset:offset];
	previousXOffset = difference.x;
	previousYOffset = difference.y;
}
@end