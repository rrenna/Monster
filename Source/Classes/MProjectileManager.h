//  MProjectileManager.h
//  Monster-99.3

#import "cocos2d.h"
#import "LevelScene.h"
#import "MProjectile.h"
#import "MIManager.h"

@class UnitLayer;

@interface MProjectileManager : NSObject <MIManager> {
}
+(void)initWithLayer : (UnitLayer*) pProjectileLayer;
+(BOOL)isProcessing;
+(UnitLayer*)getUnitLayer;
+(NSString*)getNextProjectileName;
+(void)add : (MProjectile*) pProjectile;
+(void)remove : (MProjectile*) pProjectile;
@end
