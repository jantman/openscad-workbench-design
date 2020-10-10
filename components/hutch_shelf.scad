module hutch_shelf()
{
    include <../config.scad>
    echo(str("BOM ITEM: hutch_shelf size=", (table_width/2)+(center_leg_timber_width*2), "x", table_depth-center_leg_setback+center_leg_timber_depth, " thickness=", shelf_thickness));
    render() { // see note in README about rendering
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
