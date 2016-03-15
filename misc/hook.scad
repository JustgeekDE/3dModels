module  donut(diameter, height, precision=100) {
  rotate_extrude(convexity = 10, $fn=precision)
translate([diameter, 0, 0])
circle(r = height, $fn=precision);    
}

module  halfhook(strength, hookDiameter, precision=100) {
    union() {
        difference() {
        donut(hookDiameter, strength, precision);
        union() {
          boxSize = hookDiameter + strength;
          translate([boxSize/2, boxSize/2,0]) 
            cube([boxSize,boxSize,strength*2],true);
          rotate(45,0,0)
            translate([boxSize/2, boxSize/2,0]) 
              cube([boxSize,boxSize,strength*2],true);
          }
        }
        translate([hookDiameter,0,0]) 
        sphere(strength, $fn=precision);
        positionStraight = cos(45) * hookDiameter;
        rotate(a=45, v=[0,0,0]) 
          translate([-positionStraight, positionStraight,0]) 
            rotate(a=[-90,0,-45]) 
              cylinder (h = hookDiameter+1, r=strength, center = false, $fn=precision);        
    }
}

module  hook(strength, hookDiameter, precision=100) {
    union(){
    offset = (1/sin(45)) * hookDiameter;
    translate([0,-offset,0]) 
    halfhook(strength,hookDiameter, precision);

    translate([0,offset,0]) 
    rotate(a=180, v=[0,0,1]) 
    halfhook(strength,hookDiameter, precision);
    }
}

hook(2.0, 6, 100);
