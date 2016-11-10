//
//  boxPixel.hpp
//  emptyExample
//
//  Created by Adriaan Labuschagne on 2016-11-08.
//
//

#ifndef boxPixel_hpp
#define boxPixel_hpp

#include <stdio.h> // this wasn't in the original, might have to remove it
#include <ofMain.h>


class BoxPixel {
public:
    //constructor
    BoxPixel();
    //constructor
    BoxPixel(float width, float height, float depth, ofColor color);
    
    
    //Methods
    void move();
    void draw(bool drawFlat=false);
    void setPosition(float x, float y, float z);
    
    
private:
    float x;
    float y;
    float z;
    ofBoxPrimitive boxPrimitive;
    ofColor boxColor;
    
};








#endif /* boxPixel_hpp */
