#import "MButton.h"


@implementation MButton
+ (id)buttonWithText:(NSString*)text background:(bool)showBackground backgroundImage:(NSString*)fileName backgroundImagePressed:(NSString*)pressedBackgroundImage atPosition:(CGPoint)position target:(id)target selector:(SEL)selector
{
	CCMenu *menu = [CCMenu menuWithItems:[ButtonItem buttonWithText:text background:showBackground backgroundImage:fileName backgroundImagePressed:pressedBackgroundImage target:target selector:selector], nil];
	menu.position = position;
	return menu;
	
}
+ (id)buttonWithImage:(NSString*)fileName PressedImaged:(NSString*)pressedFileName atPosition:(CGPoint)position target:(id)target selector:(SEL)selector
{
	ButtonItem *item = [ButtonItem buttonWithImage:fileName PressedImaged:pressedFileName target:target selector:selector];
	CCMenu *menu = [CCMenu menuWithItems:item, nil];
	menu.position = position;
	return menu;
}
@end

@implementation ButtonItem
+ (id)buttonWithText:(NSString*)text background:(bool)showBackground backgroundImage:(NSString*)fileName backgroundImagePressed:(NSString*)pressedBackgroundImage target:(id)target selector:(SEL)selector
{
	return [[[self alloc] initWithText:text background:showBackground backgroundImage:fileName backgroundImagePressed:pressedBackgroundImage target:target selector:selector] autorelease];
}
+ (id)buttonWithImage:(NSString*)fileName PressedImaged:(NSString*)pressedFileName target:(id)target selector:(SEL)selector
{
	return [[[self alloc] initWithImage:fileName PressedImaged:pressedFileName target:target selector:selector] autorelease];
}
- (id)initWithText:(NSString*)text background:(bool)pShowBackground backgroundImage:(NSString*)fileName backgroundImagePressed:(NSString*)pressedBackgroundImage target:(id)target selector:(SEL)selector
{
	if((self = [super initWithTarget:target selector:selector])) {
		
		showBackground = pShowBackground;
		back = [[CCSprite spriteWithFile:fileName] retain];
		backPressed = [[CCSprite spriteWithFile:pressedBackgroundImage] retain];
		back.anchorPoint = ccp(0,0);
		backPressed.anchorPoint = ccp(0,0);
		if(showBackground)
		{
			[self addChild:back];
		}
		self.contentSize = back.contentSize;
    
		CCLabelTTF* textLabel = [CCLabelTTF labelWithString:text fontName:@"Helvetica" fontSize:25];
		textLabel.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
		textLabel.anchorPoint = ccp(0.5, 0.3);
		[self addChild:textLabel z:1];
	}
	return self;	
}
- (id)initWithImage:(NSString*)fileName PressedImaged:(NSString*)pressedFileName target:(id)target selector:(SEL)selector
{
	if((self = [super initWithTarget:target selector:selector])) 
	{
		showBackground = YES;
		back = [[CCSprite spriteWithFile:fileName] retain];
		back.anchorPoint = ccp(0,0);
		backPressed = [[CCSprite spriteWithFile:pressedFileName] retain];
		backPressed.anchorPoint = ccp(0,0);
		[self addChild:back];
		self.contentSize = back.contentSize;
	}
	return self;
}
-(void) selected {
	[self removeChild:back cleanup:NO];
	if(showBackground)
	{
	[self addChild:backPressed];
	}
	[super selected];
}

-(void) unselected {
	[self removeChild:backPressed cleanup:NO];
	if(showBackground)
	{
	[self addChild:back];
	}
	[super unselected];
}

// this prevents double taps
- (void)activate {
	[super activate];
	[self setIsEnabled:NO];
	[self schedule:@selector(resetButton:) interval:0.5];
}

- (void)resetButton:(ccTime)dt {
	[self unschedule:@selector(resetButton:)];
	[self setIsEnabled:YES];
}
- (void)dealloc {
	[back release];
	[backPressed release];
	[super dealloc];
}

@end