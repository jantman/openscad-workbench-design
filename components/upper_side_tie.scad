module upper_side_tie()
{
    include <../config.scad>
    tie_length = (table_depth-center_leg_setback)+center_leg_timber_depth;
    render() { // see note in README about rendering
      translate([0,center_leg_setback-center_leg_timber_depth,0]){
        difference() {
            cube([strut_timber_depth,tie_length,strut_timber_height],false);

            // Left cutout
            translate([strut_timber_depth/2,tie_length-leg_timber_depth,0])
            {
                cube([leg_timber_width/2,leg_timber_depth,strut_timber_height],false);
            }
            // Left bottom cutout
            translate([0,tie_length-(strut_timber_depth/2),0]){
                cube([leg_timber_width/2,leg_timber_depth/2,strut_timber_height/2]);
            }
            // Right cutout
            translate([leg_timber_width/2,0,0])
            {
                cube([leg_timber_width/2,leg_timber_depth,strut_timber_height],false);
            }
            // Right bottom cutout
            cube([leg_timber_width/2,strut_timber_depth/2,strut_timber_height/2]);
        }
      }
    }
}
