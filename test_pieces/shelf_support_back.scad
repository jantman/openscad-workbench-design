module shelf_support(){ // in inches
    // height of desktop and shelves
    desktop_shelf_color="Sienna";
    desktop_height=31;
    desktop_thickness=0.75;
    table_width=96;
    table_depth=36;
    shelf_thickness=0.5;
    shelf_height=6;
    top_shelf_height=72.5;
    hutch_shelf_height=50;
    left_lower_shelf_height=22;
    left_lower_shelf_thickness=0.25;

    // Legs
    front_leg_length=desktop_height;
    rear_leg_length=top_shelf_height-shelf_thickness;
    leg_timber_width=1.5;
    leg_timber_depth=3.5;
    center_leg_timber_width=1.5;
    center_leg_timber_depth=3.5;
    center_leg_setback=24;

    // Parts Shelves
    parts_shelf_thickness = 0.35;
    parts_shelf_spacing = 0.15;
    parts_plate_thickness = 0.015748;
    parts_support_depth = 0.25;
    parts_shelf_depth = 11;
    parts_support_height = 11;
    parts_shelf_width = (table_width/4)-(center_leg_timber_width*2)-(parts_plate_thickness*2);

    // Plates
    strut_timber_depth=1.5;
    strut_timber_height=3.5;
    top_shelf_timber_depth=3.5;
    top_shelf_timber_height=1.5;
    echo(str("BOM ITEM: shelf_support"));
    top_screw_height = parts_support_height - (parts_shelf_spacing + (parts_shelf_spacing/2));
    first_screw_offset = 0.5;
    second_screw_offset = 10.5;
    difference(){
        union(){
            cube([parts_shelf_depth, parts_plate_thickness, parts_support_height]);
        }
        translate([first_screw_offset,0,parts_shelf_spacing+(parts_shelf_thickness/2)]){
            _screw_hole(parts_plate_thickness, parts_support_depth);
        }
        translate([second_screw_offset,0,parts_shelf_spacing+(parts_shelf_thickness/2)]){
            _screw_hole(parts_plate_thickness, parts_support_depth);
        }
        if(parts_support_height > 3){
            middle_screw_height = (((parts_support_height/(parts_shelf_thickness+parts_shelf_spacing)) / 2) * (parts_shelf_thickness+parts_shelf_spacing)) - (parts_shelf_thickness / 2);
            translate([first_screw_offset,0,middle_screw_height]){
                _screw_hole(parts_plate_thickness, parts_support_depth);
            }
            translate([second_screw_offset,0,middle_screw_height]){
                _screw_hole(parts_plate_thickness, parts_support_depth);
            }
        }
        translate([first_screw_offset,0,top_screw_height]){
            _screw_hole(parts_plate_thickness, parts_support_depth);
        }
        translate([second_screw_offset,0,top_screw_height]){
            _screw_hole(parts_plate_thickness, parts_support_depth);
        }
        // BEGIN hole in middle of back panel, for testing
        translate([1,-1*parts_plate_thickness,1]){
            cube([parts_shelf_depth-2,parts_plate_thickness*2,parts_support_height-2],false);
        }
        // END hole in middle of back panel, for testing
    }
}

module _one_shelf_support(){ // in inches
    // height of desktop and shelves
    desktop_shelf_color="Sienna";
    desktop_height=31;
    desktop_thickness=0.75;
    table_width=96;
    table_depth=36;
    shelf_thickness=0.5;
    shelf_height=6;
    top_shelf_height=72.5;
    hutch_shelf_height=50;
    left_lower_shelf_height=22;
    left_lower_shelf_thickness=0.25;

    // Legs
    front_leg_length=desktop_height;
    rear_leg_length=top_shelf_height-shelf_thickness;
    leg_timber_width=1.5;
    leg_timber_depth=3.5;
    center_leg_timber_width=1.5;
    center_leg_timber_depth=3.5;
    center_leg_setback=24;

    // Parts Shelves
    parts_shelf_thickness = 0.35;
    parts_shelf_spacing = 0.15;
    parts_plate_thickness = 0.015748;
    parts_support_depth = 0.25;
    parts_shelf_depth = 11;
    parts_support_height = 11;
    parts_shelf_width = (table_width/4)-(center_leg_timber_width*2)-(parts_plate_thickness*2);

    // Plates
    strut_timber_depth=1.5;
    strut_timber_height=3.5;
    top_shelf_timber_depth=3.5;
    top_shelf_timber_height=1.5;
    render() {
        translate([parts_support_depth,-1.0*parts_support_depth,0]){
            cube([parts_shelf_depth-(parts_support_depth*2), parts_support_depth, parts_shelf_spacing]);
        }
        translate([parts_support_depth,0,0]){
            intersection(){
                cylinder(h=parts_shelf_spacing, r=parts_support_depth, center=false, $fn=48);
                translate([-1 * parts_support_depth,-1 * parts_support_depth,0]){
                    cube([parts_support_depth, parts_support_depth, parts_shelf_spacing]);
                }
            }
        }
        translate([parts_shelf_depth-parts_support_depth,0,0]){
            intersection(){
                cylinder(h=parts_shelf_spacing, r=parts_support_depth, center=false, $fn=48);
                translate([0,-1 * parts_support_depth,0]){
                    cube([parts_support_depth, parts_support_depth, parts_shelf_spacing]);
                }
            }
        }
    }
}

module _screw_hole(parts_plate_thickness, parts_support_depth) {
    screw_head_padding = 0.02;
    screw_shaft_diameter = 0.16 + screw_head_padding;
    screw_head_height = 0.138 + screw_head_padding;
    screw_head_lower_diameter = 0.16 + screw_head_padding;
    screw_head_upper_diameter = 0.306 + screw_head_padding;

    translate([0,parts_plate_thickness+0.001,0]){
        rotate([90,0,0]){
            union() {
                cylinder(h=parts_plate_thickness+0.002, d=screw_shaft_diameter, $fn=48);
                translate([0,0,parts_plate_thickness-screw_head_height]){
                    cylinder(h=screw_head_height, d1=screw_head_lower_diameter, d2=screw_head_upper_diameter, $fn=48);
                }
                translate([0,0,parts_plate_thickness]){
                    cylinder(h=parts_support_depth, d=screw_head_upper_diameter, $fn=48);
                }
            }
        }
    }
}

scale([25.4,25.4,25.4]){ // inches to mm
    shelf_support();
}
