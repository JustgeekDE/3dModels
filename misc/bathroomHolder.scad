module tube(diameter, length) {
  radius = diameter / 2;
  linear_extrude(height = length)
  circle(r = radius);
}


innerWidth = 10.10;
outerWidth = 13;

module channel(diameter, length, thickness){
  union() {
    translate([0,thickness,length])
    rotate([90,0,0])
    tube(diameter, thickness);
    translate([-(diameter/2),0,0])
    cube([diameter,thickness,length]);
  }
}

module pin(outDiameter = 19.5, innerDiameter = 12, gapHeight = 3) {
  difference() {
    translate([0,5,15])
    union(){
      color("blue")
      rotate([90,0,0])
      tube(outDiameter, 7.5);

      color("green")
      translate([0,gapHeight-0.1,0])
      rotate([90,0,0])
      tube(innerDiameter, gapHeight);

      color("orange")
      translate([0,5.9 + gapHeight,0])
      rotate([90,0,0])
      tube(outDiameter, 6);

    }

    union() {
      color("red")
      channel(outerWidth, 15, 3.2);
      color("green")
      translate([0,-3.5,0])
      channel(innerWidth, 15, 4);

      union() {
        channelDia = 4;
        translate([0,-2.5,15])
        color("pink")
        tube(channelDia, 20);
      }
    }

  }
}

module wedge(lipHeight = 2, lipChannelWidth = 20){
  cubeSize = 30;
  difference(){
    translate([-(cubeSize/2),2.8,15 -(cubeSize/2)])
    union() {
      cube([cubeSize,40,cubeSize]);
    }

    union() {
      translate([0,7.4,-5])
      channel(21.5, 20, 12);
      translate([0,0,-5])
      channel(22, 20, 5.5);
      translate([0,0,-5])
      channel(13.5, 20, 20);
    }
  }
}

module hook() {
  innerDiameter = 12;
  gapHeight = 3;


  width = 20;
  difference() {
    translate([-width/2,-2.5,0.1])
    cube([width,18,30]);
    union() {
      color("red")
      channel(outerWidth, 20, 3.2);
      color("green")
      translate([0,-3.5,0])
      channel(innerWidth, 20, 4);

      translate([0,0,9])
      union(){
        color("red")
        translate([-20,7,-1])
        rotate([0,90,0])
        tube(6, 40);

        rotate([-10,0,0])
        translate([-20,4,0])
        color("pink")
        cube([40,4,40]);
      }
    }
  }
}


$fn = 180;

shimThickness = 0;
lidThickNess = 2;

//hook();
intersection(){
  translate([0,-17,15])
  sphere(r=30);
  union() {
//    pin(20, 12, 3);
    wedge();
  }
}
