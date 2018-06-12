# glob

3D modeling using swift+metal+scenekit for making models specifically for scenekit

## This is under active development and not suitable for use, however please get in touch if you would like to contribute

## TODO:

- Animation not working on bones....
    - scnskinner not creating skeleton root node...
    - need to check base mesh transform for skinner
    - animations not being applied to skinner-based renders! whole parent node will move but skinner bones do not! animations can be applied all the way down until bones, which do not get animated in the usual manner.
    - perhaps there is a requirement for more manual control over animations: CoreAnimation's CAKeyframeAnimation/CAAnimationGroup APIs.

- Data model versioning (when it gets to a useable point)
- Expose all functionality via Javascript Core && Some Keymapping tool
- Investigate feasibility of externally loaded HTML interface that can be connected to Javascript core
- (need to calculate and export normals (incl. morphs), texture coords/indices)
- Animation/rig/bones
- Add textures/shaders
- Tests and a documentation tool before things get out of hand...
    - Visual testing guidelines for when testing display of objects in the builder and the mobile viewer
