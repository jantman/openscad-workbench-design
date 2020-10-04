module leg(leg_length,leg_timber_width,leg_timber_depth,strut_timber_height,strut_timber_depth,desktop_height,shelf_height,top_shelf_timber_depth,top_shelf_timber_height,is_center_leg,is_inner_leg,hutch_shelf_height,,left_lower_shelf_height,left_lower_shelf_thickness,is_left = false)
{
    leg_color = leg_length > desktop_height ? "BurlyWood" : "NavajoWhite";
    color(leg_color) {
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

                // inner tall (center and rear) legs only
                if(is_inner_leg == true && leg_length > desktop_height) {
                  translate([0,0,hutch_shelf_height]){
                    cube([leg_timber_width,leg_timber_depth/2,strut_timber_depth],false);
                  }
                }

                // shelf rabbets - left front and center legs only
                if((leg_length <= desktop_height || is_center_leg == true) && is_left == true) {
                    translate([leg_timber_width/2,0,left_lower_shelf_height]){
                      #cube([leg_timber_width/2,leg_timber_depth,left_lower_shelf_thickness],false);
                    }
                }
            }
      }
  }
}
