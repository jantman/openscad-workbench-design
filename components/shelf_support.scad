module shelf_support(shelf_thickness = 0.25, shelf_spacing = 0.25, plate_thickness = 0.2, support_depth = 0.25, depth = 12, height = 11){ // in inches
    cube([depth, plate_thickness, height]);
    for(idx = [0 : (height / (shelf_spacing + shelf_thickness))-1]){
        translate([0,0,idx * (shelf_spacing + shelf_thickness)]){
            _one_shelf_support(shelf_thickness = 0.25, shelf_spacing = 0.25, plate_thickness = 0.2, support_depth = 0.25, depth = 12);
        }
    }
}

module _one_shelf_support(shelf_thickness = 0.25, shelf_spacing = 0.25, plate_thickness = 0.2, support_depth = 0.25, depth = 12){ // in inches
    render() {
        translate([support_depth,-1.0*support_depth,0]){
            cube([depth-(support_depth*2), support_depth, shelf_spacing]);
        }
        translate([support_depth,0,0]){
            intersection(){
                cylinder(h=shelf_spacing, r=support_depth, center=false, $fn=48);
                translate([-1 * support_depth,-1 * support_depth,0]){
                    cube([support_depth, support_depth, shelf_spacing]);
                }
            }
        }
        translate([depth-support_depth,0,0]){
            intersection(){
                cylinder(h=shelf_spacing, r=support_depth, center=false, $fn=48);
                translate([0,-1 * support_depth,0]){
                    cube([support_depth, support_depth, shelf_spacing]);
                }
            }
        }
    }
}
