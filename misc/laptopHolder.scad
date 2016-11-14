module roundedSlab(width, breadth, height) {
  union() {
    translate([-width/2, -breadth/2, 0])
    cube([width, breadth, height]);
    color("pink")
    rotate([0,90,0])
    cylinder(h = width, r=breadth/2, center=true);
  }
}

module holderBody(){
  width = 80;
  angle = -8;
  depth = 40;
  union(){
    difference(){
      union() {
        difference() {
          roundedSlab(width, depth, 55);
//          color("red")
//          translate([-25,depth/2,0])
//          cube([50,20,300]);

          translate([0,-4,0])
          rotate([angle,0,0])
          color("lime")
          translate([-150, -55, -5])
          rotate([-angle, 0, 0])
          cube([300,60, 120]);
          
        }
        color("brown")
        translate([0,-14.5,2])
        rotate([0,90,0])
        cylinder(h = width, r=5.5, center=true);
      }
  
      translate([0,-4,0])
      rotate([angle,0,0])
      union() {
        color("blue")
        roundedSlab(width-10, 20, 100);
        color("green")
        roundedSlab(190, 12, 120);
      }
    }

  }
}

holderBody();
