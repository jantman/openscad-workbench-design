module leg(leg_length,lap_depth,leg_timber_width,leg_timber_depth,strut_timber_height,strut_timber_depth,desktop_height)
{
    difference()
    {
        cube([leg_timber_width,leg_timber_depth,leg_length],false);

        // Top tenons
        translate([0,0,desktop_height-strut_timber_height])
        {
            // tenon cut on short side
            translate([0,(leg_timber_width-strut_timber_depth),0]){
                cube([leg_timber_width,lap_depth,strut_timber_height],false);
            }
            cube([lap_depth,leg_timber_depth,strut_timber_height],false);
        }

    }
}
