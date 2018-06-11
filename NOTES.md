#  NOTES

Thought: Could the creations in the editor eventually lead to being able to "auto-generate" an xcode scenekit project, along with incorporating gameplay kit etc? Perhaps that would be something for 2.0...

____


There is no way to alter the data once it is created and rendered.
An option may be to use: https://developer.apple.com/documentation/scenekit/scngeometrysource/1522873-geometrysourcewithbuffer

However, another idea is to use an array of values, from which
the vectors are generated and model can be displayed.
The renderer would then need to remove and re-implement the geo/node
whenever a new vector/tri/quad is added.

What I need to know is, how to go from a point, to a tri, to a quad
And then update references to points, so if I reuse them then the
drawing order references its index and can update the position if
necessary. Therefore no multiple instances of single points need to
be referenced and updated multiple times.

This is also means that if only 1 point is created, making an odd
number of points such that there are enough quads/tri for all but 1/2
indices then (separately) a line can be drawn between these points.


____


Reference notes for future documentation and explanation of quirks/decisions/plans


To blend between two shapes, the index of the morph is retrieved via the index in morpher.weights[index] and at 1.0 the morph is implemented
