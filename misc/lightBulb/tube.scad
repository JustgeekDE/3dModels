
module tube(radius, length, wallThickness = 2){
  innerRadius = radius - wallThickness;
  translate([0,0,length/2])
  difference() {
    cylinder(h = length, r1=radius, r2=radius, center=true);
    cylinder(h = length+10, r1=innerRadius, r2=innerRadius, center=true);
  }
}

$fn = 180;
tube(20, 75, 0.8);
