module long_horizontal_plate(is_desktop = false, is_top_shelf = false)
{
    include <../config.scad>
    render() { // see note in README about rendering
        if(is_top_shelf && top_shelf_timber_height < top_shelf_timber_depth){
            difference() {
                cube([table_width,top_shelf_timber_depth,top_shelf_timber_height],false);
                translate([0,0,top_shelf_timber_height/2]){
                    cube([top_shelf_timber_depth,top_shelf_timber_depth,top_shelf_timber_height/2],false);
                }
                translate([table_width-top_shelf_timber_depth,0,top_shelf_timber_height/2]){
                    cube([top_shelf_timber_depth,top_shelf_timber_depth,top_shelf_timber_height/2],false);
                }
                translate([(table_width/4)-top_shelf_timber_depth,0,top_shelf_timber_height/2])
                {
                    cube([top_shelf_timber_depth,top_shelf_timber_depth,top_shelf_timber_height/2],false);
                }
                translate([((table_width/4)*3),0,top_shelf_timber_height/2])
                {
                    cube([top_shelf_timber_depth,top_shelf_timber_depth,top_shelf_timber_height/2],false);
                }
            }
        }
        else {
            difference() {
                cube([table_width,strut_timber_depth,strut_timber_height],false);
                // Left cutout
                translate([0,leg_timber_width/2,0])
                {
                    cube([leg_timber_width,leg_timber_width/2,strut_timber_height],false);
                }
                // Left top cutout
                translate([0,0,strut_timber_height/2]){
                    cube([leg_timber_width/2,leg_timber_width/2,strut_timber_height/2]);
                }
                // Right cutout
                translate([table_width-leg_timber_width,leg_timber_width/2,0])
                {
                    cube([leg_timber_width,leg_timber_width/2,strut_timber_height],false);
                }
                // Right top cutout
                translate([table_width-(leg_timber_width/2),0,strut_timber_height/2]){
                    cube([leg_timber_width/2,leg_timber_width/2,strut_timber_height/2]);
                }
                // Left inside cutout
                translate([(table_width/4)-leg_timber_width,leg_timber_width/2,0])
                {
                    cube([leg_timber_width/2,leg_timber_width/2,strut_timber_height],false);
                }
                // Left inside top cutout
                translate([(table_width/4)-(leg_timber_width/2),0,strut_timber_height/2])
                {
                    cube([leg_timber_width/2,strut_timber_depth,strut_timber_height/2],false);
                }
                // Right inside cutout
                translate([((table_width/4)*3),leg_timber_width/2,0])
                {
                    cube([leg_timber_width/2,leg_timber_width/2,strut_timber_height],false);
                }
                // Right inside top cutout
                translate([((table_width/4)*3),0,strut_timber_height/2])
                {
                    cube([leg_timber_width/2,strut_timber_depth,strut_timber_height/2],false);
                }
                if(is_desktop == true) {
                    // Left desktop support cutout
                    translate([((table_width/4)*2)-(table_width/8),0,strut_timber_height/2])
                    {
                        cube([strut_timber_depth,strut_timber_depth,strut_timber_height/2],false);
                    }
                    // Center desktop support cutout
                    translate([(table_width/4)*2,0,strut_timber_height/2])
                    {
                        cube([strut_timber_depth,strut_timber_depth,strut_timber_height/2],false);
                    }
                    // Right desktop support cutout
                    translate([((table_width/4)*2)+(table_width/8),0,strut_timber_height/2])
                    {
                        cube([strut_timber_depth,strut_timber_depth,strut_timber_height/2],false);
                    }
                }
            }
        }
    }
}
