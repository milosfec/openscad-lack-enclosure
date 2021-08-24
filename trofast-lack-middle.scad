use <libmf.scad>;
include <trofast-params.scad>;

print_orientation = false;

wall_width = 12;
total_width = wall_width + 2 * rail_width;
half_width = total_width / 2;

total_height = rail_height + box_top_height;

bottom_wall_width = total_width - 2 * rail_height;
bottom_half_width = bottom_wall_width / 2;

screw_length = 40;
screw_top = 20;
screw_z = total_height - 25;

rotate([print_orientation ? 90 : 0, 0, 0])
difference() {
    union() {        
        translate([-bottom_half_width, 0, rail_height])
        rotate([-90, 90, 0])
        quater_cylinder(rail_depth, rail_height);
        
        translate([bottom_half_width, 0, rail_height])
        rotate([-90, 0, 0])
        quater_cylinder(rail_depth, rail_height);
        
        translate([-bottom_half_width, 0, 0])
        cube([bottom_wall_width, rail_depth, rail_height]);
        
        translate([-wall_width / 2, 0, rail_height])
        cube([wall_width, rail_depth, box_top_height]);
    }
    
    translate([0, screw_offset, screw_z])
    rotate([180, 0, 0])
    screw_hole(screw_size, screw_length, top = screw_top);

    translate([0, rail_depth - screw_offset, screw_z])
    rotate([180, 0, 0])
    screw_hole(screw_size, screw_length, top = screw_top);

    translate([0, rail_depth / 2, screw_z])
    rotate([180, 0, 0])
    screw_hole(screw_size, screw_length, top = screw_top);
}