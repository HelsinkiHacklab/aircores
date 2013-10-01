$fa=0.7;
$fs=0.1;

magnet_h_0 = 6.37/2;
magnet_r_0 = 6.33/2;
bearing_r_0 = 3.24/2;

magnet_h = 8/2;
magnet_r = 8/2;
bearing_r = 3.5/2;

module capsule() {

    union() {
        // Body
        translate ([0, 0, 0]) {
            cylinder(h = magnet_h + 1, r = magnet_h + 0.5);
        }

        // Endcap
        difference() {
            translate ([0, 0, magnet_h + 1]) {
                sphere(r = magnet_h + 0.5);
            }
            translate ([0, 0, -20]) {
                cylinder(h = magnet_h + 20, r = magnet_h + 3);
            }
        }

    }
}

module wing() {
    wing_x = 1;
    wing_y = 11;
    wing_z = 11;
    cutout_r = 6.1;
    /*
    render(convexity = 10)
    {
    */
        difference() {
            translate ([-1*wing_x/2, 0, 0]) {
                cube(size = [wing_x, wing_y, wing_z]);
            }
            translate([0,wing_y+0.1,wing_z+cutout_r-wing_x])
            {
                rotate([90,90,0])
                {
                    difference()
                    {
                        cylinder(h=wing_y+0.2, r = cutout_r, center = false);
                        translate([cutout_r, 0, -0.1])
                        {
                            cylinder(h=wing_y+0.4, r = wing_x, center = false);
                        }
                    }
                }
            }
            translate([0,0,wing_z+cutout_r/2-wing_x])
            {
                wing_donut(wing_x, wing_y, wing_z, cutout_r);
            }
        }
    //}
}
//wing();

module wing_donut(wing_x, wing_y, wing_z, cutout_r)
{
    /*
    render(convexity = 10)
    {
    */
        translate([0,0,cutout_r*2])
        {
            rotate([0,90,0])
            {
                rotate_extrude(convexity = 10)
                {
                    translate([cutout_r*2,0,0])
                    {
                        difference()
                        {
                            circle(r = cutout_r, center = false);
                            translate([cutout_r, 0, 0])
                            {
                                circle(r = wing_x, center = false);
                            }
                        }
                    }
                }
            }
        }
    //}
}

module magneetin_kolo() {
    union() {
        // Magneetti
        translate ([0, 0, -1]) {
            cylinder(h = magnet_h + 1, r = magnet_r);
        }

        // Pyöristys
        translate ([0, 0, magnet_h]) {
            sphere(r = magnet_r);
        }

        // Laakeri
        translate ([0, 0, -1]) {
            cylinder(h = magnet_h + 11, r = bearing_r);
        }
    }



}


module main() {

    // Magneetti
    % cylinder(h = magnet_h_0, r = magnet_r_0);


    difference() {
        union() {
            for (i = [0:7]) {
                translate ([0, 0, 0]) { rotate ([0, 0, i*45]) {
                    wing();
                } }

            }

            translate ([0, 0, 0]) {
                capsule(4, 4.5);
            }
        }

        magneetin_kolo();
    }

}

main();




