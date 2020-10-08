module rotated_view(view_mode = "") {
    if(view_mode == "") {
        children();
    } else {
        projection(cut=true) {
            if(view_mode == "top"){
                rotate([90,0,0]){
                    children();
                }
            } else if(view_mode == "bottom"){
                rotate([-90,0,0]){
                    children();
                }
            } else if(view_mode == "left"){
                rotate([0,90,0]){
                    children();
                }
            } else if(view_mode == "right"){
                rotate([0,-90,0]){
                    children();
                }
            } else if(view_mode == "back"){
                rotate([180,0,0]){
                    children();
                }
            } else { // mode == "front"
                children();
            }
        }
    }
}
