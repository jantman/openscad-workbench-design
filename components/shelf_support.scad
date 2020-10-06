module shelf_support(){ // in inches
    include <../config.scad>
    top_screw_height = parts_support_height - (parts_shelf_spacing + (parts_shelf_spacing/2));
    difference(){
        union(){
            cube([parts_shelf_depth, parts_plate_thickness, parts_support_height]);
            for(idx = [0 : (parts_support_height / (parts_shelf_spacing + parts_shelf_thickness))-1]){
                translate([0,0,idx * (parts_shelf_spacing + parts_shelf_thickness)]){
                    _one_shelf_support();
                }
            }
        }
        translate([1,0,parts_shelf_spacing/2]){
            _screw_hole(parts_plate_thickness, parts_support_depth);
        }
        translate([11,0,parts_shelf_spacing/2]){
            _screw_hole(parts_plate_thickness, parts_support_depth);
        }
        translate([1,0,(parts_shelf_spacing/2)+(parts_support_height/2)]){
            _screw_hole(parts_plate_thickness, parts_support_depth);
        }
        translate([11,0,(parts_shelf_spacing/2)+(parts_support_height/2)]){
            _screw_hole(parts_plate_thickness, parts_support_depth);
        }
        translate([1,0,top_screw_height]){
            _screw_hole(parts_plate_thickness, parts_support_depth);
        }
        translate([11,0,top_screw_height]){
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
    translate([0,parts_plate_thickness+0.001,0]){
        rotate([90,0,0]){
            union() {
                cylinder(h=parts_plate_thickness+parts_support_depth+0.002, d=0.16, $fn=48);
                translate([0,0,(parts_plate_thickness+parts_support_depth)-0.136]){
                    cylinder(h=0.138, d1=0.16, d2=0.306, $fn=48);
                }
            }
        }
    }
}
