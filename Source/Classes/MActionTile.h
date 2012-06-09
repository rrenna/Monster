//  ActionTile.h
//  Monster
//
//  Created by Ryan Renna on 10-05-17.

#import "cocos2d.h"
#import "MAction.h"

typedef enum
{
	MovementAction,
	MeleeAttackAction,
	RangedAttackAction,
	DefensiveAction,
	MixedAction
}ActionType;

@interface MActionTile : NSObject {
	CCSprite *sprite;
	NSMutableArray *actions;
	ActionType type;
	BOOL selected;
	
}
@property (retain,readonly) CCSprite *sprite;
@property (retain,readonly) NSMutableArray *actions;
@property (readonly) ActionType type;
-(id)initWithType :(ActionType) pType;
-(void)changeType :(ActionType) pType;
-(void)setSelected : (BOOL) pSelected;
-(void)refreshSprite;
-(CCSpriteFrame*)getFrame;
-(CGRect) rect;
@end
