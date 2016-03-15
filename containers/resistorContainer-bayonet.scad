module singleWindow(size, length){
    rotate(a=90,v=[0,1,0])
    linear_extrude(height = length)
    circle(size,$fn=6);
}

module windows(size, length,distanceCenter){
    translate([distanceCenter,0,0])
    singleWindow(size, length);

    rotate(a=120,v=[0,0,1])
    translate([distanceCenter,0,0])
    singleWindow(size, length);

    rotate(a=-120,v=[0,0,1])
    translate([distanceCenter,0,0])
    singleWindow(size, length);
}

module outerCase(height, outerDiameter, innerDiameter, lidLip, windows) {
    windowPosition = height / 2;
    difference(){
        union(){
            linear_extrude(height = (height-lidLip))
            circle(outerDiameter,$fn=6);
            cylinder(h = height, r1 = innerDiameter, r2 = innerDiameter);
        }
        if (windows== true){
            translate([0,0,windowPosition])
            rotate(a=90, v=[0,0,1])
            windows(outerDiameter/2.5,  outerDiameter,0);
        }
     }
}

module curvedSegment(innerDiameter, outerDiameter, height, angle){
    difference() {
        difference(){
            cylinder(h=height, r1=outerDiameter, r2=outerDiameter);
            translate([0,0,-0.5])
            cylinder(h=height+1, r1=innerDiameter, r2=innerDiameter);
        }
        union() {
            rotate(a=angle,v=[0,0,1])
            translate([0,0,-1])
            cube([outerDiameter,  outerDiameter,  height+2]);

            rotate(a=180,v=[1,0,0])
            translate([0,0,-(height+1)])
            rotate(a=angle,v=[0,0,1])
            cube([outerDiameter, outerDiameter, height+2]);

            translate([-outerDiameter,-outerDiameter,-1])
            cube([outerDiameter, outerDiameter*2, height+2]);

        }
    }
}

module bayonetHalfChannel(diameter=10, bayonetDistance = 3, bayonetDepth = 1, bayonetWidth=2, bayonetHeight = 2) {
    toleranceFactor = 1.3;
    bayonetWidth=bayonetWidth*toleranceFactor;
    bayonetDepth=bayonetDepth*toleranceFactor;
    bayonetHeight=bayonetHeight*toleranceFactor;
    angle=8;
    channelLength = 4;
    union(){
        offsetCenter = (channelLength -1)* angle;
        rotate(a=offsetCenter , v=[0,0,1])
        curvedSegment(diameter, diameter+bayonetDepth, bayonetHeight, channelLength*angle+1);
        rotate(a=2*channelLength*angle,v=[0,0,1])
        curvedSegment(diameter, diameter+bayonetDepth, bayonetDistance, angle*1.2);

    }

}

module bayonetChannel(diameter, bayonetDistance = 3, bayonetDepth = 1) {
        bayonetOffset = diameter+bayonetDepth;
//        translate([bayonetOffset,0,height - bayonetDistance])
        bayonetHalfChannel(diameter, bayonetDistance, bayonetDepth);
        rotate(a=180,v=[0,0,1])
        bayonetHalfChannel(diameter, bayonetDistance, bayonetDepth);
}

module container(height, diameter , thickness, lidHeight = 5,windows=true, bottomThickness=0.5, lipThickness=1, bayonetDistance = 3, bayonetDepth = 1){
    outerDiameter = diameter + thickness;
    lidDiameter = diameter + 1;
    bayonetDistance = lidHeight- bayonetDistance;
    union(){
        difference(){
            outerCase(height+bottomThickness, outerDiameter,  diameter + lipThickness, lidHeight, windows);
            translate([0,0,bottomThickness])
            cylinder(h = height+1, r1 = diameter, r2 = diameter);
        }
        bayonetPosition = height+bottomThickness + bayonetDistance - lidHeight;
        translate([0,0,bayonetPosition]){
            curvedSegment(diameter, diameter+1+bayonetDepth, 2, 8);
            rotate(a=180,v=[0,0,1])
            curvedSegment(diameter, diameter+1+bayonetDepth, 2, 8);
        }
    }

}

module lid(height, diameter, thickness,, lipTolerance=1.33, lidThickness=0.5, bayonetDistance = 5, bayonetDepth = 2){
    outerDiameter = diameter + thickness;
    innerDiameter = diameter +lipTolerance;

    rotate(a=180, v=[0,1,0])
    translate([0,0,-(height+lidThickness)])
    difference(){
      linear_extrude(height = (height+lidThickness))
      circle(outerDiameter,$fn=6);
        translate([0,0,-(lidThickness)])
        union(){
            cylinder(h = height, r1 = innerDiameter, r2 = innerDiameter);
            rotate(a=180, v=[0,1,0])
            translate([0,0,-bayonetDistance])
            bayonetChannel(innerDiameter-1, bayonetDistance+1,bayonetDepth);
        }
    }
}

$fn=150;
radius= 16;
thickness = 6.5;
//container(height=62, diameter=radius, thickness=thickness, lidHeight=8, bayonetDistance = 5.5, bayonetDepth = 1.4, windows=true);

lid(height=10, diameter=radius, thickness=thickness, bayonetDistance = 5.5, bayonetDepth = 1.8);
