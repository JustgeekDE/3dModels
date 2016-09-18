module tube(diameter, length) {
  radius = diameter / 2;
  linear_extrude(height = length)
  circle(r = radius);
}

$fn=120;
length=80;

rotate([90,0,0])
difference(){
  union(){
    tube(40,length);
    translate([-6,0,0])
    tube(42,2);
    translate([-6,0,length-2])
    tube(42,2);

  }
  translate([-10,-4,-5])
  cube([30,8,90]);
}
