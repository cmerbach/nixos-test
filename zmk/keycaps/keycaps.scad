// Keycap dimensions
base_platform = true;     // Base platform on/off
wide_keycap = false;      // true = 20mm wide, false = 13.5mm wide

top_depth = 13.5;         // Top surface depth
base_extension = 4.5;     // How much wider at bottom
total_height = 10.0;      // Total keycap height
wall_thickness = 1.5;     // Wall thickness
corner_radius = 1.5;      // Corner radius

top_width = wide_keycap ? 20 : 13.5;  // Top surface width
bottom_width = top_width + base_extension;   // Bottom width
bottom_depth = top_depth + base_extension;   // Bottom depth

// Connector dimensions
connector_height = 8.5;   // Connector height
connector_diameter = 5.8; // Connector diameter
plus_width = 1.4;        // Plus cut width - before: 1.35
plus_thickness = 1.4;    // Plus cut thickness - before: 1.35
plus_length = 4.1;        // Plus cut length


// Creates Cherry MX style connector with plus cutouts
// Uses default $fn (no override)
module connector() {
    // $fn = 100;
    union() {
        difference() {
            cylinder(h = connector_height, d = connector_diameter);
            
            translate([-plus_width/2, -plus_length/2, -0.1])
            cube([plus_width, plus_length, connector_height + 0.2]);
            
            translate([-plus_length/2, -plus_thickness/2, -0.1])
            cube([plus_length, plus_thickness, connector_height + 0.2]);
        }
    }
}

// Creates rounded rectangles using 4 cylinders
module rounded_cube(width, depth, height, radius) {
    $fn = 100;  // High resolution for rounded corners
    hull() {
        translate([-(width/2-radius), -(depth/2-radius), 0])
            cylinder(r=radius, h=height, center=true);
        translate([(width/2-radius), -(depth/2-radius), 0])
            cylinder(r=radius, h=height, center=true);
        translate([-(width/2-radius), (depth/2-radius), 0])
            cylinder(r=radius, h=height, center=true);
        translate([(width/2-radius), (depth/2-radius), 0])
            cylinder(r=radius, h=height, center=true);
    }
}

// Creates the outer shell of the keycap
module keycap_outer() {
    hull() {
        if (base_platform) {
            translate([0, 0, wall_thickness/2])
                rounded_cube(bottom_width, bottom_depth, wall_thickness, corner_radius);
        } else {
            translate([0, 0, 0.1])
                rounded_cube(bottom_width, bottom_depth, 0.2, corner_radius);
        }
        
        translate([0, 0, total_height - wall_thickness/2])
            rounded_cube(top_width, top_depth, wall_thickness, corner_radius);
    }
}

// Creates the inner hollow space of the keycap
module keycap_inner() {
    hull() {
        // Open bottom
        translate([0, 0, -1])
            rounded_cube(bottom_width - 2*wall_thickness, 
                        bottom_depth - 2*wall_thickness, 
                        2, corner_radius/2);
        
        translate([0, 0, total_height - wall_thickness - 0.1])
            rounded_cube(top_width - 2*wall_thickness, 
                        top_depth - 2*wall_thickness, 
                        0.2, corner_radius/2);
    }
}

// Final keycap assembly
union() {
    difference() {
        keycap_outer();
        keycap_inner();
    }
    
    // Connector hangs from ceiling
    keycap_inside_top = total_height - wall_thickness;
    translate([0, 0, keycap_inside_top - connector_height])
        connector();
}
