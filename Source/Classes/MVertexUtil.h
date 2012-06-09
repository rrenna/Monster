//  Vertex.h
//  Monster
//
//  Created by Ryan Renna on 10-05-08.

typedef struct
{
	int x;
	int y;
}Vertex;

@interface MVertexUtil : NSObject
{
}
+(BOOL)VertexEqual : (Vertex) pV1 : (Vertex) pV2;
+(double)VertexDistance:(Vertex) pV1 : (Vertex) pV2;
+(NSString*)VertexLocationKey : (Vertex) pV;
@end

