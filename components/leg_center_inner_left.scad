module leg_center_inner_left()
{
    include <../config.scad>
    leg_length = rear_leg_length;
    echo(str("BOM ITEM: leg_center_inner_left"));
    render() { // see note in README about rendering
        difference() {
            cube([leg_timber_width,leg_timber_depth,leg_length],false);

            // Top rabbets
            translate([0,0,desktop_height-strut_timber_height])
            {
                // rabbet cut on short side
                cube([strut_timber_depth/2,leg_timber_depth,strut_timber_height],false);
            }

            // Bottom rabbets
            translate([0,0,shelf_height-strut_timber_height])
            {
                // rabbet cut on short side
                cube([strut_timber_depth/2,leg_timber_depth,strut_timber_height],false);
            }

            // rear and center legs only
            if(top_shelf_timber_height >= top_shelf_timber_depth) {
              // Upper shelf rabbets for back/middle legs
              translate([0,0,leg_length-top_shelf_timber_height]){
                cube([top_shelf_timber_depth/2,leg_timber_depth,top_shelf_timber_height],false);
                cube([leg_timber_width,top_shelf_timber_depth/2,top_shelf_timber_height],false);
              }
            }
            if(top_shelf_timber_height < top_shelf_timber_depth) {
              // Upper shelf rabbets for back/middle legs
              translate([0,0,leg_length-top_shelf_timber_height]){
                cube([leg_timber_width,leg_timber_depth,top_shelf_timber_height],false);
              }
            }

            // inner tall (center and rear) legs only
            translate([0,0,hutch_shelf_height]){
              cube([leg_timber_width,leg_timber_depth/2,strut_timber_depth],false);
            }

            // shelf rabbets - left front and center legs only
            translate([leg_timber_width/2,0,left_lower_shelf_height]){
              cube([leg_timber_width/2,leg_timber_depth,left_lower_shelf_thickness],false);
            }
        }
    }
}
