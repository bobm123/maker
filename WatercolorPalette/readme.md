Watercolor Palette Cups for Mint Tins
=====================================

This OpenSCAD program will generate some small cups that can be used to hold watercolor paints. I got the idea from this instructable:
http://www.instructables.com/id/Movable-Pallet-Altoid-Tin-Watercolor-Set/

The author shows "1/2-pans" for watercolors mounted in an Altoid Tin with magnets. Honestly, the commercial ones are probably much cheaper and easier to clean than these cups. But if you only need a few to hold your favorite colors, these might be a way to go.

I also included code to create a "tool tray" with rounded corners and an extra long cup example. Either of these could be used to hold a sawed-off paintbrush for a tidy little paint set.

If you'd like some other sizes, you can hack the basic_cup_size or xl_cup_size arrays. The 14mm height takes it to just below the hinge cutout. You could make them a little shorter if you'd like. The 19mm x 15.25mm footprint lets you put up to 16 color cups in a single tin with a nice snug fit. You could also make other sizes and if you stick to multiples of 19mm and 15.25mm they should still fit. Maybe a 38mm x 30.5mm cup to hold a sponge?

You could also use these with thing 753052 (http://www.thingiverse.com/thing:753052) by adjusting the size to something like 20.0 x 16 x 10.0 mm and optionally setting the rounding radius to 0 like this:
```
use <MintyInserts.scad>
import("altoids_tin_watercolor_palette.stl");
special_cup_size = [20.0, 16, 10.0];
color("White")
    translate([-12.5, -14, 3]) 
        rounded_interior_cup(special_cup_size, rr=0);
```
Thanks for looking!
Bob M 
