//  Vertex.m
//  Monster
//
//  Created by Ryan Renna on 10-05-31.

#import "MVertexUtil.h"

@implementation MVertexUtil
+(BOOL)VertexEqual : (Vertex) pV1 : (Vertex) pV2
{
	if (pV1.x == pV2.x) 
	{
		if(pV1.y == pV2.y)
		{
			//Vectors are identical
			return YES;	
		}
	}
	//Else, Vectors are different
	return NO;
	
}
+(double)VertexDistance:(Vertex) pV1 : (Vertex) pV2
{
	double diffXSquare = pow(pV1.x - pV2.x,2);
	double diffYSquare = pow(pV1.y - pV2.y,2);
	return sqrt(diffXSquare + diffYSquare);
}

+(NSString*)VertexLocationKey : (Vertex) pV
{
	return [NSString stringWithFormat:@"%i-%i",pV.x,pV.y];
}
@end
