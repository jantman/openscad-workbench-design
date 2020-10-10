use <upper_side_tieA.scad>

module upper_side_tieB()
{
    mirror([0,1,0]){
        upper_side_tieA();
    }
}
