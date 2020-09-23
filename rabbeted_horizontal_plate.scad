module rabbeted_horizontal_plate(leg_timber_depth,leg_timber_width,strut_timber_depth,strut_timber_height,lap_depth,table_width)
{
    difference()
    {
        cube([table_width,strut_timber_depth,strut_timber_height],false);

        // Left cutout
        translate([0,lap_depth,0])
        {
            cube([leg_timber_width,lap_depth,strut_timber_height],false);
        }
        // Left top cutout
        translate([0,0,strut_timber_height/2]){
            cube([lap_depth,lap_depth,strut_timber_height/2]);
        }
        // Right cutout
        translate([table_width-leg_timber_width,lap_depth,0])
        {
            cube([leg_timber_width,lap_depth,strut_timber_height],false);
        }
        // Right top cutout
        translate([table_width-lap_depth,0,strut_timber_height/2]){
            cube([lap_depth,lap_depth,strut_timber_height/2]);
        }
        // Left inside cutout
        translate([(table_width/4)-leg_timber_width,lap_depth,0])
        {
            cube([lap_depth,lap_depth,strut_timber_height],false);
        }
        // Left inside top cutout
        translate([(table_width/4)-lap_depth,0,strut_timber_height/2])
        {
            cube([lap_depth,strut_timber_depth,strut_timber_height/2],false);
        }
        // Right inside cutout
        translate([((table_width/4)*3),lap_depth,0])
        {
            cube([lap_depth,lap_depth,strut_timber_height],false);
        }
        // Right inside top cutout
        translate([((table_width/4)*3),0,strut_timber_height/2])
        {
            cube([lap_depth,strut_timber_depth,strut_timber_height/2],false);
        }
    }
}
