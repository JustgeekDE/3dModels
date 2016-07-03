
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
  wdith = 20;
  distance = 50;
  thickness = 4;
  radius = 20;
  translate([-(wdith/2),-distance+5,0])
  difference(){
    cube([wdith,4,30]);
    translate([(wdith/2),5,10])
    rotate(a=90, v=[1,0,0])
    cylinder(h = 10, r = 2.5);
    translate([(wdith/2),5,20])
    rotate(a=90, v=[1,0,0])
    cylinder(h = 10, r = 2.5);
  }

  difference(){
    translate([-(wdith/2),-distance+5,0])
    cube([wdith,distance,thickness]);
    translate([0,radius,-10])
    cylinder(h = 20, r = radius-1);
  }

  difference(){
      translate([0,2,37.5])
      sphere(r=7.5);
    translate([0,radius,-10])
    cylinder(h = 100, r = radius-1);
  }

  translate([0,radius,0])
  difference() {
    tube(radius, 45, 3);
    translate([-50,0,-5])
    cube([100,100,80]);

  }
}
