# Alpha Design

This design was the first and was created iteratively to get *something that worked*.

It incorporates all the main components that the design requires, but is in no way *optimsed*.

## Important points

- Sanding the interface layers with a really fine grain sandpaper helps for really smooth functionality
- Print the geared components with a raft so that we don't get wierd edge effects which affect binding.

## Pictures

### Complete
![alt text](/scad/alpha/alpha_complete.jpg "the complete alpha design")

### Upper
![alt text](/scad/alpha/alpha_upper.jpg "the upper half of the alpha design")

### Lower
![alt text](/scad/alpha/alpha_lower.jpg "the lower half of the alpha design")


## Good points:

- Design can be assembled as two independant assemblies. The upper **gearbox assembly** and the lower **electronics assembly**. The two are then joined by the five longer central screws.
- The design of the undercarriage is really nice.
- The LED ring works well, although it should probably be centered in the next revision.
- The tolerances work well, and runs very smoothly with only a little post processing. Rafts of the geared components was the right route, and nice thick ones even though this leads to difficulty removing them.
- The height tolerance above the encoder button can be really easily tweeked using tape attached to the top of the central inner encoder mount.

## Bad points:

- It's quite tall! Perhaps just a bit stumpy, and the lower design could be executed better.
- The nuts which join to the longer central joining screws can easily slide out of place. Perhaps an interference fit or some geometry to capture them might be more appropriate for the next design.
- In practice the gearing is actually too low. You have to turn the knob quite a long way for the relevant increase in volume
- You can't just put your finger on the upper rim as that's integrated with the planet gears and not the ring gear, future versions should have the whole top corner be the interface point for a users finger. this should be linked to the external knurling.
- Designing the geared parts with either bevels or chamfers to make it so rafts aren't necessary would make printing much easier.
- The planetary gear carriers (both upper and lower) don't hold the screws very nicely, a thicker lower would hold the nuts better. Ideally printed in such a way that the hexagonal holders are on the upper side to ease printing.
- It's not **obviously** geared - linked to the gear ratio - perhaps a design where the planets are fixed, the outer rign moves and the center turns the encoder could work well. Could also make construction easier. Ideally we need to find a way of statically holding the upper and lower sides of the planet gears for stiffness. It could also mean an off centre encoder??? That could be very cool. An asymmetric planetary system could be fun.
- We've got the arduino interface for all of the multimedia keys. Mute & skip would be useful buttons to also have. Could implement using microswitches, or even better - 3d print a switch??!
- It's quite light, and so doesn't grip very well on the table. Perhaps some legit bearings would make it more weighty.
