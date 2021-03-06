module lower_side_tie()
{
    include <../config.scad>
    echo(str("BOM ITEM: lower_side_tie length=", table_depth, " material=", strut_timber_depth, "x", strut_timber_height));
    render() { // see note in README about rendering
        difference() {
            cube([strut_timber_depth,table_depth,strut_timber_height],false);

            // Left cutout
            translate([leg_timber_width/2,table_depth-leg_timber_depth,0])
            {
                cube([leg_timber_width/2,leg_timber_depth,strut_timber_height],false);
            }
            // Left bottom cutout
            translate([0,0,0]){
                cube([leg_timber_width/2,leg_timber_width/2,strut_timber_height/2]);
            }
            // Right cutout
            translate([leg_timber_width/2,0,0])
            {
                cube([leg_timber_width/2,leg_timber_depth,strut_timber_height],false);
            }
            // Right bottom cutout
            translate([0,table_depth-(leg_timber_width/2),0]){
                cube([leg_timber_width/2,leg_timber_width/2,strut_timber_height/2]);
            }
            // Center leg cutout
            translate([center_leg_timber_width/2,center_leg_setback-center_leg_timber_depth,0])
            {
                cube([center_leg_timber_width/2,center_leg_timber_depth,strut_timber_height],false);
            }
        }
    }
}
