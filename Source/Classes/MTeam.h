//  team.h
//  Monster
//
//  Created by Ryan Renna on 10-05-24.

@class MEntity;

@interface MTeam : NSObject {
	UIColor *color;
	MEntity *mainEntity;
	BOOL controlled;
}
@property (retain,readonly)MEntity* mainEntity;
@property (readonly) BOOL controlled;
-(id)initWithColor:(UIColor*) pColor isPlayerControlled:(BOOL)pControlled;
-(void)setMainEntity:(MEntity*) pEntity;
@end
