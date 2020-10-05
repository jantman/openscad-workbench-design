module hutch_shelf()
{
    include <../config.scad>
    render() { // see note in README about rendering
      translate([(table_width/4)-center_leg_timber_width,center_leg_setback-center_leg_timber_depth,hutch_shelf_height+strut_timber_depth]){
        difference() {
            cube([(table_width/2)+(center_leg_timber_width*2),table_depth-center_leg_setback+center_leg_timber_depth,shelf_thickness],false);
            // front left cutout
            cube([center_leg_timber_width,center_leg_timber_depth,shelf_thickness],false);
            // rear left cutout
            translate([0,table_depth-center_leg_setback,0]){
              cube([center_leg_timber_width,center_leg_timber_depth,shelf_thickness],false);
            }
            // front right cutout
            translate([(table_width/2)+center_leg_timber_width,0,0]){
              cube([center_leg_timber_width,center_leg_timber_depth,shelf_thickness],false);
            }
            // rear right cutout
            translate([(table_width/2)+center_leg_timber_width,table_depth-center_leg_setback,0]){
              cube([center_leg_timber_width,center_leg_timber_depth,shelf_thickness],false);
            }
        }
      }
    }
}
