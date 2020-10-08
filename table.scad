include <config.scad>
use <modules/explode.scad>
use <components/leg_short_left.scad>
use <components/leg_short_NOTleft.scad>
use <components/leg_center_inner_left.scad>
use <components/leg_NOTcenter_NOTinner_NOTleft.scad>
use <components/leg_NOTcenter_NOTinner_left.scad>
use <components/leg_NOTcenter_inner_left.scad>
use <components/leg_NOTcenter_inner_NOTleft.scad>
use <components/leg_center_NOTinner_NOTleft.scad>
use <components/leg_center_NOTinner_left.scad>
use <components/leg_center_inner_NOTleft.scad>
use <components/long_horizontal_plate_top.scad>
use <components/long_horizontal_plate_not_top.scad>
use <components/long_horizontal_plate_desktop.scad>
use <components/lower_side_tie.scad>
use <components/short_horizontal_plate.scad>
use <components/desktop.scad>
use <components/lower_shelf.scad>
use <components/upper_side_tie.scad>
use <components/hutch_shelf_support.scad>
use <components/hutch_shelf.scad>
use <components/desktop_support.scad>
use <components/printer.scad>
use <components/shelf_support.scad>

show_surfaces = true;
show_exploded = false;
show_printer = true;
show_printer_control = true;
show_mfc_printer = true;
show_shelf_supports = true;

explode([10,6,4], false, show_exploded) {
    // #### FRONT (SHORT) LEGS ####
    color("NavajoWhite"){
        // Left front outside leg
        leg_short_left();

        // Left front inside leg
        translate([table_width/4,0,0]){
            mirror([1,0,0]){
                leg_short_left();
            }
        }

        // Right front inside leg
        translate([(table_width/4)*3,0,0]){
            leg_short_NOTleft();
        }

        // Right front outside leg
        translate([table_width,0,0]){
            mirror([1,0,0]){
                leg_short_NOTleft();
            }
        }
    }
    // #### CENTER AND REAR (LONG) LEGS ####
    color("BurlyWood"){
        // Left center outside leg
        translate([0,center_leg_setback-center_leg_timber_depth,0]){
          leg_center_NOTinner_left();
        }

        // Left rear outside leg
        translate([0,table_depth,0]){
            rotate([0,0,180]){
                mirror([1,0,0]){
                    leg_NOTcenter_NOTinner_left();
                }
            }
        }

        // Left center inside leg
        translate([table_width/4,center_leg_setback-center_leg_timber_depth,0]){
            mirror([1,0,0]){
                leg_center_inner_left();
            }
        }

        // Left rear inside leg
        translate([table_width/4,table_depth,0]){
            rotate([0,0,180]){
                    leg_NOTcenter_inner_left();
            }
        }

        // Right center inside leg
        translate([(table_width/4)*3,center_leg_setback-center_leg_timber_depth,0]){
            leg_center_inner_NOTleft();
        }

        // Right rear inside leg
        translate([(table_width/4)*3,table_depth,0]){
            rotate([0,0,180]){
                mirror([1,0,0]){
                    leg_NOTcenter_inner_NOTleft();
                }
            }
        }

        // Right center outside leg
        translate([table_width,center_leg_setback-center_leg_timber_depth,0]){
            mirror([1,0,0]){
                leg_center_NOTinner_NOTleft();
            }
        }

        // Right rear outside leg
        translate([table_width,table_depth,0]){
                rotate([0,0,180]){
                    leg_NOTcenter_NOTinner_NOTleft();
                }
        }
    }
    // #### LOWER FRONT (SHORT) STRUTS ####
    color("Gray") {
          // Left front lower plate
          translate([0,0,shelf_height-strut_timber_height]){
              short_horizontal_plate();
          }

          // Right front lower plate
          translate([(table_width/4)*3,0,shelf_height-strut_timber_height]){
              short_horizontal_plate();
          }
    }
    // #### LONG FRONT AND REAR HORIZONTAL STRUTS ####
    color("silver") {
        // Front plate, under desk top
        translate([0,0,desktop_height-strut_timber_height]){
            long_horizontal_plate_desktop();
        }

        // Rear plate, under desk top
        translate([0,table_depth,desktop_height-strut_timber_height]){
            mirror([0,1,0]){
                long_horizontal_plate_desktop();
            }
        }

        // Rear lower plate
        translate([0,table_depth,shelf_height-strut_timber_height]){
            mirror([0,1,0]){
                long_horizontal_plate_not_top();
            }
        }

        if(top_shelf_timber_height >= top_shelf_timber_depth){
            // Rear upper plate, under top shelf
            translate([0,table_depth,rear_leg_length-strut_timber_height]){
                mirror([0,1,0]){
                    long_horizontal_plate_top();
                }
            }

            // Front upper plate, under top shelf
            translate([0,center_leg_setback-center_leg_timber_depth,rear_leg_length-strut_timber_height]){
                long_horizontal_plate_top();
            }
        } else {
            // Rear upper plate, under top shelf
            translate([0,table_depth,rear_leg_length-top_shelf_timber_height]){
                mirror([0,1,0]){
                    long_horizontal_plate_top();
                }
            }

            // Front upper plate, under top shelf
            translate([0,center_leg_setback-center_leg_timber_depth,rear_leg_length-top_shelf_timber_height]){
                long_horizontal_plate_top();
            }
        }
    }
    // #### HUTCH SHELF SUPPORTS
    color("SlateGray") {
        // Hutch shelf front support
        translate([(table_width/4)-center_leg_timber_width,center_leg_setback-center_leg_timber_depth,hutch_shelf_height]){
            hutch_shelf_support();
        }

        // Hutch shelf rear support
        translate([((table_width/4)*3)+center_leg_timber_width,table_depth,hutch_shelf_height]){
            rotate([0,0,180]){
                hutch_shelf_support();
            }
        }
    }
    // #### DESKTOP TIES / STRUTS AND LOWER SIDE TIES ####
    color("blue"){
        // Left outside desktop tie
        translate([0,0,desktop_height-strut_timber_height]){
          lower_side_tie();
        }

        // Left inside desktop tie
        translate([(table_width/4),0,desktop_height-strut_timber_height]){
          mirror([0,1,0]){
            rotate([0,0,180]){
              lower_side_tie();
            }
          }
        }

        // Right outside desktop tie
        translate([table_width,0,desktop_height-strut_timber_height]){
          mirror([0,1,0]){
            rotate([0,0,180]){
              lower_side_tie();
            }
          }
        }

        // Right inner desktop tie
        translate([(table_width/4)*3,0,desktop_height-strut_timber_height]){
          lower_side_tie();
        }

        // Left outside lower tie
        translate([0,0,shelf_height-strut_timber_height]){
          lower_side_tie();
        }

        // Left inside lower tie
        translate([(table_width/4),0,shelf_height-strut_timber_height]){
          mirror([0,1,0]){
            rotate([0,0,180]){
              lower_side_tie();
            }
          }
        }

        // Right outside lower tie
        translate([table_width,0,shelf_height-strut_timber_height]){
          mirror([0,1,0]){
            rotate([0,0,180]){
              lower_side_tie();
            }
          }
        }

        // Right inner lower tie
        translate([(table_width/4)*3,0,shelf_height-strut_timber_height]){
          lower_side_tie();
        }
        // Left desktop support cutout
        translate([((table_width/4)*2)-(table_width/8),0,desktop_height-strut_timber_height])
        {
            desktop_support();
        }
        // Center desktop support cutout
        translate([(table_width/4)*2,0,desktop_height-strut_timber_height])
        {
            desktop_support();
        }
        // Right desktop support cutout
        translate([((table_width/4)*2)+(table_width/8),0,desktop_height-strut_timber_height])
        {
            desktop_support();
        }
    }
    // #### TOP SHELF SUPPORTS / TIES ####
    color("SkyBlue") {
        // Right inner top tie
        translate([(table_width/4)*3,0,rear_leg_length-top_shelf_timber_height]){
          upper_side_tie();
        }

        // Right outside top tie
        translate([table_width,0,rear_leg_length-top_shelf_timber_height]){
          mirror([0,1,0]){
            rotate([0,0,180]){
              upper_side_tie();
            }
          }
        }

        // Left outside top tie
        translate([0,0,rear_leg_length-top_shelf_timber_height]){
          upper_side_tie();
        }

        // Left inside top tie
        translate([(table_width/4),0,rear_leg_length-top_shelf_timber_height]){
          mirror([0,1,0]){
            rotate([0,0,180]){
              upper_side_tie();
            }
          }
        }
    }

    if(show_surfaces == true) {
        color(desktop_shelf_color) {
            desktop();
            // left lower shelf
            lower_shelf();
            // right lower shelf
            translate([(table_width/4)*3,0,0]){
                lower_shelf();
            }
            // top shelf
            translate([0,center_leg_setback-center_leg_timber_depth,rear_leg_length]) {
                echo(str("BOM ITEM: top_shelf size=", table_width, "x", (table_depth-center_leg_setback)+center_leg_timber_depth, " thickness=", shelf_thickness));
                cube([table_width,(table_depth-center_leg_setback)+center_leg_timber_depth,shelf_thickness],false);
            }

            // hutch shelf
            hutch_shelf();

            // lower left shelf
            translate([leg_timber_width/2,0,left_lower_shelf_height]){
              echo(str("BOM ITEM: lower_left_shelf size=", 23, "x", 24, " thickness=", left_lower_shelf_thickness));
                cube([23,24,left_lower_shelf_thickness]);
            }

            // BEGIN adjustable shelves
            echo(parts_shelf_thickness=parts_shelf_thickness, parts_shelf_depth=parts_shelf_depth, parts_shelf_width=parts_shelf_width);
            adj_shelf_x = ((table_width/4)*3)+leg_timber_width+parts_plate_thickness;
            adj_shelf_y = center_leg_setback-(center_leg_timber_depth/2);
            adj_shelf_base_z = desktop_height+desktop_thickness;
            translate([adj_shelf_x,adj_shelf_y,adj_shelf_base_z+(parts_shelf_thickness*2)+(parts_shelf_spacing*3)]){
                cube([parts_shelf_width,parts_shelf_depth,parts_shelf_thickness]);
            }
            translate([adj_shelf_x,adj_shelf_y,adj_shelf_base_z+(parts_shelf_thickness*5)+(parts_shelf_spacing*6)]){
                cube([parts_shelf_width,parts_shelf_depth,parts_shelf_thickness]);
            }
            translate([adj_shelf_x,adj_shelf_y,adj_shelf_base_z+(parts_shelf_thickness*9)+(parts_shelf_spacing*10)]){
                cube([parts_shelf_width,parts_shelf_depth,parts_shelf_thickness]);
            }
            translate([adj_shelf_x,adj_shelf_y,adj_shelf_base_z+(parts_shelf_thickness*13)+(parts_shelf_spacing*14)]){
                cube([parts_shelf_width,parts_shelf_depth,parts_shelf_thickness]);
            }
            translate([adj_shelf_x,adj_shelf_y,adj_shelf_base_z+(parts_shelf_thickness*23)+(parts_shelf_spacing*24)]){
                cube([parts_shelf_width,parts_shelf_depth,parts_shelf_thickness]);
            }
            translate([adj_shelf_x,adj_shelf_y,adj_shelf_base_z+(parts_shelf_thickness*33)+(parts_shelf_spacing*34)]){
                cube([parts_shelf_width,parts_shelf_depth,parts_shelf_thickness]);
            }
            translate([adj_shelf_x,adj_shelf_y,adj_shelf_base_z+(parts_shelf_thickness*43)+(parts_shelf_spacing*44)]){
                cube([parts_shelf_width,parts_shelf_depth,parts_shelf_thickness]);
            }
            translate([adj_shelf_x,adj_shelf_y,adj_shelf_base_z+(parts_shelf_thickness*53)+(parts_shelf_spacing*54)]){
                cube([parts_shelf_width,parts_shelf_depth,parts_shelf_thickness]);
            }
            translate([adj_shelf_x,adj_shelf_y,adj_shelf_base_z+(parts_shelf_thickness*57)+(parts_shelf_spacing*58)]){
                cube([parts_shelf_width,parts_shelf_depth,parts_shelf_thickness]);
            }
            translate([adj_shelf_x,adj_shelf_y,adj_shelf_base_z+(parts_shelf_thickness*61)+(parts_shelf_spacing*62)]){
                cube([parts_shelf_width,parts_shelf_depth,parts_shelf_thickness]);
            }
            translate([adj_shelf_x,adj_shelf_y,adj_shelf_base_z+(parts_shelf_thickness*65)+(parts_shelf_spacing*66)]){
                cube([parts_shelf_width,parts_shelf_depth,parts_shelf_thickness]);
            }
            // END adjustable shelves
        }
        translate([0,table_depth,(desktop_height+desktop_thickness)-8]){
            color("white"){
                import("components/pegboard_admeshed.stl");
            }
        }
    }
}

if(show_printer == true) {
    translate([5,8,desktop_height+desktop_thickness]){
        scale([1/25.4,1/25.4,1/25.4]){ // mm to inches
            import("printer_fixed_shell.stl");
        }
    }
}

if(show_printer_control == true) {
    translate([18,0,left_lower_shelf_height+left_lower_shelf_thickness]){
        scale([1/25.4,1/25.4,1/25.4]){ // mm to inches
            import("control_box_fixed.stl");
        }
    }
}

if(show_mfc_printer == true) {
    translate([75,20,shelf_height+shelf_thickness]){
        printer();
    }
}

if(show_shelf_supports == true) {
    // first/lowest set
    translate([((table_width/4)*3)+leg_timber_width+parts_plate_thickness,center_leg_setback-(center_leg_timber_depth/2),desktop_height+desktop_thickness]){
        rotate([0,0,90]){
            _shelf_support();
        }
    }
    translate([table_width-leg_timber_width-parts_plate_thickness,center_leg_setback-(center_leg_timber_depth/2)+parts_shelf_depth,desktop_height+desktop_thickness]){
        rotate([0,0,-90]){
            _shelf_support();
        }
    }
    // next set
    translate([((table_width/4)*3)+leg_timber_width+parts_plate_thickness,center_leg_setback-(center_leg_timber_depth/2),desktop_height+desktop_thickness+11]){
        rotate([0,0,90]){
            _shelf_support();
        }
    }
    translate([table_width-leg_timber_width-parts_plate_thickness,center_leg_setback-(center_leg_timber_depth/2)+parts_shelf_depth,desktop_height+desktop_thickness+11]){
        rotate([0,0,-90]){
            _shelf_support();
        }
    }
    // top set
    translate([((table_width/4)*3)+leg_timber_width+parts_plate_thickness,center_leg_setback-(center_leg_timber_depth/2),desktop_height+desktop_thickness+22]){
        rotate([0,0,90]){
            _shelf_support();
        }
    }
    translate([table_width-leg_timber_width-parts_plate_thickness,center_leg_setback-(center_leg_timber_depth/2)+parts_shelf_depth,desktop_height+desktop_thickness+22]){
        rotate([0,0,-90]){
            _shelf_support();
        }
    }
}

module _shelf_support() {
    render() {
        shelf_support();
    }
}
