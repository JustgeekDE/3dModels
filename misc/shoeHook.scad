
module tube(radius, length, wallThickness = 2){
  innerRadius = radius - wallThickness;
  translate([0,0,length/2])
  difference() {
    cylinder(h = length, r1=radius, r2=radius, center=true);
    cylinder(h = length+10, r1=innerRadius, r2=innerRadius, center=true);
  }
}

$fn = 180;

union() {
  screwDiameter = 2.5;
  driverDiameter = 3.3;
  wdith = 20;
  distance = 50;
  thickness = 4;
  radius = 20;
  color("red")
  translate([-(wdith/2),-distance+5,0])
  difference(){
    cube([wdith,4,30]);
    rotate(a=90, v=[1,0,0])
    translate([(wdith/2),10,-5]) {
      cylinder(h = 10, r = screwDiameter);
      translate([0,10,0])
      cylinder(h = 10, r = screwDiameter);
    }
  }

  color("blue")
  difference(){
    translate([-(wdith/2),-distance+5,0])
    cube([wdith,distance,thickness]);
    translate([0,radius,-10])
    cylinder(h = 20, r = radius-1);
  }

  color("green")
  difference(){
      translate([0,2,37.5])
      sphere(r=7.5);
    translate([0,radius,-10])
    cylinder(h = 100, r = radius-1);
  }

  color("lime")
  translate([0,radius,0])
  difference() {
    tube(radius, 45, 3);
    translate([-50,0,-5])
    cube([100,100,80]);
    rotate(a=90, v=[1,0,0])
    translate([0,10,12]) {
      cylinder(h = 10, r = driverDiameter);
      translate([0,10,0])
      cylinder(h = 10, r = driverDiameter);
    }
  }
}
