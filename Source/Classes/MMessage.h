//  Message.h
//  Monster
//
//  Created by Ryan Renna on 10-05-26.

typedef enum
{
	UpdateMessage,
	TransformationMessage,
	FireProjectileMessage,
	DamageMessage,
	SpriteChangeMessage,
	ActivityStateChangeMessage
} MessageType;

typedef enum
{
	UnitType,
	StructureType,
	AnyType
}EntityType;

@interface MMessage : NSObject {
	NSString *sender;
	NSString *reciever;
	EntityType entityType;
	MessageType messageType;
	NSObject *value;
	float delay;
}
@property (retain,readonly) NSString* sender;
@property (retain,readonly) NSString* reciever;
@property (readonly) EntityType entityType;
@property (readonly) MessageType messageType;
@property (readwrite) float delay;
@property (retain,readonly) NSObject* value;

-(id)initWithSender : (NSString*) pSender andReciever: (NSString*) pReciever andEntityType:(EntityType) pEntityType andMessageType: (MessageType) pMessageType andValue:(NSObject*) pValue;
-(id)initWithSender : (NSString*) pSender andReciever: (NSString*) pReciever andEntityType:(EntityType) pEntityType andMessageType: (MessageType) pMessageType andValue:(NSObject*) pValue andDelay : (float) pDelay;

@end
