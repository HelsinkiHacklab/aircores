$fa=0.1;
$fs=0.05;

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

    difference() {
        translate ([-0.5, 0, 0]) {
            cube(size = [1, 11, 11]);
        }
        translate ([0, 4, 14.7]) { rotate ([0, 90, 0]) {
            cylinder(h = 5, r = 6.1, center = true);
        } }
    }
}
wing();

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

//main();




