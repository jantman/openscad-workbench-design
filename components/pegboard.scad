module pegboard(height = 48, width = 96) {
    cols = height - 1;
    rows = width - 1;
    color("white") {
        difference(){
            cube([width,3/16,height]);
            for(row =[0:cols]){
                for(col =[0:rows]){
                    translate([0.875+col,0.25,0.875+row]){
                        rotate([90,0,0]){
                            cylinder(h=0.4, d=0.25, $fs=0.1, center=false);
                        }
                    }
                }
            }
        }
    }
}

pegboard();
