
module bulb(bulbRadius, baseRadius, baseHeight, coneOffset) {
  coneTopRadius = sqrt((bulbRadius * bulbRadius) - (coneOffset * coneOffset));

  translate([0,0,baseHeight+coneOffset])
  rotate([180,0,0])
  union() {
    union() {
      sphere(r = bulbRadius);
      translate([0, 0, coneOffset])
        cylinder(h = baseHeight, r1 = coneTopRadius, r2 = baseRadius);
    }
  }
}

module holloWBulb(bulbRadius, baseRadius, baseHeight, coneOffset, sacleFactor = 0.9) {
  totalHeight = bulbRadius + baseHeight + coneOffset;
  offset = (totalHeight * (1.0 - sacleFactor) / 2);
  difference() {
    bulb(bulbRadius, baseRadius, baseHeight, coneOffset);
    union() {
      translate([0,0,offset])
      scale(0.9) {
        bulb(bulbRadius, baseRadius, baseHeight, coneOffset);
        translate([0,0,-10])
        cylinder(h = 20, r1=baseRadius, r2=baseRadius);

      }
    }
  }
}

module tube(radius, length, wallFactor=0.9) {
  translate([0,0,length/2])
  difference() {
    cylinder(h = length, r1=radius, r2=radius, center=true);
    scale(0.9) {
      cylinder(h = length*2, r1=radius, r2=radius, center=true);
    }
  }
}

$fn = 100;
bulbRadius = 25;
baseRadius = 14;
baseLength = 25;

union(){
  translate([0,0,baseLength-0.1])
  holloWBulb(bulbRadius, baseRadius, 25, 9);
  tube(baseRadius, baseLength);

}
