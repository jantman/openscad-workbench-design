include <config.scad>
use <leg.scad>
use <strut.scad>
use <top.scad>
use <shelf.scad>
use <rabbeted_horizontal_plate.scad>

// Left front inside leg
color("BurlyWood") {
    // Left front outside leg
    leg(front_leg_length,lap_depth,leg_timber_width,leg_timber_depth,strut_timber_height,strut_timber_depth,desktop_height);

    translate([table_width/4,0,0]){
        mirror([1,0,0]){
            leg(front_leg_length,lap_depth,leg_timber_width,leg_timber_depth,strut_timber_height,strut_timber_depth,desktop_height);
        }
    }

    // Left rear outside leg
    translate([0,table_depth,0]){
        rotate([0,0,180]){
            mirror([1,0,0]){
                leg(rear_leg_length,lap_depth,leg_timber_width,leg_timber_depth,strut_timber_height,strut_timber_depth,desktop_height);
            }
        }
    }

    // Left rear inside leg
    translate([table_width/4,table_depth,0]){
        rotate([0,0,180]){
                leg(rear_leg_length,lap_depth,leg_timber_width,leg_timber_depth,strut_timber_height,strut_timber_depth,desktop_height);
        }
    }

    // Right front inside leg
    translate([(table_width/4)*3,0,0]){
        leg(front_leg_length,lap_depth,leg_timber_width,leg_timber_depth,strut_timber_height,strut_timber_depth,desktop_height);
    }

    // Right front outside leg
    translate([table_width,0,0]){
        mirror([1,0,0]){
            leg(front_leg_length,lap_depth,leg_timber_width,leg_timber_depth,strut_timber_height,strut_timber_depth,desktop_height);
        }
    }

    // Right rear outside leg
    translate([table_width,table_depth,0]){
            rotate([0,0,180]){
                leg(rear_leg_length,lap_depth,leg_timber_width,leg_timber_depth,strut_timber_height,strut_timber_depth,desktop_height);
            }
    }

    // Right rear inside leg
    translate([(table_width/4)*3,table_depth,0]){
        rotate([0,0,180]){
            mirror([1,0,0]){
                leg(rear_leg_length,lap_depth,leg_timber_width,leg_timber_depth,strut_timber_height,strut_timber_depth,desktop_height);
            }
        }
    }
}

color("silver"){
    // Front plate, under desk top
    translate([0,0,desktop_height-strut_timber_height]){
        rabbeted_horizontal_plate(leg_timber_depth,leg_timber_width,strut_timber_depth,strut_timber_height,lap_depth,table_width);
    }

    // Rear plate, under desk top
    translate([0,table_depth,desktop_height-strut_timber_height]){
        mirror([0,1,0]){
            rabbeted_horizontal_plate(leg_timber_depth,leg_timber_width,strut_timber_depth,strut_timber_height,lap_depth,table_width);
        }
    }
}
