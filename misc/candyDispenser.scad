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
  screwCutout(3.4, length, 6, 14);
}

module gearFixationBolts(scaleFactor = 1){
  boltDiameter = 16.5;
  boltLength = 2.5+0.1;

  color("red")
  translate([0,0,-0.1])
  difference(){
    scale(scaleFactor)
    tube(boltDiameter, boltLength+0.1);

    union(){
      scale(1/scaleFactor)
      translate([0,0,-2*boltLength])
      tube(8, boltLength*5);
      translate([0,-boltDiameter,-2*boltLength])
      cube([2*boltDiameter, 2*boltDiameter, 5*boltLength]);

    }
  }
}

module gearFixationBolts2(scaleFactor = 1){
  boltDiameter = 4.25;
  boltLength = 2.5;

  color("red")
  translate([0,0,-0.1])
  for (a =[0:90:360]) {
    rotate([0,0,a]) {
      translate([0,5.5,0])
      scale(scaleFactor)
      tube(boltDiameter, boltLength+0.1);
    }
  }
}

module candyGear(thickness = 5, bolts=false, bore_diameter = 3.6) {
  gearThickness = thickness - 0.4;
  teeth          = 12;
  circular_pitch = pitchRadius * 30;
  translate([0,0,-0.2])
  union() {
    gear (
        number_of_teeth = teeth,
        circular_pitch  = circular_pitch,
        backlash        = 0.7,
        bore_diameter   = bore_diameter,
        hub_thickness   = gearThickness,
        gear_thickness  = gearThickness,
        rim_thickness   = gearThickness,
        rim_width       = 5,
        circles = 4

    );
    if(bolts == true){
      translate([0,0,gearThickness])
      rotate([0,0,180])
      gearFixationBolts(1);
    }
  }
}

module servoGear(bore, hub) {
  teeth          = 12;
  circular_pitch = pitchRadius * 30;
  thickness = 4;
  difference(){
    gear (
        number_of_teeth = teeth,
        circular_pitch  = circular_pitch,
        backlash        = 0.7,
        bore_diameter   = bore,
        hub_diameter    = 8,
        hub_thickness   = thickness+1,
        gear_thickness  = thickness,
        rim_thickness   = thickness,
        rim_width       = 30,
        circles = 0

    );
    translate([0,0,thickness-1.5
      ])
    tube(hub, 5);
    translate([0,0,-4.0])
    tube(5, 5);
  }
}

module candyPortioner(diameter, length) {
  radius = diameter / 2;

  rotate([0,90,0]) {
    difference() {
      difference(){
        difference() {
          cutoutSize = (length/2) - 4;
          insetDepth = 3;
          cutoutHeight = radius + insetDepth + 1;
          tube(diameter, length);
          translate([insetDepth,0,0])
          translate([0,0,length/2])
          scale([1,(diameter/length),1])
          rotate([90,0,-90])
          rotate([0,0,45])
          cylinder(h = cutoutHeight, r1 = cutoutSize-5, r2 = cutoutSize+10, $fn = 4);
          translate([(diameter/2)-2, -diameter,-length/2])
          cube([10, diameter *2, length *2]);
        }
        gearFixationBolts(1.08);

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

module supportStrut(thickness, width, height, singleSupport, singleSupport = false) {
  strutHeight = min(width, 8);
  translate([-thickness/2, -width/2,0])
  union(){
    cube([thickness,width,height]);
    difference() {
      translate([0,(width-5)/2,strutHeight/2])
      rotate([0,-90,0])
      rotate([-90,0,0])
      union(){
        translate([0,0,0])
        cylinder(5,strutHeight,strutHeight,$fn=3);
        translate([0,thickness,0])
        cylinder(5,strutHeight,strutHeight,$fn=3);

      }
      if(singleSupport == true) {
        translate([thickness/2,-width/2,-height/2])
        cube([width*2,width*2,height*2]);
      }
    }
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

module servoStrut(thickness, width, height, diameter, holeHeight, offsetFromCenter = 0, singleSupport = false) {
  servoThickness = 2.8;
  difference(){
    supportStrutWithHole(thickness, width, height, diameter, holeHeight, offsetFromCenter, singleSupport);
    translate([-servoThickness/2,-width,holeHeight-5])
    cube([servoThickness,2*width, height]);
  }
}

module caseHook(){
  height = 12;
  width = 10;
  strength = 4;
  hookWidth = 6;
  difference(){
    union() {
      translate([-strength/2, -width/2, 0])
      cube([strength,width, height]);
      color("red")
      translate([hookWidth/5,0,height-(hookWidth/2)])
      scale([0.6,1,1])
      rotate([0,45,0])
      cube([hookWidth,width,hookWidth], center=true);
    }
    color("lime")
    translate([-strength, -width, height])
    cube([strength*2,width*2, height]);
    color("purple")
    translate([strength*-2.5, -width,0])
    cube([strength*2,width*2, height]);
  }
}


module basePlate() {
  translate([-37.5,-37.5,0])
  union(){
    cube([75,75,2.5]);
    translate([0,0,2]){

      translate([-2.5,-2.5,0]){
        union(){
          translate([26.7,30.3,0])
          servoStrut(7,7,servoHeight+3, diameter=2.2, holeHeight=servoHeight, offsetFromCenter=1.3);

          translate([26.7,60.3,0])
          servoStrut(7,7,servoHeight+3, diameter=2.2, holeHeight=servoHeight, offsetFromCenter=-1.3);

          translate([23.2,33,0])
          cube([23,25,servoHeight-6.5]);

        }

        translate([62.5,40,0])
        supportStrutWithHole(5,15,dispenserHeigth+5, diameter=3.4, holeHeight=dispenserHeigth);

        translate([12.5,40,0])
        supportStrutWithHole(5,15,dispenserHeigth+5, diameter=3.4, holeHeight=dispenserHeigth, singleSupport = true);
      }

      chuteWidth = 36;
      chuteStrength =2;
      chuteHeight = 15;
      translate([37.5-chuteWidth/2,0,0.9])
      difference(){
        union(){
          difference() {
            difference() {
              difference(){
                translate([-chuteStrength,-1,0])
                union(){
                  color("lime")
                  cube([chuteWidth+2*chuteStrength,25,27]);
                  color("red")
                  translate([0,24,20])
                  rotate([40,0,0])
                  cube([chuteWidth+2*chuteStrength,16,chuteHeight]);
                  translate([0,0,5])
                  rotate([33,0,0])
                  cube([chuteWidth+2*chuteStrength,30,chuteHeight]);
                }
                translate([0,0,5])
                union(){
                  color("purple")
                  rotate([33,0,0])
                  translate([0,-10,chuteStrength])
                  cube([chuteWidth,35.5,chuteHeight+10]);
                  color("green")
                  rotate([40,0,0])
                  translate([0,25,chuteStrength-3.1])
                  cube([chuteWidth,80,chuteHeight+10]);
                }
              }
              color("blue")
              translate([-20,37.5,dispenserHeigth-0.9])
              rotate([0,90,0])
              tube(dispenserDiameter+1,80);
            }
            color("red")
            translate([-5,-40,-5])
            cube([chuteWidth+10,40,80]);
          }
        }
        color("blue")
        translate([0,-1,0]) {
          cube([10,15,3]);
          translate([13,0,0])
          cube([10,15,3]);
          translate([26,0,0])
          cube([10,15,3]);

        }
      }

      translate([73,68,0])
      caseHook();
      translate([73,7,0])
      caseHook();
      translate([2,68,0])
      rotate([0,0,180])
      caseHook();
      translate([2,7,0])
      rotate([0,0,180])
      caseHook();
    }
  }
}

module all(){
  rotation = maxRotation * 2 * abs($t-0.5);

  translate([-20,0,dispenserHeigth])
  rotate([rotation,0,0])
  color("maroon")
  candyPortioner(dispenserDiameter, 40);

  translate([-25,0,dispenserHeigth])
  rotate([180,0,0])
  rotate([rotation,0,0]){
    rotate([0,90,0])
    color("green")
    candyGear(bolts=true);

  }

  translate([-25,0,servoHeight])
  rotate([-rotation,0,0]){
    rotate([0,90,0])
    rotate([0,0,15])
    color("blue")
    servoGear(3.0, 4.65);
  }

  translate([5,0,servoHeight])
  rotate([0,270,0])
  color("purple")
  alignds420(screws=1);

  color("grey")
  basePlate();

  /*translate([-37.5,37.5,0])
  cube([75,1,80]);
  translate([-37.5,-37.5,80])
  cube([75,75,1]);*/
}

$fn = 130;
pitchRadius = 14;
servoHeight = pitchRadius+5;
dispenserHeigth = 2*pitchRadius+servoHeight;
maxRotation = 116;
//$t = 1;
dispenserDiameter = 30;

//all();
//candyPortioner(dispenserDiameter, 40);
//basePlate();
//candyGear(bolts=true);
servoGear(3.0, 4.65);
