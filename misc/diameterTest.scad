module tube(diameter, length) {
  radius = diameter / 2;
  linear_extrude(height = length)
  circle(r = radius);
}

module hole(dia) {
  union(){
    tube(dia, 20);
    translate([0,10,10])
    linear_extrude(height = 10)
    text(str(dia), size=10, halign="center", font="Liberation Sans:style=Bold Italic");

  }
}

$fn=120;
difference(){
  cube([75,30,6]);
  color("blue")
  translate([7,7,-6]){
    for(dia = [0 : 1 : 6]) {
      translate([dia*10,0,0])
      hole(3+dia);

    }
  }
}
