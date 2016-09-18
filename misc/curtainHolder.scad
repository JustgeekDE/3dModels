module tube(diameter, length) {
  radius = diameter / 2;
  linear_extrude(height = length)
  circle(r = radius);
}

module endPiece(innerDiameter=50) {
  mountingHolesDia = 5;
  screwDiameter = 5.5;
  outerDiameter = 28;
  tubeLength = 30;
  endWall = 3;
  armThickness = 3;
  armLength = 75;

  outerRadius = outerDiameter / 2;

  union(){
    difference() {
      union() {
        tube(outerDiameter, tubeLength);
        translate([-outerRadius, 0, 0])
        cube([outerDiameter, outerRadius, tubeLength]);
      }
      translate([0,0,endWall])
      tube(innerDiameter, tubeLength);
      translate([0,0,-5])
      tube(screwDiameter, 10 + endWall);
    }
    
    color("green")
    difference(){
      translate([-armLength/2, 0, -0.01])
      cube([armLength, outerRadius, endWall]);
      translate([0,0,-5])
      tube(screwDiameter, 10 + endWall);
      
      translate([0,5,-5]) {
        translate([-(outerRadius + mountingHolesDia),0,0])
        tube(mountingHolesDia, 20);
        translate([(outerRadius + mountingHolesDia),0,0])
        tube(mountingHolesDia, 20);
        translate([(armLength/2)-5,0,0])
        tube(mountingHolesDia, 20);
        translate([-((armLength/2)-5),0,0])
        tube(mountingHolesDia, 20);
      }
      
    }

    color("red")
    translate([-armLength/2, outerRadius - armThickness +0.01, 0.02])
    difference(){
      cube([armLength, armThickness, tubeLength]);
      rotate([90,0,0])
      translate([0,0,-5]){
        translate([15,0,0]){
          translate([0,tubeLength-7,0])
          tube(mountingHolesDia, 20);
          translate([0,endWall+7,0])
           tube(mountingHolesDia, 20);
        }
        translate([armLength-15,0,0]){
          translate([0,tubeLength-7,0])
          tube(mountingHolesDia, 20);
          translate([0,endWall+7,0])
           tube(mountingHolesDia, 20);
        }
      }
    }
  }

}

$fn=120;
length=80;

//endPiece(17);
endPiece(20);
