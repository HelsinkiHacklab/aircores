include <parametric_involute_gear_v5.0.scad>

bevel_gear_pair_copy();

//meshing_double_helix();


// Bevel Gears:
// Two gears with the same cone distance, circular pitch (measured at the cone distance) 
// and pressure angle will mesh.


/*
module bevel_gear (
	number_of_teeth=11,
	cone_distance=100,
	face_width=20,
	outside_circular_pitch=1000,
	pressure_angle=30,
	clearance = 0.2,
	bore_diameter=5,
	gear_thickness = 15,
	backlash = 0,
	involute_facets=0,
	finish = -1)
{
*/

module bevel_gear_pair_copy (
    gear1_teeth = 20,
    gear2_teeth = 20,
    gear3_teeth = 7,
    axis_angle = 90,
    outside_circular_pitch=1000)
{
    outside_pitch_radius1 = gear1_teeth * outside_circular_pitch / 360;
    outside_pitch_radius2 = gear2_teeth * outside_circular_pitch / 360;
    outside_pitch_radius3 = gear3_teeth * outside_circular_pitch / 360;
    pitch_apex1=outside_pitch_radius2 * sin (axis_angle) + 
        (outside_pitch_radius2 * cos (axis_angle) + outside_pitch_radius1) / tan (axis_angle);
    cone_distance = sqrt (pow (pitch_apex1, 2) + pow (outside_pitch_radius1, 2));
    pitch_apex2 = sqrt (pow (cone_distance, 2) - pow (outside_pitch_radius2, 2));
    pitch_apex3 = sqrt (pow (cone_distance, 2) - pow (outside_pitch_radius3, 2));
    echo ("cone_distance", cone_distance);
    pitch_angle1 = asin (outside_pitch_radius1 / cone_distance);
    pitch_angle2 = asin (outside_pitch_radius2 / cone_distance);
    pitch_angle3 = asin (outside_pitch_radius3 / cone_distance);
    echo ("pitch_angle1, pitch_angle2", pitch_angle1, pitch_angle2);
    echo ("pitch_angle1 + pitch_angle2", pitch_angle1 + pitch_angle2);

    thk = 10;
    bore = 8; // 8mm by 22mm  skateboard bearing (8/6mm CF tube http://www.silshop.fi/shop/index.php?act=viewProd&productId=1277)
    


    rotate([0,0,90])
    translate ([0,0,pitch_apex1+15])
    {
        translate([0,0,-pitch_apex1])
        {
            bevel_gear (
                number_of_teeth=gear1_teeth,
                cone_distance=cone_distance,
                pressure_angle=30,
            	gear_thickness = thk,
            	bore_diameter=bore,
                outside_circular_pitch=outside_circular_pitch);
        }

        /*
        rotate([0,-(pitch_angle1+pitch_angle2),0])
        {
            translate([0,0,-pitch_apex2])
            {
          
                bevel_gear (
                    number_of_teeth=gear2_teeth,
                    cone_distance=cone_distance,
                    pressure_angle=30,
                	gear_thickness = thk,
                	bore_diameter=bore,
                    outside_circular_pitch=outside_circular_pitch);
            }
        }
        */

        /*
        rotate([0,-(pitch_angle1+pitch_angle2),90])
        {
            translate([-pitch_apex1+20,0,-pitch_apex1])
            {
          
                bevel_gear (
                    number_of_teeth=gear3_teeth,
                    cone_distance=cone_distance,
                    pressure_angle=30,
                	bore_diameter=5,
                    outside_circular_pitch=outside_circular_pitch);
            }
        }
        */


    }
}

