module leg_short_left()
{
    include <../config.scad>
    leg_length = front_leg_length;
    echo(str("BOM ITEM: leg_short_left"));
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

            // shelf rabbets - left front and center legs only
            translate([leg_timber_width/2,0,left_lower_shelf_height]){
                cube([leg_timber_width/2,leg_timber_depth,left_lower_shelf_thickness],false);
            }
        }
    }
}
