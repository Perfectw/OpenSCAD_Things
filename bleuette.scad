
//include <servos.scad>

$fn = 25;

DEBUG = true;
BODY_HEIGHT = 65.0;
BODY_WIDTH = 27.5;

MAIN_HOLE_DIAMETER = 6;

SERVO_HOLE_DIAMETER = 0.5;
SERVO_WIDTH = 24;
SERVO_LENGTH = 53.5;

CHANFREIN = 4;

LEG_THICKNESS = 4;
LEG_HOLE_DIAMETER = 2.5;

CONNECTION_WIDTH = 8;

SERVO_HOLDER_HEIGHT = 11.5;
SERVO_HOLDER_WIDTH = 16;

WASHER_DIAMETER = 0;//17.7;
WASHER_HEIGHT = 1.1;

LEG_HOLDER_MIN_WALL_THICKNESS = 1;
LEG_HOLDER_MAX_WALL_THICKNESS = 3;

/**
 *  Todo:
 *  - Agrandir la fente des pattes pour limiter les frottements ?
 */

module servo_holder() {

    rotate([0, 0, 0]) {
        translate([-(SERVO_HOLDER_WIDTH - CHANFREIN) / 2, 0, - (SERVO_HOLDER_HEIGHT - CONNECTION_WIDTH / 2)]) {
            difference() {
                // Servo holder
                cube(size = [SERVO_HOLDER_WIDTH - CHANFREIN, SERVO_WIDTH, SERVO_HOLDER_HEIGHT]);

                // Servo hole
                // Not precise...
                //translate([-20, 8, 8]) rotate([0, 90, 0]) cylinder(h = 50, r = SERVO_HOLE_DIAMETER);
                //translate([-20, 18, 8]) rotate([0, 90, 0]) cylinder(h = 50, r = SERVO_HOLE_DIAMETER);

                // Servo holder chanfrein
                translate([SERVO_WIDTH, 20, -0.1])
                    rotate([0, -90, 0])
                        linear_extrude(height = 30)
                            polygon([[0, 0], [0, -SERVO_WIDTH - 0.1], [4, -SERVO_WIDTH]]);
            }

            translate([(SERVO_HOLDER_WIDTH - CHANFREIN) / 2, SERVO_WIDTH, SERVO_HOLDER_HEIGHT - CONNECTION_WIDTH / 2]) {
                difference() {
                    cube(size = [CONNECTION_WIDTH, CONNECTION_WIDTH, CONNECTION_WIDTH], center = true);
                    cube(size = [CONNECTION_WIDTH / 2.5, CONNECTION_WIDTH, CONNECTION_WIDTH], center = true);
                }
            }
        }
    }
}

module leg_holder(slot = false) {

    max_thickness = LEG_HOLDER_MAX_WALL_THICKNESS - LEG_HOLDER_MIN_WALL_THICKNESS;

    difference() {
        //cube(size = [LEG_HOLDER_MIN_WALL_THICKNESS + LEG_THICKNESS, 19, BODY_HEIGHT]);

        linear_extrude(height = BODY_HEIGHT) {
            polygon([
                [LEG_HOLDER_MIN_WALL_THICKNESS + LEG_THICKNESS, 19],
                [LEG_HOLDER_MIN_WALL_THICKNESS + LEG_THICKNESS + max_thickness, 15 + LEG_HOLE_DIAMETER],
                [LEG_HOLDER_MIN_WALL_THICKNESS + LEG_THICKNESS + max_thickness, 12 - LEG_HOLE_DIAMETER],
                [LEG_HOLDER_MIN_WALL_THICKNESS + LEG_THICKNESS, 0],
                [0, 0],
                [0, 19]
            ]);
        }

        translate([0, LEG_THICKNESS, -1]) {
            cube(size = [LEG_THICKNESS, 100, BODY_HEIGHT - 2]);
        }

        if (slot) {
            translate([0, LEG_THICKNESS - 5, BODY_HEIGHT / 2]) {
                cube(size = [LEG_THICKNESS, 100, BODY_HEIGHT / 2 - 3]);
            }
        }
    }

    translate([0, 0, BODY_HEIGHT / 2 - 3])
        cube(size = [LEG_THICKNESS, 19, 3]);

}

module support() {

    module support_servo_holder() {
        translate([CHANFREIN + SERVO_HOLDER_WIDTH / 2 - 2, -SERVO_WIDTH, SERVO_LENGTH + 4]) // 57
            rotate([0, 180, 0])
                servo_holder();

        translate([CHANFREIN + SERVO_HOLDER_WIDTH / 2 - 2, -SERVO_WIDTH, SERVO_HOLDER_HEIGHT - 3])
            servo_holder();
    }

    difference() {
        difference() {
            union() {
                difference() {
                    cube(size = [BODY_WIDTH, BODY_WIDTH, BODY_HEIGHT]);

                    translate([13.75, 10, 0]) {
                        // Main hole
                        translate([0, 0, -1]) {
                            cylinder(h = BODY_HEIGHT + 2, r = MAIN_HOLE_DIAMETER / 2);
                        }

                        if (WASHER_DIAMETER) {
                            // Washer
                            cylinder(r = WASHER_DIAMETER / 2, h = WASHER_HEIGHT / 2, center = true);

                            translate([0, 0, BODY_HEIGHT])
                                cylinder(r = WASHER_DIAMETER / 2, h = WASHER_HEIGHT / 2, center = true);
                        }
                    }

                    support_servo_holder();
                }

                if (DEBUG) {
                    support_servo_holder();
                }

                // Right leg holder
                translate([BODY_WIDTH, 4, 0]) {
                    leg_holder(true);
                }

                // Left leg holder
                translate([ 0, 4, 0]) {
                    mirror([1, 0, 0]) {
                        leg_holder(false);
                    }
                }
            }

            // Hole for leg
            translate([-50, BODY_WIDTH - 10, 10]) rotate([0, 90, 0]) cylinder(h = 100, r = LEG_HOLE_DIAMETER);
            translate([-50, BODY_WIDTH - 10, 50]) rotate([0, 90, 0]) cylinder(h = 100, r = LEG_HOLE_DIAMETER);
        }

        // Reduce size
        linear_extrude(height = BODY_HEIGHT) {
            // Body chanfrein
            polygon([[0, BODY_WIDTH - CHANFREIN], [0, BODY_WIDTH], [CHANFREIN, BODY_WIDTH]]);
            polygon([[BODY_WIDTH, BODY_WIDTH - CHANFREIN], [BODY_WIDTH, BODY_WIDTH], [BODY_WIDTH - CHANFREIN, BODY_WIDTH]]);
            polygon([[BODY_WIDTH, 0], [BODY_WIDTH, CHANFREIN], [BODY_WIDTH - CHANFREIN, 0]]);
            polygon([[0, 0], [0, CHANFREIN], [CHANFREIN, 0]]);
        }

        translate([BODY_WIDTH / 2, BODY_HEIGHT / 2, -1])
            cylinder(r = 10, h = BODY_HEIGHT + 1, $fn = 10);
    }

    // Rudder
    RUDDER_HEIGHT = 4;
    RUDDER_CYLINDER_HEIGHT = RUDDER_HEIGHT + 2;
    rotate([0, 0, 45]) {
        translate([16.5, -21, 0]) {

            translate([2.5, 1, 0])
                cube(size = [1, 5, RUDDER_CYLINDER_HEIGHT]);

            difference() {
                union() {
                    cube(size = [6, 7, RUDDER_HEIGHT]);
                    translate([3, 0, 0]) {
                        cylinder(r = 3, h = RUDDER_CYLINDER_HEIGHT);
                    }
                }

                translate([3, 0, -1]) cylinder(r = 0.7, h = 100);
            }

        }
    }
}

//translate([0, 0, 4]) rotate([0, 180, 0]) servo_holder();

if (1) {
    translate([-14, -10, 0]) {
        support();

        if (DEBUG) {
            color("GREY")
                translate([SERVO_HOLDER_WIDTH - 27, -1, BODY_HEIGHT - SERVO_HOLDER_HEIGHT - 0.5])
                    rotate([90, 180, 90])
                        futabas3003();
        }
    }
}

