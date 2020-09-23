module lower_shelf(table_width,table_depth,shelf_height,shelf_thickness,leg_timber_width,leg_timber_depth,center_leg_setback,center_leg_timber_width,center_leg_timber_depth)
{
  translate([0,0,shelf_height]){
    render() { // see note in README about rendering
      difference() {
        cube([table_width/4,table_depth,shelf_thickness],false);

        // Left front cutout
        cube([leg_timber_width,leg_timber_depth,shelf_thickness]);
        // Right front cutout
        translate([(table_width/4)-leg_timber_width,0,0]){
          cube([leg_timber_width,leg_timber_depth,shelf_thickness]);
        }
        // Left rear cutout
        translate([0,table_depth-leg_timber_depth,0]){
          cube([leg_timber_width,leg_timber_depth,shelf_thickness]);
        }
        // Right rear cutout
        translate([(table_width/4)-leg_timber_width,table_depth-leg_timber_depth,0]){
          cube([leg_timber_width,leg_timber_depth,shelf_thickness]);
        }
        // Left center cutout
        translate([0,center_leg_setback-leg_timber_depth,0]){
          cube([center_leg_timber_width,center_leg_timber_depth,shelf_thickness]);
        }
        // Right center cutout
        translate([(table_width/4)-leg_timber_width,center_leg_setback-leg_timber_depth,0]){
          cube([center_leg_timber_width,center_leg_timber_depth,shelf_thickness]);
        }
      }
    }
  }
}
