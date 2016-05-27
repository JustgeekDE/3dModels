use <MCAD/involute_gears.scad>
use <MCAD/servos.scad>

module tube(diameter, length) {
  radius = diameter / 2;
  linear_extrude(height = length)
  circle(r = radius);
}

module screwCutout(shaftDiameter, shaftLength, headDiameter, headLength) {
  union() {
    tube(shaftDiameter, shaftLength+0.1);
    translate([0,0,shaftLength])
    tube(headDiameter, headLength);
  }
}

module m3Cutout(length) {
  screwCutout(3.4, length, 5.5, 5);
}

module gearFixationBolts(scaleFactor = 1){
  boltDiameter = 2.5;
  boltLength = 2.5;

  color("red")
  translate([0,0,-0.1])
  for (a =[0:90:360]) {
    rotate([0,0,a]) {
      translate([0,5,0])
      scale(scaleFactor)
      tube(boltDiameter, boltLength+0.1);
    }
  }
}

module candyGear(thickness = 5, bolts=false) {
  gearThickness = thickness - 0.4;
  teeth          = 12;
  circular_pitch = 330;
  translate([0,0,-0.2])
  union() {
    gear (
        number_of_teeth = teeth,
        circular_pitch  = circular_pitch,
        backlash        = 0.7,
        bore_diameter   = 0,
        hub_thickness   = gearThickness,
        gear_thickness  = gearThickness,
        rim_thickness   = gearThickness,
        rim_width       = 5,
        circles = 4,
        bore_diameter = 3.4

    );
    if(bolts == true){
      translate([0,0,gearThickness])
      gearFixationBolts();
    }
  }
}

module candyPortioner(diameter, length) {
  radius = diameter / 2;

  rotate([0,90,0]) {
    difference() {
      difference(){
        difference() {
          cutoutSize = (length/2) - 4;
          insetDepth = 6;
          cutoutHeight = radius + insetDepth + 1;
          tube(diameter, length);
          translate([insetDepth,0,0])
          translate([0,0,length/2])
          scale([1,(diameter/length),1])
          rotate([90,0,-90])
          rotate([0,0,45])
          cylinder(h = cutoutHeight, r1 = cutoutSize, r2 = cutoutSize+5, $fn = 4);
        }
        gearFixationBolts(1.1);

      }
      color("white") {
        shaftLength = 25;
        translate([0,0,-shaftLength+3])
        m3Cutout(shaftLength);
        rotate([0,180,0])
        translate([0,0,-length-shaftLength+3])
        m3Cutout(shaftLength);
      }
    }
  }
}

module supportStrut(thickness, width, height, singleSupport) {
  translate([-thickness/2, -width/2,0])
  union(){
    cube([thickness,width,height]);
    translate([thickness/2,(width-thickness)/2,width/2])
    rotate([0,-90,0])
    rotate([-90,0,0])
    cylinder(thickness,width,width,$fn=3);
  }
}

module supportStrutWithHole(thickness, width, height, diameter, holeHeight, offsetFromCenter = 0, singleSupport = false) {
  difference(){
    supportStrut(thickness, width, height, singleSupport);
    translate([-thickness,offsetFromCenter,holeHeight])
    rotate([0,90,0])
    tube(diameter, 2*thickness);
  }
}


module basePlate() {
  color("grey")
  union(){
    cube([80,80,1]);

    translate([29.2,30.3,0])
    union() {
      supportStrutWithHole(2,7,22, diameter=2.2, holeHeight=15, offsetFromCenter=1.3);
      translate([5,0,0])
      supportStrutWithHole(2,7,22, diameter=2.2, holeHeight=15, offsetFromCenter=1.3);
    }

    translate([29.2,60.3,0])
    union() {
      supportStrutWithHole(2,7,22, diameter=2.2, holeHeight=15, offsetFromCenter=-1.3);
      translate([5,0,0])
      supportStrutWithHole(2,7,22, diameter=2.2, holeHeight=15, offsetFromCenter=-1.3);
    }

    translate([56.5,40,0])
    supportStrutWithHole(2,10,42, diameter=3.4, holeHeight=37);

    translate([18.5,40,0])
    supportStrutWithHole(2,10,42, diameter=3.4, holeHeight=37);
  }
}

module all(){
  translate([-15,0,37])
  candyPortioner(30, 30);

  translate([-20,0,37])
  rotate([0,90,0])
  color("green")
  candyGear(bolts=true);

  translate([-20,0,15])
  rotate([0,90,0])
  rotate([0,0,15])
  color("blue")
  candyGear();

  translate([10,0,15])
  rotate([0,270,0])
  color([0.3,0,0.3])
  alignds420(screws=1);

  translate([-40,-40,0])
  basePlate();
}

$fn = 70;


all();
