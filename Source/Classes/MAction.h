//
//  MAction.h
//  Monster
//
//  Created by Ryan Renna on 10-05-17.
#import "MMove.h"

@interface MAction : NSObject {
	NSMutableArray *moves;
}
@property (retain,readwrite) NSMutableArray* moves;
-(id)initWithMove : (MMove*) pMove;
-(id)initWithMoves : (MMove*) move , ...;
-(id)initWithMoveArray : (NSArray*) moves;
@end
