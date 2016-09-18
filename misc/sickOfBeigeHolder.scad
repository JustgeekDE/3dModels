module tube(diameter, length) {
  radius = diameter / 2;
  linear_extrude(height = length)
  circle(r = radius);
}

module screwHoles(width, breadth, diameter=3.2) {
  translate([0,0,-0.1]){
    translate([0,0,0])
    tube(diameter,10);
    translate([width,0,0])
    tube(diameter,10);
    translate([0,breadth,0])
    tube(diameter,10);
    translate([width,breadth,0])
    tube(diameter,10);
  }
}

module grip(){
  height=25;
  width = 3.5;
  breadth=10;
  spacing = 2.6;

  translate([-breadth/2,0,0])
  difference(){
    union(){
      translate([0,spacing,0])
      cube([breadth,width,height]);

      translate([0,-(width+spacing),0])
      cube([breadth,width,height]);
    }
    translate([breadth/2, 25, height-5])
    rotate([90,0,0])
    tube(3.5,80);

    translate([-10, 0, height-10])
    rotate([0,90,0])
    tube(6.5,80);

  }


}

$fn=130;
height=3;

scale([1.02, 1.02, 1.02])
difference(){
  union(){
    color("red")
    cube([50,50,height]);
    color("blue")
    translate([0, 25, 0.01]){
      translate([10,0,0])
      grip();
      translate([40,0,0])
      grip();

    }

  }
  translate([4,4,0])
  color("black")
  screwHoles(42,42, 3.8);
}

/*color("silver")
translate([10, 25, 9])
rotate([0,90,0])
tube(7,80);*/
