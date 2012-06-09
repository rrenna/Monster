//  MMessage.m
//  Monster
//
//  Created by Ryan Renna on 10-05-26.

#import "MMessage.h"

@implementation MMessage
@synthesize sender;
@synthesize reciever;
@synthesize entityType;
@synthesize messageType;
@synthesize delay;
@synthesize value;

-(id)init
{
	if((self = [super init]))
	{
	}
	return self;
}
-(id)initWithSender : (NSString*) pSender andReciever: (NSString*) pReciever andEntityType:(EntityType) pEntityType andMessageType: (MessageType) pMessageType andValue:(NSObject*) pValue
{
	return [self initWithSender:pSender andReciever:pReciever andEntityType:pEntityType andMessageType:pMessageType andValue:pValue andDelay:0];
}

-(id)initWithSender : (NSString*) pSender andReciever: (NSString*) pReciever andEntityType:(EntityType) pEntityType andMessageType: (MessageType) pMessageType andValue:(NSObject*) pValue andDelay : (float) pDelay
{
	if((self = [super init]))
	{
		sender = [pSender retain];
		reciever = [pReciever retain];
		entityType = pEntityType;
		messageType = pMessageType;
		value = [pValue retain];
		delay = pDelay;
	}
	return self;
}
-(void)dealloc
{
	[sender release];
	[reciever release];
	[value release];
	[super dealloc];
}
@end
