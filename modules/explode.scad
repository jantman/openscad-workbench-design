// from: <https://gist.github.com/damccull/1a1df5e785e56daf53e0d7b7d8ff219e>
module explode(distance = [10, 0, 0], center = false, enable = true) {
    if(enable){
        offset = center ? (($children * distance) / 2 - distance / 2) * -1 : [0, 0 , 0];
        for(i = [0 : 1 : $children - 1]) {
            translate(i * distance + offset) {
                children(i);
            }
        }
    } else {
        children();
    }
}
