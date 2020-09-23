module leg(leg_length,leg_timber_width,leg_timber_depth,strut_timber_height,strut_timber_depth,desktop_height,shelf_height,top_shelf_timber_depth,top_shelf_timber_height,is_center_leg)
{
    render() { // see note in README about rendering
        difference() {
            cube([leg_timber_width,leg_timber_depth,leg_length],false);

            // Top rabbets
            translate([0,0,desktop_height-strut_timber_height])
            {
                // rabbet cut on short side
                if(is_center_leg == false) {
                  translate([0,(leg_timber_width-strut_timber_depth),0]){
                      cube([leg_timber_width,strut_timber_depth/2,strut_timber_height],false);
                  }
                }
                cube([strut_timber_depth/2,leg_timber_depth,strut_timber_height],false);
            }

            // Bottom rabbets
            translate([0,0,shelf_height-strut_timber_height])
            {
                // rabbet cut on short side
                if(is_center_leg == false) {
                  translate([0,(leg_timber_width-strut_timber_depth),0]){
                      cube([leg_timber_width,strut_timber_depth/2,strut_timber_height],false);
                  }
                }
                cube([strut_timber_depth/2,leg_timber_depth,strut_timber_height],false);
            }

            // rear and center legs only
            if(leg_length > desktop_height) {
              // Upper shelf rabbets for back/middle legs
              translate([0,0,leg_length-top_shelf_timber_height]){
                cube([top_shelf_timber_depth/2,leg_timber_depth,top_shelf_timber_height],false);
                cube([leg_timber_width,top_shelf_timber_depth/2,top_shelf_timber_height],false);
              }
            }
        }
    }
}
