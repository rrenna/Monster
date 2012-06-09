//  MObject.h
//  Monster-99.3
//
//  Created by Ryan Renna on 10-06-06.

#import "cocos2d.h"
#import "MVertexUtil.h"

@interface MObject : NSObject {
	CCSprite *sprite;
	NSString *name;
	Vertex position;
	int rotation;
	BOOL clean;
}
@property (retain,readwrite) CCSprite *sprite;
@property (retain,readonly) NSString *name;
@property (readwrite) Vertex position;
@property (readwrite) int rotation;
@property (readonly) BOOL clean;
-(id)initWithName: (NSString*) pName;
-(void)setCleaned;
-(void)kill;
-(void)performDamage : (NSNumber*) pDamage withForce: (CGPoint) pForce;
-(NSString*) key;
@end
