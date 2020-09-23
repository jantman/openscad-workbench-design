include <config.scad>
use <components/leg.scad>
use <components/long_horizontal_plate.scad>
use <components/lower_side_tie.scad>
use <components/short_horizontal_plate.scad>
use <components/desktop.scad>
use <components/lower_shelf.scad>
use <components/upper_side_tie.scad>

color(leg_color) {
    // Left front outside leg
    leg(front_leg_length,leg_timber_width,leg_timber_depth,strut_timber_height,strut_timber_depth,desktop_height,shelf_height,top_shelf_timber_depth,top_shelf_timber_height,false);

    // Left center outside leg
    translate([0,center_leg_setback-center_leg_timber_depth,0]){
      leg(rear_leg_length,leg_timber_width,leg_timber_depth,strut_timber_height,strut_timber_depth,desktop_height,shelf_height,top_shelf_timber_depth,top_shelf_timber_height,true);
    }

    // Left rear outside leg
    translate([0,table_depth,0]){
        rotate([0,0,180]){
            mirror([1,0,0]){
                leg(rear_leg_length,leg_timber_width,leg_timber_depth,strut_timber_height,strut_timber_depth,desktop_height,shelf_height,top_shelf_timber_depth,top_shelf_timber_height,false);
            }
        }
    }

    // Left front inside leg
    translate([table_width/4,0,0]){
        mirror([1,0,0]){
            leg(front_leg_length,leg_timber_width,leg_timber_depth,strut_timber_height,strut_timber_depth,desktop_height,shelf_height,top_shelf_timber_depth,top_shelf_timber_height,false);
        }
    }

    // Left center inside leg
    translate([table_width/4,center_leg_setback-center_leg_timber_depth,0]){
        mirror([1,0,0]){
            leg(rear_leg_length,leg_timber_width,leg_timber_depth,strut_timber_height,strut_timber_depth,desktop_height,shelf_height,top_shelf_timber_depth,top_shelf_timber_height,true);
        }
    }

    // Left rear inside leg
    translate([table_width/4,table_depth,0]){
        rotate([0,0,180]){
                leg(rear_leg_length,leg_timber_width,leg_timber_depth,strut_timber_height,strut_timber_depth,desktop_height,shelf_height,top_shelf_timber_depth,top_shelf_timber_height,false);
        }
    }

    // Right front inside leg
    translate([(table_width/4)*3,0,0]){
        leg(front_leg_length,leg_timber_width,leg_timber_depth,strut_timber_height,strut_timber_depth,desktop_height,shelf_height,top_shelf_timber_depth,top_shelf_timber_height,false);
    }

    // Right center inside leg
    translate([(table_width/4)*3,center_leg_setback-center_leg_timber_depth,0]){
        leg(rear_leg_length,leg_timber_width,leg_timber_depth,strut_timber_height,strut_timber_depth,desktop_height,shelf_height,top_shelf_timber_depth,top_shelf_timber_height,true);
    }

    // Right rear inside leg
    translate([(table_width/4)*3,table_depth,0]){
        rotate([0,0,180]){
            mirror([1,0,0]){
                leg(rear_leg_length,leg_timber_width,leg_timber_depth,strut_timber_height,strut_timber_depth,desktop_height,shelf_height,top_shelf_timber_depth,top_shelf_timber_height,false);
            }
        }
    }

    // Right front outside leg
    translate([table_width,0,0]){
        mirror([1,0,0]){
            leg(front_leg_length,leg_timber_width,leg_timber_depth,strut_timber_height,strut_timber_depth,desktop_height,shelf_height,top_shelf_timber_depth,top_shelf_timber_height,false);
        }
    }

    // Right center outside leg
    translate([table_width,center_leg_setback-center_leg_timber_depth,0]){
        mirror([1,0,0]){
            leg(rear_leg_length,leg_timber_width,leg_timber_depth,strut_timber_height,strut_timber_depth,desktop_height,shelf_height,top_shelf_timber_depth,top_shelf_timber_height,true);
        }
    }

    // Right rear outside leg
    translate([table_width,table_depth,0]){
            rotate([0,0,180]){
                leg(rear_leg_length,leg_timber_width,leg_timber_depth,strut_timber_height,strut_timber_depth,desktop_height,shelf_height,top_shelf_timber_depth,top_shelf_timber_height,false);
            }
    }

}

color(front_rear_strut_color){
    // Front plate, under desk top
    translate([0,0,desktop_height-strut_timber_height]){
        long_horizontal_plate(leg_timber_depth,leg_timber_width,strut_timber_depth,strut_timber_height,table_width);
    }

    // Rear plate, under desk top
    translate([0,table_depth,desktop_height-strut_timber_height]){
        mirror([0,1,0]){
            long_horizontal_plate(leg_timber_depth,leg_timber_width,strut_timber_depth,strut_timber_height,table_width);
        }
    }

    // Rear lower plate
    translate([0,table_depth,shelf_height-strut_timber_height]){
        mirror([0,1,0]){
            long_horizontal_plate(leg_timber_depth,leg_timber_width,strut_timber_depth,strut_timber_height,table_width);
        }
    }

    // Left front lower plate
    translate([0,0,shelf_height-strut_timber_height]){
        short_horizontal_plate(leg_timber_depth,leg_timber_width,strut_timber_depth,strut_timber_height,table_width/4);
    }

    // Right front lower plate
    translate([(table_width/4)*3,0,shelf_height-strut_timber_height]){
        short_horizontal_plate(leg_timber_depth,leg_timber_width,strut_timber_depth,strut_timber_height,table_width/4);
    }

    // Rear upper plate, under top shelf
    translate([0,table_depth,rear_leg_length-strut_timber_height]){
        mirror([0,1,0]){
            long_horizontal_plate(leg_timber_depth,leg_timber_width,strut_timber_depth,strut_timber_height,table_width);
        }
    }

    // Front upper plate, under top shelf
    translate([0,center_leg_setback-center_leg_timber_depth,rear_leg_length-strut_timber_height]){
        long_horizontal_plate(leg_timber_depth,leg_timber_width,strut_timber_depth,strut_timber_height,table_width);
    }
}

color(side_strut_color) {
  // Left outside desktop tie
  translate([0,0,desktop_height-strut_timber_height]){
    lower_side_tie(leg_timber_depth,leg_timber_width,strut_timber_depth,strut_timber_height,table_width,table_depth,center_leg_setback,center_leg_timber_width,center_leg_timber_depth);
  }

  // Left inside desktop tie
  translate([(table_width/4),0,desktop_height-strut_timber_height]){
    mirror([0,1,0]){
      rotate([0,0,180]){
        lower_side_tie(leg_timber_depth,leg_timber_width,strut_timber_depth,strut_timber_height,table_width,table_depth,center_leg_setback,center_leg_timber_width,center_leg_timber_depth);
      }
    }
  }

  // Left outside top tie
  translate([0,0,rear_leg_length-strut_timber_height]){
    upper_side_tie(leg_timber_depth,leg_timber_width,strut_timber_depth,strut_timber_height,table_width,table_depth,center_leg_setback,center_leg_timber_width,center_leg_timber_depth);
  }

  // Left inside top tie
  translate([(table_width/4),0,rear_leg_length-strut_timber_height]){
    mirror([0,1,0]){
      rotate([0,0,180]){
        upper_side_tie(leg_timber_depth,leg_timber_width,strut_timber_depth,strut_timber_height,table_width,table_depth,center_leg_setback,center_leg_timber_width,center_leg_timber_depth);
      }
    }
  }

  // Right outside desktop tie
  translate([table_width,0,desktop_height-strut_timber_height]){
    mirror([0,1,0]){
      rotate([0,0,180]){
        lower_side_tie(leg_timber_depth,leg_timber_width,strut_timber_depth,strut_timber_height,table_width,table_depth,center_leg_setback,center_leg_timber_width,center_leg_timber_depth);
      }
    }
  }

  // Right outside top tie
  translate([table_width,0,rear_leg_length-strut_timber_height]){
    mirror([0,1,0]){
      rotate([0,0,180]){
        upper_side_tie(leg_timber_depth,leg_timber_width,strut_timber_depth,strut_timber_height,table_width,table_depth,center_leg_setback,center_leg_timber_width,center_leg_timber_depth);
      }
    }
  }

  // Right inner desktop tie
  translate([(table_width/4)*3,0,desktop_height-strut_timber_height]){
    lower_side_tie(leg_timber_depth,leg_timber_width,strut_timber_depth,strut_timber_height,table_width,table_depth,center_leg_setback,center_leg_timber_width,center_leg_timber_depth);
  }

  // Right inner top tie
  translate([(table_width/4)*3,0,rear_leg_length-strut_timber_height]){
    upper_side_tie(leg_timber_depth,leg_timber_width,strut_timber_depth,strut_timber_height,table_width,table_depth,center_leg_setback,center_leg_timber_width,center_leg_timber_depth);
  }

  // Left outside lower tie
  translate([0,0,shelf_height-strut_timber_height]){
    lower_side_tie(leg_timber_depth,leg_timber_width,strut_timber_depth,strut_timber_height,table_width,table_depth,center_leg_setback,center_leg_timber_width,center_leg_timber_depth);
  }

  // Left inside lower tie
  translate([(table_width/4),0,shelf_height-strut_timber_height]){
    mirror([0,1,0]){
      rotate([0,0,180]){
        lower_side_tie(leg_timber_depth,leg_timber_width,strut_timber_depth,strut_timber_height,table_width,table_depth,center_leg_setback,center_leg_timber_width,center_leg_timber_depth);
      }
    }
  }

  // Right outside lower tie
  translate([table_width,0,shelf_height-strut_timber_height]){
    mirror([0,1,0]){
      rotate([0,0,180]){
        lower_side_tie(leg_timber_depth,leg_timber_width,strut_timber_depth,strut_timber_height,table_width,table_depth,center_leg_setback,center_leg_timber_width,center_leg_timber_depth);
      }
    }
  }

  // Right inner lower tie
  translate([(table_width/4)*3,0,shelf_height-strut_timber_height]){
    lower_side_tie(leg_timber_depth,leg_timber_width,strut_timber_depth,strut_timber_height,table_width,table_depth,center_leg_setback,center_leg_timber_width,center_leg_timber_depth);
  }
}

color(desktop_shelf_color) {
  desktop(table_width,table_depth,desktop_height,desktop_thickness,leg_timber_width,leg_timber_depth,center_leg_setback,center_leg_timber_width,center_leg_timber_depth);
  // left lower shelf
  lower_shelf(table_width,table_depth,shelf_height,shelf_thickness,leg_timber_width,leg_timber_depth,center_leg_setback,center_leg_timber_width,center_leg_timber_depth);
  // right lower shelf
  translate([(table_width/4)*3,0,0]){
    lower_shelf(table_width,table_depth,shelf_height,shelf_thickness,leg_timber_width,leg_timber_depth,center_leg_setback,center_leg_timber_width,center_leg_timber_depth);
  }
  // top shelf
  translate([0,center_leg_setback-center_leg_timber_depth,rear_leg_length]) {
    cube([table_width,(table_depth-center_leg_setback)+center_leg_timber_depth,shelf_thickness],false);
  }
}
