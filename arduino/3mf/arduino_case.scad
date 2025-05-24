// Kombiniertes Modell: Röhre mit Deckel und Haken
// Steuerungsvariablen für die Anzeige
show_case = true;        // Case ein-/ausblenden
show_cover = true;       // Deckel ein-/ausblenden
show_hook = true;        // Haken ein-/ausblenden
cover_y_offset = 10;     // Y-Verschiebung des Deckels (0 = genau über der Öffnung, positiv = nach hinten)
cover_thickening = 0.2;  // Verdickungsfaktor für die Wandstärke im Deckel (0 = exakte Passung, >0 = Presspassung)
cover_color = "yellow";  // Farbe für den Deckeleinsatz (Erhöhung)
hook_color = "blue";     // Farbe für den Haken

// Nur die Breiten der drei Rechtecke können angepasst werden
// Die anderen Maße bleiben wie im Original
press_fit = 0.2;
top_rect_width = press_fit + 12.5;    // Standardwert: 12.5
middle_rect_width = press_fit + 18.5; // Standardwert: 18.5
bottom_rect_width = press_fit + 13.5; // Standardwert: 13.5

// Steuerungsvariablen für den Verbindungssteg
show_bridge = true;      // Verbindungssteg ein-/ausblenden
bridge_y_position = 0;   // Position des Stegs in Y-Richtung (vom Beginn des hinteren Quaders)
bridge_width = 2;        // Breite des Verbindungsstegs in mm
bridge_color = "red";    // Farbe des Verbindungsstegs

// Farbeinstellungen für die Teile
thickening_color = "green";  // Farbe der Verdickungen (Übergangsbereich hinter dem Oval)

// Parameter
inner_oval_width = 14.8;  // Gesamte innere Breite des Ovals (original)
inner_height = 7;        // Innere Höhe
inner_radius = inner_height / 2; // Radius für die Rundungen = 3.5mm

// Korrektur der Geometrie für das Oval
inner_straight = inner_oval_width - (2 * inner_radius); // = 7,8mm

// Tiefe und Wandstärke
depth = 10.5;            // Tiefe der Röhre (Basis)
wall_thickness = 2;      // Grundlegende Wandstärke

// Äußere Dimensionen für das gesamte Objekt
outer_total_width = 22.5;  // Gesamtbreite außen (angepasst für 18,5mm Innenabstand im oberen Teil)
outer_height = 14.5;     // Gesamthöhe des Objekts

// Parameter für den hinteren Quader
rear_box_length = 44;    // Länge des hinteren Quaders (entlang Y-Achse)
rear_box_wall = 2;       // Wandstärke des hinteren Quaders
rear_inner_width = 18.5; // Innere Breite des hinteren Quaders
sidewall_y_extension = 3.5; // Verlängerung der Seitenwände in Y-Richtung (nach hinten)

// Parameter für die Verdickung
thickening_length = 3;    // Länge der Verdickung
thickening_thickness_left = 5.5;  // Dicke der Verdickung an der linken Seite
thickening_thickness_right = 7.5; // Dicke der Verdickung an der rechten Seite
thickening_thickness_top = 6;   // Dicke der Verdickung oben
thickening_thickness_bottom = 3; // Dicke der Verdickung unten

// Parameter für die seitlichen Verdickungen
side_thickening_x = 2.5;  // Breite (Dicke) der Seitenverdickung
side_thickening_y = 7;    // Höhe der Seitenverdickung (in Z-Richtung)

// Parameter für die zusätzlichen Verdickungen auf den verlängerten Seitenwänden
extension_thickening_width = rear_box_wall + 3;   // Breite/Stärke der Verdickung (Seitenwandstärke + 2mm)
extension_thickening_depth = 1;   // Tiefe (wie weit sie in den Hohlraum ragt)
extension_thickening_height = rear_box_length - thickening_length; // Höhe (gleich wie Seitenwände)

// Parameter für den Verbindungssteg
bridge_height = extension_thickening_depth; // Höhe des Stegs (gleich wie Verdickungen)

// Positionierung der ovalen Öffnung
oval_x_offset = 1;    // Horizontale Verschiebung der ovalen Öffnung (+ nach rechts, - nach links)

// Berechnung für die neue Position (Bodenplatte bei Z=0)
z_offset = outer_height/2 - wall_thickness; // = 6.25mm Verschiebung nach oben

// Parameter für den Deckel
cover_thickness = 2;     // Stärke des Grunddeckels
insert_depth = 2.5;        // Tiefe/Höhe des Einsatzes

// Parameter für den Haken
inner_diameter = 5;      // Innendurchmesser des Hakens in mm
hook_wall_thickness = 3; // Wandstärke des Hakens in mm
hook_height = 5;         // Höhe des Hakens in mm
hook_cut_position_y = 3; // Position des Schnitts für den Haken
hook_position_x = -2.5;     // Zusätzliche X-Verschiebung des Hakens (positiv = nach außen, negativ = nach innen)
hook_position_y = 40;    // Position des Hakens in Y-Richtung auf der Seitenwand
hook_position_z = 7.5;     // Position des Hakens in Z-Richtung auf der Seitenwand
hook_rotation = 90;      // Zusätzliche Rotation des Hakens um die X-Achse (0-360 Grad)

// Abgerundetes Rechteck mit konstantem Mittelteil (für den Innenraum)
module rounded_rect(total_width, height, center_distance, radius) {
    hull() {
        // Linker Kreis
        translate([-(center_distance/2), 0, 0])
            circle(r = radius, $fn=100);
        
        // Rechter Kreis
        translate([center_distance/2, 0, 0])
            circle(r = radius, $fn=100);
    }
}

// Modul für das Case (Röhre mit hinterem Quader)
module case_model() {
    // Gesamtes Modell in neuer Ausrichtung - Boden in X-Y-Ebene bei Z=0
    union() {
        // BASIS MIT OVALEM HOHLRAUM - vorderer Teil mit ovaler Öffnung
        // Nach oben verschoben, sodass die Bodenplatte bei Z=0 beginnt
        translate([0, 0, z_offset]) {
            difference() {
                // Äußerer Quader (rechteckig)
                translate([0, depth/2, 0])
                    cube([outer_total_width, depth, outer_height], center=true);
                
                // Inneres abgerundetes Rechteck (wird abgezogen) - mit Original-Maßen
                // Die ovale Öffnung kann über oval_x_offset horizontal verschoben werden
                translate([oval_x_offset, depth + 0.1, -1.75])
                    rotate([90, 0, 0])  // Drehen nur für die Extrusion - nicht das fertige Objekt
                    linear_extrude(height=depth + 0.2)
                        translate([0, 0, 0])
                        rounded_rect(inner_oval_width, inner_height, inner_straight, inner_radius);
            }
        }
        
        // ÜBERGANGSBEREICH MIT VERDICKUNG - zwischen vorderem und hinterem Teil
        translate([0, 0, z_offset]) {
            translate([0, depth, 0]) {
                color(thickening_color) {
                    difference() {
                        // Äußerer Quader der Verdickung
                        translate([0, thickening_length/2, 0])
                            cube([outer_total_width, thickening_length, outer_height], center=true);
                            
                        // Berechnen der Verschiebung für einen asymmetrischen inneren Hohlraum
                        x_offset = (thickening_thickness_right - thickening_thickness_left) / 2;
                        inner_width = outer_total_width - (thickening_thickness_left + thickening_thickness_right);
                            
                        // Innerer Quader mit asymmetrischer Position (individuelle Wandstärken links/rechts)
                        translate([x_offset, thickening_length/2, (thickening_thickness_bottom - thickening_thickness_top) / 2])
                            cube([inner_width, 
                                thickening_length + 0.2, 
                                outer_height - (thickening_thickness_top + thickening_thickness_bottom)], center=true);
                    }
                }
            }
        }
        
        // HINTERER QUADER (nach hinten offener Teil) - in Y-Richtung
        translate([0, 0, z_offset]) {
            translate([0, depth + thickening_length, 0]) {
                // Linker Seitenteil mit Verlängerung nach hinten
                translate([-outer_total_width/2, 0, -outer_height/2]) {
                    // Hauptteil
                    cube([rear_box_wall, rear_box_length - thickening_length, outer_height]);
                }
                
                // Rechter Seitenteil mit Verlängerung nach hinten
                translate([outer_total_width/2 - rear_box_wall, 0, -outer_height/2]) {
                    // Hauptteil
                    cube([rear_box_wall, rear_box_length - thickening_length, outer_height]);
                }
                
                // Unterer Teil (geschlossene Querseite, am Boden)
                translate([-outer_total_width/2, 0, -outer_height/2])
                    cube([outer_total_width, rear_box_length - thickening_length, rear_box_wall]);
                
                // Verdickungen auf den verlängerten Seitenwänden (seitlich)
                // Linke Verdickung
                translate([-outer_total_width/2, 0, outer_height/2 - extension_thickening_depth])
                    cube([extension_thickening_width, extension_thickening_height, extension_thickening_depth]);
                
                // Rechte Verdickung
                translate([outer_total_width/2 - extension_thickening_width, 0, outer_height/2 - extension_thickening_depth])
                    cube([extension_thickening_width, extension_thickening_height, extension_thickening_depth]);
            }
        }
        
        // SEITLICHE VERDICKUNGEN - in Y-Z-Richtung entlang des hinteren Quaders
        translate([0, 0, z_offset]) {
            translate([0, depth + thickening_length, 0]) {
                // Linke Seitliche Verdickung
                translate([
                    -rear_inner_width/2,                   // X-Position: linke Innenwand
                    0,                                     // Y-Position: Anfang des hinteren Quaders
                    -outer_height/2                        // Z-Position: DIREKT am Boden
                ])
                cube([side_thickening_x, rear_box_length - thickening_length, side_thickening_y]);
                
                // Rechte Seitliche Verdickung
                translate([
                    rear_inner_width/2 - side_thickening_x, // X-Position: rechte Innenwand
                    0,                                      // Y-Position: Anfang des hinteren Quaders
                    -outer_height/2                         // Z-Position: DIREKT am Boden
                ])
                cube([side_thickening_x, rear_box_length - thickening_length, side_thickening_y]);
            }
        }
    }
}

// Modul für den Verbindungssteg zwischen den oberen Verdickungen
module bridge_model() {
    // Position berechnen, um den Steg zwischen den beiden oberen Verdickungen zu platzieren
    translate([0, depth + thickening_length + bridge_y_position, z_offset]) {
        // Farbzuweisung für den Steg
        color(bridge_color) {
            // Steg, der die beiden oberen Verdickungen verbindet
            translate([
                -outer_total_width/2 + extension_thickening_width,  // X-Position: Beginnt am Ende der linken Verdickung
                0,                                                  // Y-Position: An der angegebenen Position
                outer_height/2 - bridge_height                      // Z-Position: Auf gleicher Höhe wie die Verdickungen
            ])
            // Breite = Gesamtbreite - (2 * Breite der Verdickungen) + minimale Überlappung
            cube([
                outer_total_width - 2 * extension_thickening_width,  // X-Größe: Abstand zwischen den Verdickungen
                bridge_width,                                        // Y-Größe: Breite des Stegs gemäß Einstellung
                bridge_height                                        // Z-Größe: Höhe des Stegs
            ]);
        }
    }
}

// Modul für den Deckel mit drei Rechtecken
module cover_model() {
    // Basis-Deckelplatte
    cube([outer_total_width, cover_thickness, outer_height]);
    
    // Drei einfache Rechtecke für die Verdickung mit symmetrisch berechneten Positionen
    translate([0, cover_thickness, 0]) {
        color(cover_color) {
            // Oberes Rechteck - symmetrisch positioniert
            translate([(outer_total_width - top_rect_width)/2, 0, outer_height - extension_thickening_depth])
                cube([top_rect_width, insert_depth, extension_thickening_depth]);
            
            // Mittleres Rechteck - symmetrisch positioniert
            translate([(outer_total_width - middle_rect_width)/2, 0, side_thickening_y])
                cube([middle_rect_width, insert_depth, outer_height - side_thickening_y - extension_thickening_depth]);
            
            // Unteres Rechteck - symmetrisch positioniert
            translate([(outer_total_width - bottom_rect_width)/2, 0, rear_box_wall])
                cube([bottom_rect_width, insert_depth, side_thickening_y - rear_box_wall]);
        }
    }
}

// Modul für den Haken
module hook_model() {
    outer_diameter = inner_diameter + (hook_wall_thickness * 2);
    
    color(hook_color) {
        // Zylinder mit variablem Schnitt
        intersection() {
            // Hohler Zylinder
            difference() {
                cylinder(h = hook_height, d = outer_diameter, $fn = 100);
                
                translate([0, 0, -1])
                    cylinder(h = hook_height + 2, d = inner_diameter, $fn = 100);
            }
            
            // Schnittebene mit variabler Position in Y-Richtung
            translate([-outer_diameter/2, -outer_diameter + hook_cut_position_y, 0])
                cube([outer_diameter, outer_diameter, hook_height]);
        }
    }
}

// Hauptmodell - Zusammenstellung basierend auf den Steuerungsvariablen
if (show_case) {
    case_model();
    
    // Steg wird nur angezeigt, wenn auch das Case angezeigt wird
    if (show_bridge) {
        bridge_model();
    }
    
    // Haken wird nur angezeigt, wenn er aktiviert ist und das Case angezeigt wird
    if (show_hook) {
        // Platziere den Haken an der linken Seitenwand
        translate([
            -outer_total_width/2 + hook_position_x,   // X-Position: an der linken Außenwand mit Offset
            depth + thickening_length + hook_position_y, // Y-Position: bestimmte Position auf der Seitenwand
            z_offset - outer_height/2 + hook_position_z  // Z-Position: bestimmte Höhe an der Seitenwand
        ]) {
            rotate([hook_rotation, 90, 0]) {  // Drehe den Haken, sodass er horizontal nach außen zeigt und die Rundung nach außen
                hook_model();
            }
        }
    }
}

if (show_cover) {
    // Einfache und direkte Positionierung des Deckels
    total_case_length = depth + thickening_length + (rear_box_length - thickening_length);
    
    // Platziere den Deckel präzise und automatisch zentriert
    // Der Wert outer_total_width wird direkt verwendet für korrekte Zentrierung
    translate([outer_total_width, total_case_length + cover_y_offset, z_offset]) {
        translate([-outer_total_width/2, 0, -outer_height/2]) {
            rotate([0, 0, 180]) {
                cover_model();
            }
        }
    }
}