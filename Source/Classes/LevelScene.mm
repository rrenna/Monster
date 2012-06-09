// Import the interfaces
#import "LevelScene.h"
#import "MapControlLayer.h"

// HelloWorld implementation
@implementation Level
+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	// 'layer' is an autorelease object.
	Level *layer = [Level node];
	// add layer as a child to scene
	[scene addChild: layer];
	// return the scene
	return scene;
}
// on "init" you need to initialize your instance
-(id) init
{	
	if( (self=[super init] )) 
	{
		//Setup Teams
		MTeam *monsterTeam = [[MTeam alloc]initWithColor:[UIColor redColor] isPlayerControlled:YES];
		MTeam *humanTeam = [[MTeam alloc]initWithColor:[UIColor blueColor] isPlayerControlled:NO];
		//Setup Match
		match = [[MMatch alloc] initWithMaxRoundAndTeams:15:monsterTeam,humanTeam,nil];
		
		TerrainLayer *terrainLayer = [[TerrainLayer alloc] initWithMatch:match];
	    unitLayer = [[UnitLayer alloc] init];
		guiLayer = [[GuiLayer alloc] initWithCurrentMatch:match currentUnitLayer:unitLayer currentTerrainLayer:terrainLayer]; 
		
		//
		//Setup Units
		Vertex v1; v1.x = 4; v1.y = 2;
		Vertex v2; v2.x = 6; v2.y = 2;
		//Vertex v3; v3.x = 4; v3.y = 5;
		Vertex v4; v4.x = 6; v4.y = 1;
		MUnit *monster = [[MUnit alloc] initWithName:@"monster" andPosition:v4 andTeam:monsterTeam];
		//Set monster as the main unit for the Player team
		[monsterTeam setMainEntity:monster];
		//
		MUnit *tank1 = [[MUnit alloc] initWithName:@"tank" andPosition:v1 andTeam:humanTeam];
		MUnit *tank2 = [[MUnit alloc] initWithName:@"tank" andPosition:v2 andTeam:humanTeam];
		//MUnit *tank3 = [[MUnit alloc] initWithName:@"tank" andPosition:v3 andTeam:humanTeam];
		
		[MEntityManager add:monster : UnitType];
		[MEntityManager add:tank1 : UnitType];
		[MEntityManager add:tank2 : UnitType];
		//[MEntityManager add:tank3 : UnitType];
		
		[self addChild:terrainLayer];
		[self addChild:unitLayer];
		[self addChild:guiLayer];
		[self schedule: @selector(update:)];
				
		//Start the Match
		[self startMatch];
		
		[monster release];
		[tank1 release];
		[tank2 release];
		//[tank3 release];
		
		[terrainLayer release];
		[humanTeam release];
		[monsterTeam release];
	}
	return self;
}
-(void) dealloc
{	
	[match release];
	[guiLayer release];
	[unitLayer release];
	[super dealloc];
}								 
-(void)update : (id)sender
{
	[MEntityManager update];
	[MProjectileManager update];
	[guiLayer update];
	if([MEntityManager isProcessing])
	{
	}
	//else if(
	else 
	{
		[self continueMatch];
	}
}
-(void)startMatch
{
	[match begin];
	//Any match init
	[match nextTurn];
}
-(void)continueMatch
{
	//If the match has reached it's end, fire the match ending functionality
	if ([match matchstate] == Completed) 
	{
		[self endMatch];
	}
	if([match matchstate] != Completed)
	{
		if([match turnComplete] == YES)
		{
			[match nextTurn];
			//Turn initialization
			//Replenish movement points of all current team units
			for(NSString *entityKey in [MEntityManager allUnits])
			{
				MActor *actor = [[MEntityManager allUnits] objectForKey:entityKey];
				MUnit *entity = [actor object];
				if([entity team] == [match currentTeam])
				{
					[entity replenishMoves];
				}	
			}
		}
		else {
			//IF CPU team, perform AI
			if([match controlstate] == CPUControl)
			{
				//TEMP - Picks random move
				//TODO: A.I. IT U.P.
				MTeam *currentTeam = [match currentTeam];
				MUnit *unit = [MEntityManager unmovedUnit : currentTeam];
				
				//Ensures no messages or projectiles are in transit
				if(![MEntityManager isProcessing] && ![MProjectileManager isProcessing])
				{
					NSMutableArray *unitActions = [unit getActions:[match map]];
					[unit performAction: [unitActions lastObject]];
				}
				if(unit == nil) 
				{
					[match completeTurn];
				}
			}
		}

	}
}
-(void)endMatch
{
	//Cleanup, end of match interaction
}
@end
@implementation GuiLayer
-(id) initWithCurrentMatch:(MMatch*) currentMatch currentUnitLayer:(UnitLayer*) currentUnitLayer currentTerrainLayer:(TerrainLayer*) currentTerrainLayer;
{
	self = [super init];
	if((self != nil)) 
	{
		//Enable gesture control on this layer
		self.isTouchEnabled = true;
		match = currentMatch;
		//If a team is player controlled, always display it's main unit's health
		[self loadTheme:@"HumanTheme"];
		
		controlLayer = [[MapControlLayer alloc] init : self : currentMatch currentUnitLayer:currentUnitLayer currentTerrainLayer:currentTerrainLayer];
		//Hud
		lblTurn = [CCLabelBMFont labelWithString:@"1" fntFile:@"guiFont.fnt"];
		lblUnitInfo = [CCLabelBMFont labelWithString:@"Unit Info" fntFile:@"guiFont.fnt"];
		lblTurn.position  = ccp(25,[[CCDirector sharedDirector] winSize].height - 20);
		lblUnitInfo.position  = ccp(175,[[CCDirector sharedDirector] winSize].height - 20);
		//Controls		
		btnNextTurn = [MButton buttonWithImage:@"NextTurnButton.png" PressedImaged:@"NextTurnButtonPressed.png" atPosition:ccp([[CCDirector sharedDirector] winSize].width - 40,35) target:self selector:@selector(btnNextTurn_Click:)];
		btnMenu = [MButton buttonWithImage:@"MenuButton.png" PressedImaged:@"MenuButtonPressed.png" atPosition:ccp(35,35) target:self selector:@selector(btnMenu_Click:)];
		
		[self addChild:controlLayer];
		[self addChild: btnNextTurn];
		[self addChild: btnMenu];

		[self addChild:lblTurn];
		[self addChild:lblUnitInfo];
	}
	return self;
}
- (void) dealloc
{
	[healthBar release];
	[energyBar release];
	[StatusOverlay release];
	[lblTurn release];
	[lblUnitInfo release];
	[btnNextTurn release];
	[btnMenu release];
	[controlLayer release];
	[super dealloc];
}
-(void)loadTheme : (NSString*)fileName
{
	//Load pList
	NSData *plistData;  
	NSString *error;  
	NSPropertyListFormat format;  
	id plist;  
	
	NSString *localizedPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];  
	plistData = [NSData dataWithContentsOfFile:localizedPath];   
	
	plist = [NSPropertyListSerialization propertyListFromData:plistData mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];  
	if (!plist) {  
		NSLog(@"Error reading plist from file '%s', error = '%s'", [localizedPath UTF8String], [error UTF8String]);  
		[error release];  
	}
	else 
	{
		//Load Gui Item

		for(MTeam *team in [match teams])
		{
			if([team controlled])
			{
				controlled = team;

				//Add Main unit gui elements
				healthBar = [CCSprite spriteWithFile:[plist objectForKey:@"HealthbarResource"]];
				healthBar.position = ccp([[CCDirector sharedDirector] winSize].width - 80, [[CCDirector sharedDirector] winSize].height - 6);
				energyBar = [CCSprite spriteWithFile:[plist objectForKey:@"ManabarResource"]];
				energyBar.position = ccp([[CCDirector sharedDirector] winSize].width - 80,[[CCDirector sharedDirector] winSize].height - 20);
				StatusOverlay = [CCSprite spriteWithFile:[plist objectForKey:@"MainStatusOverlayResource"]];
				StatusOverlay.position = ccp([[CCDirector sharedDirector] winSize].width - 108,[[CCDirector sharedDirector] winSize].height - 24);
				[self addChild:healthBar];
				[self addChild:energyBar];
				[self addChild:StatusOverlay];
				break;
			}
		}
		
	}
}
-(void)btnNextTurn_Click : (id)sender 
{
	//If there are no messages queued, and the current unit 
	// is done it's animation
	if([MEntityManager isProcessing] == NO)
	{
		if([[MEntityManager getFocusEntity] activityState] == idle)
		{
			[controlLayer deselect];
			[match completeTurn];
		}
	}
}
-(void)btnMenu_Click: (id)sender
{
		//Slide the Menu over
}
-(void)update
{
	//TODO: Make Event Driven
	//Update Gui Elements
	[lblTurn setString:[NSString stringWithFormat:@"%d", [match round]]];
	//Set Focus Stats
	/*MEntity *focusEntity = [MEntityManager getFocusEntity];
	if([!= nil)
	{*/
		
	//}
	//Show Main entity stats
	MEntity *mainEntity = [controlled mainEntity];
	double healthValue = mainEntity.health / 100;
	double healthOffset = (100 - healthValue);
	healthBar.scaleX = healthValue;
    
    CGPoint newPosition = CGPointMake(healthBar.position.x -healthOffset, healthBar.position.y);
	healthBar.position = newPosition;
	//TODO: Show Focus entity stats
	
	//Update the Unit Control Layer
	[controlLayer update];
}
@end
@implementation ActionWheelLayer
-(id)init
{
	if((self = [super init]))
	{
		actionWheel = [CCSprite spriteWithFile:@"ActionWheel.png"];
		[actionWheel  setPosition:ccp([[CCDirector sharedDirector] winSize].width/2,[[CCDirector sharedDirector] winSize].height/2)];
		[self addChild:actionWheel z:10];
		self.isTouchEnabled = true;
	}
	return self;
}
-(void)dealloc
{
	[super dealloc];
}
@end
@implementation UnitLayer
#define PTM_RATIO 32
@synthesize world;
// enums that will be used as tags
enum {
	kTagTileMap = 1,
	kTagSpriteSheet = 1,
	kTagAnimation1 = 1,
};

-(id) init
{
	if(self == [super init]) 
	{
		//Setup Entity and Projectile Managers
		[MEntityManager initWithLayer:self];
		[MProjectileManager initWithLayer:self];
		
		m_debugDraw = new GLESDebugDraw( PTM_RATIO );
		uint32 flags = 0;flags += b2DebugDraw::e_shapeBit;
		m_debugDraw->SetFlags(flags);
		
		[MEntityManager getWorld]->SetDebugDraw(m_debugDraw);
	}
	return self;
}
- (void) dealloc
{	
	delete m_debugDraw;
	[super dealloc];
}
@end
@implementation TerrainLayer
-(id) initWithMatch : (MMatch*) pMatch 
{
	self = [super init];
	if(self != nil) {
		match = pMatch;
		[self addChild:[match map].tileMap];
		
		/*
		//TODO: Replace with map reading, tileset
		for(int x=0; x < [map width]; x++)
		{
			for(int y = 0; y < [map height]; y++)
			{
				//Add Land layer sprites
				int rotation = (rand() % 4) * 90;
				//Add base terrain textures
				CCSprite *background;
				if([map landGrid].tiles[x][y] == 1)
				{
					background = [CCSprite spriteWithFile:@"Grass1.png"];
				}
				else if([map landGrid].tiles[x][y] == 2)
				{
					background = [CCSprite spriteWithFile:@"Grass2.png"];
				}
				else if([map landGrid].tiles[x][y] == 3)
				{
					background = [CCSprite spriteWithFile:@"Grass3.png"];
				}
				else if([map landGrid].tiles[x][y] == 4)
				{
					background = [CCSprite spriteWithFile:@"Concrete.png"];
				}
				//else if([map landGrid].tiles[x][y] == 5)
				else
				{
					background = [CCSprite spriteWithFile:@"Water.png"];
				}
				background.position = ccp((x * TILEXSIZE),(y * TILEYSIZE));
				background.rotation = rotation;
				[self addChild:background z:1];
				//Add Decal layer sprites
				if([map decalGrid].tiles[x][y] == 1)
				{
					background = [CCSprite spriteWithFile:@"Trees1.png"];
					background.position = ccp((x * TILEXSIZE),(y * TILEYSIZE));
					background.rotation = 0;
					[self addChild:background z:1];
				}
				else if([map decalGrid].tiles[x][y] == 2)
				{
					background = [CCSprite spriteWithFile:@"Trees2.png"];
					background.position = ccp((x * TILEXSIZE),(y * TILEYSIZE));
					background.rotation = 0;
					[self addChild:background z:1];
				}
				else if([map decalGrid].tiles[x][y] == 3)
				{
					background = [CCSprite spriteWithFile:@"Pond.png"];
					background.position = ccp((x * TILEXSIZE),(y * TILEYSIZE));
					background.rotation = 0;
					[self addChild:background z:1];
				}
				//Add structure layer objects
				if([map structureGrid].tiles[x][y] == 1)
				{
					Vertex v; v.x = x; v.y = y;
					Structure *structure = [[Structure alloc]  initStructure:@"House1" :v :@"House1_damage0.png" :YES :3];
					//Structure *structure = [[Structure alloc] init:@"House1" :v :@"House1_damage0.png" :TRUE :3];
					[self addChild:[structure sprite] z:3];
					[EntityManager add:structure :StructureType];
				}
			}
		}
		 
		 */
	}
	
	return self;
}
- (void) dealloc
{
	//[map release];
	[super dealloc];
}
@end
