$fn = 64;

segmentLength = 20;
thickness = 2.5;

renderSegment = -1;


if(renderSegment == -1)
{
    plane();
}
else
{   
    intersection()
    {
        plane();
        
        translate([-500,-500,renderSegment * segmentLength,])
        cube([1000,1000, segmentLength-0.001]);
    }
}

module plane()
{    
    // body is diameter for each segment
    planeBody([52, 52, 50, 45, 38, 25]);
}

//---------------------------------------------------
module planeBody(segments)
{
    
    for (i = [0:len(segments)-1])
    {
        radius = segments[i] / 2;
        if (i < len(segments)-1)
        {
            radiusNext = segments[i+1]/2;
            translate([0,0,i*segmentLength])
            fuselageSegment(radius, radiusNext);
         
            
            translate([0,0,i*segmentLength])
            fuselageSegmentBeams(radius, radiusNext);
        }
        else
        {
            translate([0,0,i*segmentLength])
            fuselageFirewall(radius);
        }
    }
}

//-------------------------------------------

module fuselageSegment(radius, nextRadius)
{
    linear_extrude(height=thickness)
    difference(){
        circle(radius);
        circle(radius-thickness);
    }
    
}

module fuselageFirewall(radius)
{
    screwRadius=1;
    centerHoldRadius=2;
    
    difference()
    {
    cylinder(h=1, r1=radius, r2=radius);
    
    
    cylinder(h=10, r1=centerHoldRadius, r2=centerHoldRadius, center=true);
        
        
    translate([8,0,0])
    cylinder(h=10, r1=screwRadius, r2=screwRadius, center=true);
        
    rotate([0, 0, 90])
    translate([8,0,0])
    cylinder(h=10, r1=screwRadius, r2=screwRadius, center=true);
        
    rotate([0, 0, 180])
    translate([8,0,0])
    cylinder(h=10, r1=screwRadius, r2=screwRadius, center=true);
        
    rotate([0, 0, 270])
    translate([8 ,0,0])
    cylinder(h=10, r1=screwRadius, r2=screwRadius, center=true);
   
    }
}

module fuselageSegmentBeams(radius, nextRadius)
{
    for(i =[0:45:359])
    {
        rotate(i)
        beam(radius - (thickness/2),
         0,
         nextRadius - (thickness/2),
         0,
         thickness,
         segmentLength);
    }
}

module beam(x1,y1,x2,y2,starty,endy)
{
   s=thickness/2;
    
points = [
  [x1-s, y1-s, starty],  //0
  [x1+s, y1-s, starty],  //1
  [x1+s, y1+s, starty],  //2
  [x1-s, y1+s, starty],  //3
  [x2-s, y2-s, endy],  //4
  [x2+s, y2-s, endy],  //5
  [x2+s, y2+s, endy],  //6
  [x2-s, y2+s, endy]]; //7
  
faces = [
  [0,1,2,3],  // bottom
  [4,5,1,0],  // front
  [7,6,5,4],  // top
  [5,6,2,1],  // right
  [6,7,3,2],  // back
  [7,4,0,3]]; // left
   
  polyhedron( points, faces );    
}
