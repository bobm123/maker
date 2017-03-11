/*
 * laser_cal.scad <https://github.com/bobm123/maker>
 *
 * Copyright (c) 2016 Robert Marchese.
 * Licensed under the MIT license.
 *
 * Generates a series of 10mm squares that may be used
 * to determine laser kerf. Adjust laser and cut the 
 * tiles. Set 10 of them side-by-side and measure
 * their overall length, X. The kerf is (100 - X) / 10.
 * 
 */

laser_cal(5, 2);

module laser_cal(N=4, M=4)
{
    for (m=[0:1:M-1])
    {
        for (n=[0:1:N-1])
        {
            translate([12*n, 12*m]) square(10);
        }
    }
}