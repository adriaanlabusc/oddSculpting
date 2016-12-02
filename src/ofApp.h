#pragma once

#include "ofxiOS.h"
#include "boxPixel.hpp"
#include "ofxGui.h" // using this instead, it's built in

class ofApp : public ofxiOSApp{
	
    public:
        void setup();
        void update();
        void draw();
        void exit();
	
        void touchDown(ofTouchEventArgs & touch);
        void touchMoved(ofTouchEventArgs & touch);
        void touchUp(ofTouchEventArgs & touch);
        void touchDoubleTap(ofTouchEventArgs & touch);
        void touchCancelled(ofTouchEventArgs & touch);

        void lostFocus();
        void gotFocus();
        void gotMemoryWarning();
        void deviceOrientationChanged(int newOrientation);
    
        void drawSculpture(bool drawFlat=true);
        void createBox(int x, int y);
        void rotationButtonPressed();
    
    private:
        float startMouseHold = -1;
        float holdTime;
        int numBoxesCreatedOnHold = 0;
        bool drawNumBoxesOnHold = false;
        float squareWidth = 16;             //width of a box/square
        int boxesX;                         //width in boxes
        int boxesY;
        int screenWidth;                    //width in pixels
        int screenHeight;
        int lastBoxX = -1;                  //index of last box to be created (0 <= lastBoxX < boxesX)
        int lastBoxY = -1;
        vector<BoxPixel> ** boxGrid;
        ofEasyCam cam;
        bool trackmouse;
        ofColor boxColor;
        ofParameter<ofColor> color;
        ofxPanel gui;
        float red, green, blue, alpha;
        ofxButton rotationButton;
        ofxIntSlider intSlider;
};


