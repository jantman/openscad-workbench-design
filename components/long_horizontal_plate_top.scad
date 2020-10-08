module long_horizontal_plate_top()
{
    include <../config.scad>
    echo(str("BOM ITEM: long_horizontal_plate_top length=", table_width, " material=", top_shelf_timber_depth, "x", top_shelf_timber_height));
    render() { // see note in README about rendering
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
}
