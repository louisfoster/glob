# glob

3D modeling using swift+metal+scenekit for making models specifically for scenekit

## This is under active development and not suitable for use, however please get in touch if you would like to contribute

## TODO:

- Expose all functionality via Javascript Core && Some Keymapping tool
- Investigate feasibility of externally loaded HTML interface that can be connected to Javascript core
- SCNMorpher, Animation/rig/bones
- Add textures/shaders
- Tests and a documentation tool before things get out of hand...
    - Visual testing guidelines for when testing display of objects in the builder and the mobile viewer

### TODO Notes

When building the morpher, basically all the verts are duplicated but their values can be altered. This is considered a single morph, and each morph has weight, which is like a key value that sets when the full morph is in effect, e.g 1.0.

There needs to be a quick way to create a new morph, then alter the various verts assigned to the morph, and set a weight. Then another way to move between each weight to view the changes. This may be a good way to begin testing the implementation of a javascript interface.

Also a window listing the keymaps (and the ability to alter them) along with a description and their javascript counterpart would be useful
And a window where the javascript can be entered and run (html can come later)
