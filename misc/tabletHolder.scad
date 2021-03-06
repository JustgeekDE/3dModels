length = 70;
bottomHeight= 40;
topHeight = 35;

dividerWidth = 35;
tabletWidth = 10;

union(){
  color("red")
  difference(){
    translate([0,-10,0])
    cube([length,dividerWidth+20, bottomHeight]);
    translate([-5,0,-1])
    cube([length+10,dividerWidth, bottomHeight-9]);
  }
  translate([0,0,bottomHeight-0.01])
  color("green")
  difference() {
     translate([0,-20,0])
    cube([length,dividerWidth+40, topHeight]);
    translate([-5,-50,8])
    for (a =[1:1:3]) {
      translate([a*20,0,0])
      rotate([0,-a * 5,0])
      translate([-tabletWidth/2,0,0])
      cube([tabletWidth,dividerWidth+100, topHeight]);
    }
  }
}
