module tube_angle_fitting(inner_d=6/2, outer_d=8/2, sleeve=4, wall_thickness=2, tan_angle=90)
{
    union()
    {
        tube_fitting(inner_d, outer_d, sleeve, wall_thickness);
        // TODO: Calculate the offsets from the angle (now suppose 90degrees...)
        translate([outer_d+wall_thickness/2,0,sleeve+wall_thickness-0.1])
        {
            rotate([90,0,0])
            {
                // Looks nicer
                donut_tube(inner_d,outer_d,tan_angle, outer_d+(outer_d-inner_d));

                // Better for printing on FDM
                //donut_tube(inner_d,outer_d+wall_thickness-0.1,tan_angle, outer_d+(outer_d-inner_d));
            }
        }
        // TODO: Calculate the offsets from the angle (now suppose 90degrees...)
        translate([outer_d*2+wall_thickness*1.5-0.1,0,outer_d*2+sleeve-wall_thickness/2-0.1])
        {
            rotate([0,-tan_angle,0])
            {
                tube_fitting(inner_d, outer_d, sleeve, wall_thickness);
            }
        }
    }

}
//tube_angle_fitting();

module print_tube_angle_fitting(inner_d=6/2, outer_d=8/2, sleeve=4, wall_thickness=2, tan_angle=90)
{
    angle_d = outer_d+(outer_d-inner_d);
    union()
    {
        // Tube fitting rotate sideways
        translate([0,0,outer_d+wall_thickness])
        {
            rotate([90,0,0])
            {
                tube_angle_fitting(inner_d, outer_d, sleeve, wall_thickness, tan_angle);
            }
        }
        // Support
        translate([angle_d,-(sleeve+wall_thickness-0.1),0])
        {
            rotate([0,0,90])
            {
                // 2d arc extruded up
                #linear_extrude(height=wall_thickness+0.1, center=false, convexity=100)
                {
                    intersection()
                    {
                        // Full circle
                        difference()
                        {
                            circle(r=angle_d+wall_thickness/2);
                            circle(r=angle_d-wall_thickness/2);
                        }
                        // right-angled triagle
                        translate([0,angle_d+outer_d,0])
                        {
                            mirror([1,1,0])
                            {
                                polygon(points=[[0,0],[angle_d+outer_d,0],[0,tan(tan_angle) * angle_d+outer_d]], paths=[[0,1,2]]);
                            }
                        }
                    }
                }
            }
        }
    }
}
print_tube_angle_fitting(sleeve=4);

module print_tube_angle_fitting_otherway(inner_d=6/2, outer_d=8/2, sleeve=4, wall_thickness=2, tan_angle=90)
{
}
print_tube_angle_fitting_otherway();

module tube_fitting(inner_d=6, outer_d=8, sleeve=4, wall_thickness=2)
{
    $fn=100;
    render()
    {
        difference()
        {
            cylinder(h=(sleeve+wall_thickness),r=(outer_d+wall_thickness));
            translate([0,0,-0.1])
            {
                cylinder(h=sleeve+0.1,r=outer_d);
                cylinder(h=(sleeve+wall_thickness)+0.2,r=inner_d);
                //cylinder(h=(sleeve+wall_thickness)+0.2,r1=outer_d,r2=inner_d);
            }
        }
    }
}


module angle_donut(outer_d, tan_angle, angle_d)
{
    // Increasing this will make your render times looong
    $fn=50;
    render()
    {
        intersection()
        {
            rotate_extrude(convexity = 100)
            {
                translate([angle_d, 0, 0])
                {
                    difference()
                    {
                        circle(r = outer_d);
                    }
                }
            }
            // 2d arc extruded up
            translate([0,0,-(outer_d+0.1)])
            {
                linear_extrude(height=outer_d*2+0.2, center=false, convexity=100)
                {
                    intersection()
                    {
                        // Full circle
                        difference()
                        {
                            circle(r=angle_d+outer_d+0.1);
                            circle(r=angle_d-outer_d-0.1);
                        }
                        // right-angled triagle
                        translate([0,angle_d+outer_d,0])
                        {
                            mirror([1,1,0])
                            {
                                polygon(points=[[0,0],[angle_d+outer_d,0],[0,tan(tan_angle) * angle_d+outer_d]], paths=[[0,1,2]]);
                            }
                        }
                    }
                }
            }
        }
    }
}

module donut_tube(inner_d, outer_d, tan_angle, angle_d)
{
    render()
    {
        difference()
        {
            angle_donut(outer_d, tan_angle, angle_d);
            rotate([0,0,1])
            {
                angle_donut(inner_d, tan_angle, angle_d);
            }
            rotate([0,0,-1])
            {
                angle_donut(inner_d, tan_angle, angle_d);
            }
        }
    }
}
//donut_tube(6,8,90, 10);



