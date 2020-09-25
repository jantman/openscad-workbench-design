module desktop_support(table_depth,strut_timber_depth,strut_timber_height)
{
    render() { // see note in README about rendering
        difference() {
            cube([strut_timber_depth,table_depth,strut_timber_height],false);

            // Rear cutout
            translate([0,table_depth-strut_timber_depth,0]){
                cube([strut_timber_depth,strut_timber_depth,strut_timber_height/2]);
            }
            // Front cutout
            cube([strut_timber_depth,strut_timber_depth,strut_timber_height/2]);
        }
    }
}