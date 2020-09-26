module short_horizontal_plate(leg_timber_depth,leg_timber_width,strut_timber_depth,strut_timber_height,plate_length)
{
    color("Gray") {
        render() { // see note in README about rendering
            difference() {
                cube([plate_length,strut_timber_depth,strut_timber_height],false);

                // Left cutout
                translate([0,leg_timber_width/2,0])
                {
                    cube([leg_timber_width,leg_timber_width/2,strut_timber_height],false);
                }
                // Left top cutout
                translate([0,0,strut_timber_height/2]){
                    cube([leg_timber_width/2,leg_timber_width/2,strut_timber_height/2]);
                }
                // Right cutout
                translate([plate_length-leg_timber_width,leg_timber_width/2,0])
                {
                    cube([leg_timber_width,leg_timber_width/2,strut_timber_height],false);
                }
                // Right top cutout
                translate([plate_length-(leg_timber_width/2),0,strut_timber_height/2]){
                    cube([leg_timber_width/2,leg_timber_width/2,strut_timber_height/2]);
                }
            }
        }
    }
}
