//
//  boxPixel.cpp
//  emptyExample
//
//  Created by Adriaan Labuschagne on 2016-11-08.
//
//

#include "boxPixel.hpp"

//constructor
BoxPixel::BoxPixel() {
    //boxPrimitive.set(4, 4, 4);
    //boxColor.set(color);
}

//constructor
BoxPixel::BoxPixel(float width, float height, float depth, ofColor color) {
    boxPrimitive.set(width, height, depth);
    boxColor.set(color);
}

void BoxPixel::setPosition(float x, float y, float z){
    this->x = x;
    this->y = y;
    this->z = z;
    //ofLog(OF_LOG_NOTICE, "BoxPixel Pixel Postion: " + ofToString(x) + " " + ofToString(y) + " " + ofToString(z));
}

void BoxPixel::move() {
    
    
}

void BoxPixel::draw(bool drawFlat) {
    
    ofSetColor(boxColor);
    
    if (drawFlat) {
        //draw a square here
        ofRect(x,y,boxPrimitive.getWidth(),boxPrimitive.getHeight());
    } else {
        boxPrimitive.setPosition(x, y, z);
        boxPrimitive.draw();
    }
}
