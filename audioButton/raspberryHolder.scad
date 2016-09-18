module tube(radius, length, wallThickness = 2){
  innerRadius = radius - wallThickness;
  translate([0,0,length/2])
  difference() {
    cylinder(h = length, r1=radius, r2=radius, center=true);
    cylinder(h = length+10, r1=innerRadius, r2=innerRadius, center=true);
  }
}

module roundedCorner(width, height, radius) {
    circleX = width-radius;
    circleY = height-radius;

    union() {
      square([circleX, height]);
      square([width, circleY]);
      translate([circleX, circleY])
      circle(radius);
    }
}

module roundedRectangle(width, height, radius) {
  for(i=[0:3]){
    rotate(a=(i*90),v=[0,0,1])
    if(i%2 == 0) {
      roundedCorner(width/2, height/2, radius);
    } else {
      roundedCorner(height/2, width/2, radius);
    }
  }
}

module fourCorners(width, depth, distance){
  translate([distance, distance, 0]){
    children();
  }
  translate([width-distance, distance, 0]){
    children();
  }
  translate([distance, depth-distance, 0]){
    children();
  }
  translate([width-distance, depth-distance, 0]){
    children();
  }
}


module basePlate(width, depth, height) {
  linear_extrude(height = height, center = false, convexity = 10, twist = 0)
  roundedRectangle(width, depth, 3);
}

module raspberryPiZero(height=5) {
  width = 65;
  breadth=30;
  holeRadius = 1.5;

  difference() {
    basePlate(width, breadth, height);
    translate([-width/2, -breadth/2,0]){
      fourCorners(width, breadth, 3.5){
        cylinder(h = 2*height+10, r1 = holeRadius, r2 = holeRadius, center = true);
      }
    }
  }
}

module case(){
  radius = 50;
  height = 20;

  color("white")
  union(){
    tube(radius,height, 1);
    translate([0,0,-1])
    cylinder(h = 2, r1=radius, r2=radius, center=true);
  }
}

module holder(){
  width = 78;
  breadth = 78;
  strutHeight = 5.51;
  
 // color("red")
  { 
    difference(){
      difference(){ 
        union(){
          color("red")
          translate([-width/2, -breadth/2, 0]){
            cube([width,10,strutHeight]);
            cube([10,breadth,strutHeight]);
    
            translate([0,breadth-10, 0])
            cube([width,10,strutHeight]);
            
            translate([width-10,0, 0])
            cube([10,breadth,strutHeight]);
          }
          translate([0,0,2.5])
          translate([0,20,0])
          color("green")
          raspberryPiZero(3);
        }
        color("blue")
        translate([-(65/2), 20-(30/2),-2.4]){
          fourCorners(65, 30, 3.5){
            cylinder(h = 30, r1 = 1.6,  r2 = 1.6, center = true);
            cylinder(h = 10, r1 = 3.5,  r2 = 3.5, center = true);
          } 
        }
      }
      translate([0,0,-15])
      tube(70,30,19.8);
    }
  }
}


$fn=140;
//translate([0,0,-2])
//case();
holder();
//translate([0,16,0])
//raspberryPiZero();
