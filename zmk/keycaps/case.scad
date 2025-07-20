$fn = 100;

// Parameters
wall_thickness = 2;  // Wall thickness in mm
wall_height = 12.5;     // Wall height in mm
bottom_thickness = 3.75; // Bottom thickness in mm
enable_bottom = true; // Enable/disable bottom plate
mirror = false;       // Mirror object along Y/Z plane (X=0)

// Hole parameters
hole_diameter = 5.25;    // Hole diameter in mm
hole_x = 135;         // X coordinate of hole center
hole_y = 9.5;          // Y coordinate of hole center
hole_z = 9.5;           // Z coordinate of hole center
hole_y_offset = -1;    // Y offset when mirror=true (added to hole_y)
hole_open_top = true;   // If true, hole is open to the top (slot/nut)

// Bottom holes parameters (round holes)
bottom_hole_diameter = 8; // Bottom hole diameter in mm
bottom_hole_depth = 1.75;   // Depth of round holes (0 = no holes, -1 = through hole, >0 = pocket from outside)
bottom_holes = [
    [10, 10],
    [10, 46.5],
    [124.5, 46.5],
    [116.5, -15]
];

// Rectangular hole parameters (pocket/einfräsung)
enable_rectangular_hole = true; // Enable/disable rectangular hole
rect_hole_x = 95;        // X position of rectangular hole center
rect_hole_y = 20;        // Y position of rectangular hole center
rect_hole_width = 66;    // Width of rectangular hole in mm
rect_hole_height = 20;   // Height of rectangular hole in mm
rect_hole_depth = 3;     // Depth of rectangular pocket (einfräsung) in mm

// Inner coordinates (given measurements)
inner_points = [
    [0, 0],
    [0, 56.5],
    [38, 56.5],
    [38, 61.5],
    [57, 61.5],
    [57, 63.5],
    [76, 63.5],
    [76, 61.5],
    [95, 61.5],
    [95, 59],
    [114, 59],
    [114, 57],
    [134.5, 57],
    [134.5, -4],
    [120, -29], // Spitze
    [104, -20],
    [66.5, -15], 
    [56, 0]
];

// Main object creation with conditional mirroring
if (mirror) {
    mirror([1, 0, 0]) {  // Mirror along Y/Z plane (X=0)
        create_object();
    }
} else {
    create_object();
}

// Module to create the main object
module create_object() {
    difference() {
        union() {
            // Bottom plate (conditional)
            if (enable_bottom) {
                linear_extrude(height = bottom_thickness)
                    offset(r = wall_thickness)
                        polygon(inner_points);
            }
            
            // Walls
            translate([0, 0, enable_bottom ? bottom_thickness : 0])
                linear_extrude(height = wall_height)
                    difference() {
                        // Outer shape (offset by wall thickness)
                        offset(r = wall_thickness)
                            polygon(inner_points);
                        
                        // Inner shape (cutout)
                        polygon(inner_points);
                    }
        }
        
        // Original 5.25mm hole at specified position (horizontal through wall in X-direction)
        // Adjusts Y position based on mirror setting and Z position based on whether bottom is enabled
        hole_center_z = hole_z + (enable_bottom ? bottom_thickness : 0);
        translate([hole_x, hole_y + (mirror ? hole_y_offset : 0), hole_center_z]) {
            if (hole_open_top) {
                // Create slot open to the top
                union() {
                    // Round hole part
                    rotate([0, 90, 0])
                        cylinder(h = 20, d = hole_diameter, center = true);
                    // Rectangular slot extending to top
                    slot_height = (enable_bottom ? bottom_thickness : 0) + wall_height - hole_center_z + hole_diameter/2;
                    translate([0, 0, hole_diameter/2])
                        rotate([0, 90, 0])
                            cube([slot_height, hole_diameter, 20], center = true);
                }
            } else {
                // Standard round hole
                rotate([0, 90, 0])
                    cylinder(h = 20, d = hole_diameter, center = true);
            }
        }
        
        // Bottom holes (8mm diameter, configurable depth)
        if (enable_bottom && bottom_hole_depth != 0) {
            for (pos = bottom_holes) {
                if (bottom_hole_depth > 0) {
                    // Create pocket from outside (bottom)
                    translate([pos[0], pos[1], -0.1])
                        cylinder(h = bottom_hole_depth + 0.1, d = bottom_hole_diameter);
                } else if (bottom_hole_depth == -1) {
                    // Create through hole
                    translate([pos[0], pos[1], -1])
                        cylinder(h = bottom_thickness + 2, d = bottom_hole_diameter);
                }
            }
        }
        
        // Rectangular pocket (einfräsung) in bottom plate
        if (enable_bottom && enable_rectangular_hole) {
            create_rectangular_pocket();
        }
    }
}

// Module for creating a rectangular pocket (einfräsung) on the outside (bottom)
module create_rectangular_pocket() {
    translate([rect_hole_x - rect_hole_width/2, rect_hole_y - rect_hole_height/2, -0.1])
        cube([rect_hole_width, rect_hole_height, rect_hole_depth + 0.1]); // +0.1 for clean boolean operation
}