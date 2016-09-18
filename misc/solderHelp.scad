module tube(diameter, length) {
  radius = diameter / 2;
  linear_extrude(height = length)
  circle(r = radius);
}

module screwHoles(width, breadth, diameter) {
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

module pcb(size=pcbSize){
  cube([size,size,2]);
}

module pcbWithHoles(size){
  holeClearance = 2.8;
  holeDistance= size - (2 * holeClearance);

  color("red")
  difference(){
    pcb(size);
    translate([holeClearance, holeClearance, 0])
    screwHoles(holeDistance, holeDistance, 3);
  }
}

module base(breadth=78){
  width=pcbSize+2*10;
  height=4;

  translate([0,60-breadth,0])
  difference(){
    cube([width,breadth,height]);
    translate([10,breadth-60, height-1.2])
    color("black")
    union() {
      pcb();
      translate([0,-49.9,0])
      pcb();
    }
    translate([5,5,0])
    screwHoles(width-10, breadth-10, screwDiamter);
  }
}


module top(breadth=78){
  width=pcbSize+2*10;
  hole = pcbSize-10;
  height=5;

  translate([0,60-breadth,0])
  union(){
    difference(){
      cube([width,breadth,height]);
      translate([15,-15, -1])
      color("black")
      cube([hole,breadth, 10]);
      translate([5,5,0])
      screwHoles(width-10, breadth-10, screwDiamter);
    }
    translate([2,14, 1.99])
    color("blue")
    cube([width-4,8, 3]);

  }
}

$fn=50;
pcbSize=51;
screwDiamter=3.2;

//top();
base(78);
/*
translate([20+pcbSize,0,0])
rotate([0,0,180])
base(42);

translate([10,0, 3]) {
  pcbWithHoles(50);
  translate([0,-( 50 + 0.1),0])
  pcbWithHoles(50);
}*/
