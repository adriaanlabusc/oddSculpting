#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){	
    screenWidth = ofGetWidth();
    screenHeight = ofGetHeight();
    
    boxesX = floor(screenWidth/squareWidth);
    boxesY = floor(screenHeight/squareWidth);
    
    boxGrid = new vector<BoxPixel>*[boxesX];
    
    //the example had this ++i, I don't know why
    for(int i = 0; i < boxesX; ++i) {
        boxGrid[i] = new vector<BoxPixel>[boxesY];
    }
    
    //apparantly using both vsync and setting the framerate can cause problems
    //ofSetFrameRate(60); //trying to get text to work
    ofSetVerticalSync(true);
    
    trackmouse = false;
    
    boxColor.set(0,0,0);
    
    ofSetLogLevel(OF_LOG_VERBOSE);
    
    rotationButton.addListener(this, &ofApp::rotationButtonPressed);
    
    // change default sizes for ofxGui so it's usable in small/high density screens
    ofxGuiSetFont("Questrial-Regular.ttf",10,true,true);
    ofxGuiSetTextPadding(4);
    ofxGuiSetDefaultWidth(300);
    ofxGuiSetDefaultHeight(18);
    
    gui.setup("panel");
    
    gui.add(color.set("color",ofColor(100,100,140,255),ofColor(0,0),ofColor(255,255))); // replace
    gui.add(rotationButton.setup("rotation"));
}

//--------------------------------------------------------------
void ofApp::update(){
    //mouse button is down
    if(startMouseHold != -1) {
        holdTime = ofGetElapsedTimeMillis() - startMouseHold;
        
        if (holdTime > 750) {
            numBoxesCreatedOnHold++;
            createBox(mouseX, mouseY);
            startMouseHold = ofGetElapsedTimeMillis();
        }
    }
}

//--------------------------------------------------------------
void ofApp::draw(){
    if (trackmouse){
        cam.begin();
        
        //NOTE: the position of ofTranslate is extremely important. I don't know why.
        ofScale(1, -1, 1); // flip the y axis and zoom in a bit
        ofTranslate(-(screenWidth/2),-(screenHeight/2), 0);
        drawSculpture(false);
        
        cam.end();
    }
    else
    {
        drawSculpture();
        if( startMouseHold != -1 && numBoxesCreatedOnHold != 0){
            ofDrawBitmapString(ofToString(numBoxesCreatedOnHold), mouseX - 3, mouseY - 20);
        }
    }
    
    
    gui.draw();
    
    // Drawing labels using this hack becuase
    // there's an issue with the built in labels
    ofSetColor(255,255,255);
    ofDrawBitmapString("R", 19, 67);
    ofDrawBitmapString("G", 19, 86);
    ofDrawBitmapString("B", 19, 105);
    ofDrawBitmapString("A", 19, 124);
    ofDrawBitmapString("rotation toggle", 30, 143);
}

//--------------------------------------------------------------
void ofApp::exit(){

}

// THIS WAS FOR INTERACTING WITH THE GUI
//void ofApp::guiEvent(ofxUIEventArgs &e)
//{
//    string name = e.getName();
//    int kind = e.getKind();
//    ofLog(OF_LOG_NOTICE, "widget name: " + ofToString(name));
//    if(name == "Translucent")
//    {
//        ofxUIToggle *toggle = (ofxUIToggle *) e.getToggle();
//        ofLog(OF_LOG_NOTICE, "toggle: " + ofToString(toggle->getValue()));
//        if (toggle->getValue() == 1) {
//            alpha = 0;
//        } else {
//            alpha = 255;
//        }
//    } else if (name == "Rotation") {
//        trackmouse = !trackmouse;
//    } else if (name == "Zoom") {
//        
//    }
//}

void ofApp::rotationButtonPressed() {
    trackmouse = !trackmouse;
}


void ofApp::drawSculpture(bool drawFlat) {
    for (int i = 0; i < boxesX; i++) {
        for (int j = 0; j < boxesY; j++) {
            for (int k = 0; k < boxGrid[i][j].size(); k++) {
                boxGrid[i][j][k].draw(drawFlat);
            }
        }
    }
}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){
    if (!trackmouse) {
        startMouseHold = ofGetElapsedTimeMillis();
        createBox(touch.x, touch.y);
    }
}

void ofApp::createBox(int x, int y){
    
    //identify the column that was clicked on
    int boxX = (int) ofMap(x, 0, screenWidth, 0, boxesX - 1);
    int boxY = (int) ofMap(y, 0, screenHeight, 0, boxesY - 1);
    
    //don't draw on the ui &&
    //the x, and y parameters are sometimes larger than the window (possibly a bug in OF) and
    //this causes the ofMap to produce values that are too large (also possibly a bug)
    // added a little bit of extra padding to avoid drawing on controls
    if((y > gui.getHeight() + 5 || x > gui.getWidth() + 5) && (boxX < boxesX && boxY < boxesY)) {
        lastBoxX = boxX;
        lastBoxY = boxY;
        
        boxColor.setHex(color->getHex(), color->a);
        
        boxGrid[boxX][boxY].push_back(BoxPixel(squareWidth,squareWidth,squareWidth, boxColor));  //boxes.push_back(ofBoxPrimitive(20,20,20));
        
        //move all the boxes in the affected column down (talking about z axis column here)
        for( int i = 0; i < boxGrid[boxX][boxY].size(); i++){
            // the -5 is there so you can actually see the first cube. Any higher than that you
            // can't see at all.
            boxGrid[boxX][boxY][i].setPosition(boxX * squareWidth, boxY * squareWidth, (i * -squareWidth) - 5);
        }
    }
}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){
    if (!trackmouse) {
        int boxX = (int) ofMap(touch.x, 0, screenWidth, 0, boxesX - 1);
        int boxY = (int) ofMap(touch.y, 0, screenHeight, 0, boxesY - 1);
        
        //if the mouse has moved into a different box (z column) from the last box created
        //we are dragging, and not holding, so restart the hold timer and create a new box
        //we only check lastBoxX for -1 since both are either -1 or not
        if((boxX != lastBoxX || boxY != lastBoxY) && lastBoxX != -1) {
            startMouseHold = ofGetElapsedTimeMillis();
            numBoxesCreatedOnHold = 0;
            createBox(touch.x, touch.y);
        }
    }
}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){
    startMouseHold = -1; //if it's -1 we know the mouse button isn't down
    numBoxesCreatedOnHold = 0;
}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void ofApp::lostFocus(){

}

//--------------------------------------------------------------
void ofApp::gotFocus(){

}

//--------------------------------------------------------------
void ofApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void ofApp::deviceOrientationChanged(int newOrientation){

}

