use <libmf.scad>;
include <trofast-params.scad>;

right_side = false;
print_orientation = false;

wall_bottom_width = 14;
wall_middle_width = 5;
wall_top_width = 9;
wall_width_diff = wall_bottom_width - wall_middle_width;
wall_height = rail_height + rail_distance + box_top_height;
wall_bottom_height = rail_height + box_top_height - wall_width_diff / 2;
wall_top_height = box_top_height + rail_height;
wall_middle_height = wall_height - wall_bottom_height - wall_top_height;

module rail() {
    rotate([-90, 0, 0])
    quater_cylinder(rail_depth, rail_height);
}

module back_screw_hole(y_offset) {
    translate([
        -screw_size - screw_wall_offset,
        rail_depth - mount_width / 2 - y_offset,
        wall_height - screw_size - 2
    ])
    rotate([180, 0, 0])
    screw_hole(screw_size, screw_length, top = 10);
}

module clylindric_edge(width, depth) {
    half_width = width / 2;
    cube([half_width, depth, half_width]);

    translate([half_width, 0, width])
    rotate([-90, 90, 0])
    quater_cylinder_inverted(depth, half_width);

    translate([half_width, 0, 0])
    rotate([-90, -90, 0])
    quater_cylinder(depth, half_width);
}

translate([0, 0, print_orientation ? rail_depth : 0])
rotate([print_orientation ? -90 : 0, 0, 0])
mirror([right_side ? 1 : 0, 0, 0])
difference() {
    union() {
        cube([wall_bottom_width, rail_depth, wall_bottom_height]);
        
        translate([0, 0, wall_bottom_height])
        cube([
            wall_middle_width,
            rail_depth,
            wall_middle_height
        ]);
        
        translate([0, 0, wall_height - box_top_height - rail_height])
        cube([wall_top_width, rail_depth, wall_top_height]);

        translate([wall_bottom_width, 0, rail_height])
        rail();
        
        translate([wall_middle_width, 0, wall_bottom_height])
        clylindric_edge(wall_width_diff, rail_depth);
        
        temp_height = wall_height - box_top_height;

        translate([wall_top_width, 0, temp_height])
        rail();

        temp_width = wall_top_width - wall_middle_width;
        translate([wall_top_width, 0, temp_height - rail_width - temp_width])
        rotate([-90, 180, 0])
        quater_cylinder_inverted(rail_depth, temp_width);

        translate([
            0,
            rail_depth,
            wall_height - mount_size])
        triangular_prism(
            [0, 0, 0],
            [0, 0, mount_size],
            [-mount_size, 0, mount_size],
            [0, -mount_width, 0]);
    }

    translate([
        wall_top_width,
        screw_offset,
        wall_bottom_height - screw_size
    ])
    rotate([0, 90, 0])
    screw_hole(screw_size, screw_length, top = 10);

    translate([
        wall_top_width,
        screw_offset,
        wall_height - (box_top_height / 2)
    ])
    rotate([0, 90, 0])
    screw_hole(screw_size, screw_length);

    back_screw_hole(mount_width / 4);
    back_screw_hole(-mount_width / 4);
}