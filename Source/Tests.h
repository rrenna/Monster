//
//  untitled.h
//  Monster-99.3
//
//  Created by Ryan Renna on 10-06-26.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
//  See Also: http://developer.apple.com/iphone/library/documentation/Xcode/Conceptual/iphone_development/135-Unit_Testing_Applications/unit_testing_applications.html

//  Application unit tests contain unit test code that must be injected into an application to run correctly.
//  Define USE_APPLICATION_UNIT_TEST to 0 if the unit test code is designed to be linked into an independent test executable.

#define USE_APPLICATION_UNIT_TEST 0

#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>

#import "MTeam.h"
#import "MMatch.h"
#import "MMap.h"
//Gui
#import "MActionTile.h"
#import "MButton.h"
//Skills
#import "MSkill.h"
#import "MEffect.h"
#import "MSkillChest.h"
//Managers
//#import "MEntityManager.h"
#import "MMessage.h"
//#import "MProjectileManager.h"
//#import "MActor.h"
//Objects
#import "MProjectile.h"
//#import "MEntity.h"
//#import "MUnit.h"
//#import "MStructure.h"
#import "MMove.h"
#import "MObject.h"
//Brains
//#import "MPersona.h"
//#import "MAStarSearch.h"
#import "MVertexUtil.h"
#import "MSettings.h"

@interface Tests : SenTestCase 
{
	Class TestMTeam;
	Class TestMMatch;
	Class TestMMap;
	Class TestMAction;
	Class TestMButton;
	Class TestMSkill;
	Class TestMEffect;
	Class TestMSkillChest;
	Class TestMMessage;
	Class TestMProjectile;
	Class TestMMove;
	Class TestMObject;
	Class TestMVertexUtil;
	Class TestMSetting;
}

#if USE_APPLICATION_UNIT_TEST
- (void) testAppDelegate;       // simple test on application
#else
#endif

@end
