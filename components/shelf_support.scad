module shelf_support(){ // in inches
    include <../config.scad>
    echo(str("BOM ITEM: shelf_support"));
    top_screw_height = parts_support_height - (parts_shelf_spacing + (parts_shelf_spacing/2));
    first_screw_offset = 1;
    second_screw_offset = 10.5;
    difference(){
        union(){
            cube([parts_shelf_depth, parts_plate_thickness, parts_support_height]);
            for(idx = [0 : (parts_support_height / (parts_shelf_spacing + parts_shelf_thickness))-1]){
                translate([0,0,idx * (parts_shelf_spacing + parts_shelf_thickness)]){
                    _one_shelf_support();
                }
            }
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
    }
}

module _one_shelf_support(){ // in inches
    include <../config.scad>
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
