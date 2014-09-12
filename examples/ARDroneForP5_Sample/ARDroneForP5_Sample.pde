import com.shigeodayo.ardrone.processing.*;
import java.lang.*;

ARDroneForP5 ardrone;

String keyValue="";
long preTime = 0;
long nowTime = 0;
boolean moving = false;
int counter = 0;

void setup() {
  size(960, 720);

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

int linearSpeed() {
  long deltaTime = System.currentTimeMillis()/1000 - preTime;
  if (deltaTime < 3) {
    return int(deltaTime)*5+20;
    // return int(deltaTime)*3+20;
  }
  else {
    return 35;
  }
}

void draw() {
  background(204);  
    if (moving) {
      if (keyValue.equals("UP")) {
        ardrone.forward(linearSpeed()); // go forward
      }
      else if (keyValue.equals("DOWN")) {
        ardrone.backward(linearSpeed()); // go backward
      }
      else if (keyValue.equals("LEFT")) {
        ardrone.goLeft(linearSpeed()); // go left
      }
      else if (keyValue.equals("RIGHT")) {
        ardrone.goRight(linearSpeed()); // go right
      }
    }

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
}

void move(){
  moving = true;
  preTime = System.currentTimeMillis() / 1000;
}

// controlling AR.Drone through key input
void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP && !keyValue.equals("UP")) {
      keyValue = "UP";
      move();
    } 
    else if (keyCode == DOWN && !keyValue.equals("DOWN")) {
      keyValue = "DOWN";
      move();
    } 
    else if (keyCode == LEFT && !keyValue.equals("LEFT")) {
      keyValue = "LEFT";
      move();
    } 
    else if (keyCode == RIGHT && !keyValue.equals("RIGHT")) {
      keyValue = "RIGHT";
      move();
    } 
    else if (keyCode == SHIFT) {
      moving = false;
      ardrone.takeOff(); // take off, AR.Drone cannot move while landing
      keyValue = "";
    } 
    else if (keyCode == CONTROL) {
      moving = false;
      ardrone.landing();
      keyValue = "";
      // landing
    }
  } 
  else {
    moving = false;
    if (key == 's') {
      nowTime = System.currentTimeMillis() / 1000;
      try {
        if (keyValue.equals("UP")) {
          ardrone.backward(100);
        }
        else if (keyValue.equals("DOWN")) {
          ardrone.forward(100);
        }
        else if (keyValue.equals("LEFT")) {
          ardrone.goRight(100);
        }
        else if (keyValue.equals("RIGHT")) {
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
    else {
      keyValue = "";
      if (key == 'r') {
        ardrone.spinRight(); // spin right
      } 
      else if (key == 'e') {  
        ardrone.spinLeft(); // spin left
      } 
      else if (key == 't') {
        ardrone.up(); // go up
      }
      else if (key == 'g') {
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
}

