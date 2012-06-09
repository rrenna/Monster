//  Button.h
//  
//  Created by EricH on 8/3/09.
//  Taken from http://johnehartzog.com/2009/10/easy-to-create-buttons-with-cocos2d/

#import "cocos2d.h"

@interface MButton : CCMenu {
}
+ (id)buttonWithText:(NSString*)text background:(bool)showBackground backgroundImage:(NSString*)fileName backgroundImagePressed:(NSString*)pressedBackgroundImage atPosition:(CGPoint)position target:(id)target selector:(SEL)selector;
+ (id)buttonWithImage:(NSString*)fileName PressedImaged:(NSString*)pressedFileName atPosition:(CGPoint)position target:(id)target selector:(SEL)selector;
@end

@interface ButtonItem : CCMenuItem {
	CCSprite *back;
	CCSprite *backPressed;
	bool showBackground;
}
+ (id)buttonWithText:(NSString*)text background:(bool)showBackground backgroundImage:(NSString*)fileName backgroundImagePressed:(NSString*)pressedBackgroundImage target:(id)target selector:(SEL)selector;
+ (id)buttonWithImage:(NSString*)fileName PressedImaged:(NSString*)pressedFileName target:(id)target selector:(SEL)selector;
- (id)initWithText:(NSString*)text background:(bool)showBackground backgroundImage:(NSString*)fileName backgroundImagePressed:(NSString*)pressedBackgroundImage target:(id)target selector:(SEL)selector;
- (id)initWithImage:(NSString*)fileName PressedImaged:(NSString*)pressedFileName target:(id)target selector:(SEL)selector;
@end