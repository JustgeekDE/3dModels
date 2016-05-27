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

module fourCorners(width, depth){
  for(i=[0:1:1]) {
      rotate(a=i*180, v=[0,0,1]) {
        translate([width/2-4,depth/2-4,0])
        children();
        translate([-(width/2-4),depth/2-4,0])
        rotate(a=90, v= [0,0,1])
        children();
      }
  }
}

module basePlate(width, depth, height, growth=0) {
  linear_extrude(height = height, center = false, convexity = 10, twist = 0)
  roundedRectangle(width+growth, depth+growth, 3+(growth/2));
}

module cylinderThing(diameter, corners=4, slopeHeight = 15) {
  rotate(a=45, v=[0,0,1])
  union() {
    translate([0,0,slopeHeight/2])
    cylinder(h = slopeHeight, r1 = 2, r2 = diameter, center = true, $fn = corners);
    translate([0,0,(slopeHeight-0.01)])
    linear_extrude(height = 80)
    circle(diameter, $fn = corners);
    translate([0,0,-70])
    linear_extrude(height = 160)
    circle(2, $fn = corners);
  }
}


module toothpasteHolder() {
  cylinderThing(15,120);
}

module toothbrushHolder() {
  union(){
    translate([0,-5,0])
    cylinderThing(10,4);
    translate([0,5,0])
    cylinderThing(10,4);

  }
}

module razorHolder() {
  union(){
    cylinderThing(20,4);
  }
}


module scraperHolder() {
  union(){
    toothbrushHolder();
  }
}

module grid(width, depth, strength) {
  endX = (width/2) - (1 * strength);
  startX = -endX;
  endY = (depth/2) - strength;
  startY = -endY;
  union() {
    for(x = [ startX: strength*2 : endX]){
      translate([x, -depth/2, 0])
      cube([strength, depth, strength]);
    }
    for(y = [ startY-(strength/2): strength*2 : endY]){
      translate([-width/2, y, 0])
      cube([width, strength, strength]);
    }
  }
}

$fn=100;
thinBorder = 17;
width = 58;
breadth = 70;

difference() {
  union() {
    basePlate(58,70,70);
    translate([0,0,-5])
    difference() {
      feetThickness = 8;
      basePlate(width-5,breadth-5,30);
      translate([0,0,-20])
      union(){
        basePlate(width-5-feetThickness,breadth-5-feetThickness,60);
        translate([0,0,30])
        union(){
          cube([width-30, 100, 60], center = true);
          cube([100, breadth-30, 60], center = true);
        }
      }
    }
  }
  translate([0,0,10])
  union(){
    translate([-10,-thinBorder,0])
    toothpasteHolder();
    translate([thinBorder,-thinBorder,20])
    toothbrushHolder();
    translate([12,16,0])
    razorHolder();
    translate([-thinBorder,thinBorder,0])
    scraperHolder();
  }
}
