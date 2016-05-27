module linearTriangle(sideLength, linearLength) {
  linear_extrude(height = linearLength)
  circle((sideLength / sqrt(3)),$fn=3);
}

module hollowRail(sideLength, linearLength, wallThickness = 2) {
  difference() {
    linearTriangle(sideLength,linearLength);
    translate([0,0,-5])
    linearTriangle(sideLength-wallThickness,linearLength+10);
  }
}

hollowRail(12,90);
