//  Effect.h
//  Monster
//
//  Created by Ryan Renna on 10-05-31.

typedef enum
{
	SelfTarget,
	TeamTarget,
	EnemyTarget,
	AllTarget
} EffectTargetType;
	
@interface MEffect : NSObject {
	double damage;
	double health;
	double energy;
	int moves;
}
@property (readonly) double damage;
@property (readonly) double health;
@property (readonly) double energy;
@property (readonly) int moves;
-(id)initWithDamage : (double) pDamage;
-(id)initWithHealth : (double) pHealth;
-(id)initWithEnergy : (double) pEnergy;
-(id)initWithMoves : (int) pMoves;
-(id)initWithDamage:(double)pDamage andHealth:(double)pHealth andEnergy:(double)pEnergy andMoves:(int)pMoves;
@end
