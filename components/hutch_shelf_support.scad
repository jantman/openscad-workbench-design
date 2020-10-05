module hutch_shelf_support()
{
    include <../config.scad>
    render() { // see note in README about rendering
        difference() {
            cube([(table_width/2)+(center_leg_timber_width*2),strut_timber_height,strut_timber_depth],false);
            translate([0,center_leg_timber_depth/2,0]){
              cube([center_leg_timber_width,center_leg_timber_depth/2,strut_timber_depth],false);
            }
            translate([(table_width/2)+center_leg_timber_width,center_leg_timber_depth/2,0]){
              cube([center_leg_timber_width,center_leg_timber_depth/2,strut_timber_depth],false);
            }
        }
    }
}
