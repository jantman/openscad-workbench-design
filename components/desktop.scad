module desktop(table_width,table_depth,desktop_height,desktop_thickness,leg_timber_width,leg_timber_depth,center_leg_setback,center_leg_timber_width,center_leg_timber_depth)
{
  translate([0,0,desktop_height]){
    render() { // see note in README about rendering
      difference() {
        cube([table_width,table_depth,desktop_thickness],false);

        // Left rear outer cutout
        translate([0,table_depth-leg_timber_depth,0]){
          cube([leg_timber_width,leg_timber_depth,desktop_thickness]);
        }
        // Left rear inner cutout
        translate([(table_width/4)-leg_timber_width,table_depth-leg_timber_depth,0]){
          cube([leg_timber_width,leg_timber_depth,desktop_thickness]);
        }
        // Right rear inner cutout
        translate([((table_width/4)*3),table_depth-leg_timber_depth,0]){
          cube([leg_timber_width,leg_timber_depth,desktop_thickness]);
        }
        // Right rear outer cutout
        translate([table_width-leg_timber_width,table_depth-leg_timber_depth,0]){
          cube([leg_timber_width,leg_timber_depth,desktop_thickness]);
        }

        // Left center outer cutout
        translate([0,center_leg_setback-center_leg_timber_depth,0]){
          cube([center_leg_timber_width,center_leg_timber_depth,desktop_thickness]);
        }
        // Left center inner cutout
        translate([(table_width/4)-center_leg_timber_width,center_leg_setback-center_leg_timber_depth,0]){
          cube([center_leg_timber_width,center_leg_timber_depth,desktop_thickness]);
        }
        // Right center inner cutout
        translate([((table_width/4)*3),center_leg_setback-center_leg_timber_depth,0]){
          cube([center_leg_timber_width,center_leg_timber_depth,desktop_thickness]);
        }
        // Right center outer cutout
        translate([table_width-center_leg_timber_width,center_leg_setback-center_leg_timber_depth,0]){
          cube([center_leg_timber_width,center_leg_timber_depth,desktop_thickness]);
        }
      }
    }
  }
}
