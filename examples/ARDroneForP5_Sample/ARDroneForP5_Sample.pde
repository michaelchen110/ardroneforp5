import com.shigeodayo.ardrone.processing.*;
import java.lang.*;

ARDroneForP5 ardrone;

String keyValue="";
long preTime = 0;
long nowTime = 0;
char last_command='p';

void setup() {
  size(960, 720);
  frameRate(400);
  ardrone=new ARDroneForP5("192.168.1.1", ARDroneVersion.ARDRONE2);
  // connect to the AR.Drone
  ardrone.connect();
  // for getting sensor information
  ardrone.connectNav();
  // for getting video informationp
  ardrone.connectVideo();
  // start to control AR.Drone and get sensor and video data of it
  ardrone.start();
}

void draw() {
  background(204);  

  // getting image from AR.Drone
  // true: resizeing image automatically
  // false: not resizing
  PImage img = ardrone.getVideoImage(false);
  if (img == null)
    return;
  image(img, 0, 0);

  // print out AR.Drone information
//  ardrone.printARDroneInfo();

  // getting sensor information of AR.Drone
  float pitch = ardrone.getPitch();
  float roll = ardrone.getRoll();
  float yaw = ardrone.getYaw();
  float altitude = ardrone.getAltitude();
  float[] velocity = ardrone.getVelocity();
  int battery = ardrone.getBatteryPercentage();

  String attitude = "pitch:" + pitch + "\nroll:" + roll + "\nyaw:" + yaw + "\naltitude:" + altitude;
  text(attitude, 20, 85);
  String vel = "vx:" + velocity[0] + "\nvy:" + velocity[1];
  text(vel, 20, 140);
  String bat = "battery:" + battery + " %";
  text(bat, 20, 170);
  if (keyCode == last_command) 
    key();
  last_command=(char)keyCode;
}

// controlling AR.Drone through key input
void key() {
  if (key == CODED) {
    preTime = System.currentTimeMillis() / 1000;
    if (keyCode == UP) {
      keyValue = "UP";
      ardrone.forward(20); // go forward
    } 
    else if (keyCode == DOWN) {
      keyValue = "DOWN";
      ardrone.backward(20); // go backward
    } 
    else if (keyCode == LEFT) {
      keyValue = "LEFT";
      ardrone.goLeft(20); // go left
    } 
    else if (keyCode == RIGHT) {
      keyValue = "RIGHT";
      ardrone.goRight(20); // go right
    } 
    else if (keyCode == SHIFT) {
      ardrone.takeOff(); // take off, AR.Drone cannot move while landing
    } 
    else if (keyCode == CONTROL) {
      ardrone.landing();
      // landing
    }
  } 
  else {
    if (key == 's') {
      nowTime = System.currentTimeMillis() / 1000;

      try {
        if (keyValue == "UP") {
          ardrone.backward(100);
        }
        else if (keyValue == "DOWN") {
          ardrone.forward(100);
        }
        else if (keyValue == "LEFT") {
          ardrone.goRight(100);
        }
        else if (keyValue == "RIGHT") {
          ardrone.goLeft(100);
        }
        else {
          preTime = nowTime;
        } 
        Thread.sleep((nowTime-preTime)*300);
        keyValue = "";
      } catch (Exception e) {}

      ardrone.stop(); // hovering
    } 
    else if (key == 'r') {
      ardrone.spinRight(); // spin right
    } 
    else if (key == 'l') {
      ardrone.spinLeft(); // spin left
    } 
    else if (key == 'u') {
      ardrone.up(); // go up
    }
    else if (key == 'd') {
      ardrone.down(); // go down
    }
    else if (key == '1') {
      ardrone.setHorizontalCamera(); // set front camera
    }
    else if (key == '2') {
      ardrone.setHorizontalCameraWithVertical(); // set front camera with second camera (upper left)
    }
    else if (key == '3') {
      ardrone.setVerticalCamera(); // set second camera
    }
    else if (key == '4') {
      ardrone.setVerticalCameraWithHorizontal(); //set second camera with front camera (upper left)
    }
    else if (key == '5') {
      ardrone.toggleCamera(); // set next camera setting
    }
  }
}