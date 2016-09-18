keyDistance=4;
keyUpper=14.8;
keyLower=18;
keyLip=1.5;
keyHeight=10;

module keySlot(upper, lower) {
  translate([0,0,-1.5]){
    translate([0,0,3])
    cube([upper, upper, 12], center=true);
    translate([0,0,-10])
    cube([lower, lower, 20], center=true);
  }
}

function getDimension(nrKeys) = (nrKeys * (keyLower + keyDistance)) + keyDistance;
function getPosition(nrKeys) = (nrKeys * (keyLower + keyDistance)) + keyLower/2 + keyDistance;

size=3;

width=getDimension(size);
difference(){
  translate([0,0,-keyHeight])
  cube([width,width, keyHeight]);
  for (x =[0:size-1]){
    for (y =[0:size-1]){
      xp=getPosition(x);
      yp=getPosition(y);
      translate([xp,yp,0])
      keySlot(keyUpper, keyLower);
    }
  }
}
