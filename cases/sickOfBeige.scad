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
  roundedRectangle(width+growth, depth+growth, 4+(growth/2));
}

module basePlateWithHoles(width, depth, height, growth=0) {
  holeRadius = 1.8;
  difference() {
    basePlate(width, depth, height, growth);
    fourCorners(width, depth){
      cylinder(h = height+2, r1 = holeRadius, r2 = holeRadius, center = true);
    }
  }
}

module feet(radius, thickness, height){
  outerDiameter = radius+thickness;
  translate([0,0,height/2])
  difference(){
    difference(){
      cylinder(h = height, r1 = outerDiameter, r2 = outerDiameter, center = true);
      cylinder(h = height+4, r1 = radius, r2 = radius, center = true);
    }
    union(){
      translate([(-outerDiameter/2)-1, 0, 0])
      cube([outerDiameter+2, 3*outerDiameter, height+2], center = true);
      translate([outerDiameter/2, (-outerDiameter/2)-1, 0])
      cube([2*outerDiameter, outerDiameter+2, height+2], center = true);
    }
  }

}

module addFeet(width, depth, radius, thickness, height){
  fourCorners(width, depth){
    translate([0,0,(height/2)])
    feet(radius,thickness,height);
  }
}

module addPillars(width, depth, pillarHeight, innerDiameter, outerDiameter){
  fourCorners(width, depth){
    translate([0,0,pillarHeight / 2]){
      difference(){
        innerRadius = innerDiameter / 2;
        outerRadius = outerDiameter / 2;
        cylinder(h = pillarHeight, r1 = outerRadius, r2 = outerRadius, center = true);
        cylinder(h = pillarHeight+4, r1 = innerRadius, r2 = innerRadius, center = true);
      }
    }
  }
}

module bottomHull(width, depth, height, wallThickness, pillarHeight, feetHeight, screwSink){

  bottomThickness = 1;

  pillarWidth = 2;
  pillarClearence = 0.2;

  wallThickness = 1.6;
  boardTolerance = 0.3;

  difference() {
    union() {
      difference(){
        totalHeight = height+bottomThickness;
        basePlateWithHoles(width, depth, totalHeight, boardTolerance+wallThickness);
        translate([0,0,bottomThickness]){
          basePlate(width, depth, totalHeight+1, boardTolerance);
        }
      }
      translate([0,0,bottomThickness]){
        pillarDiameter = 3.6 + pillarClearence;
        pillarOuterDiameter = pillarDiameter + 2 * pillarWidth;
        addPillars(width, depth, pillarHeight, pillarDiameter, pillarOuterDiameter);
      }
      translate([0,0,-1.5*feetHeight]){
        addFeet(width, depth,3,1,feetHeight);
      }
    }
    translate([0,0,0]){
      fourCorners(width, depth){
        translate([0,0,0])
        cylinder(h = screwSink*2, r1 = 3, r2 = 3, center = true);
      }
    }

  }
}

$fn=180;

width = 50;
depth = 32;
height=4;
pillarHeight= 2.8;
feetHeight = 0;
wallThickness= 1;
screwSink = 3;

bottomHull(width, depth, height, wallThickness, pillarHeight, feetHeight, screwSink);
