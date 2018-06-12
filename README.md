# glob

3D modeling using swift+metal+scenekit for making models specifically for scenekit

## This is under active development and not suitable for use, however please get in touch if you would like to contribute

## TODO:

- Animation not working on bones....
    - scnskinner not creating skeleton root node...
    - need to check base mesh transform for skinner
    - animations only work through custom action for some reason...
        - issues might be resolved by running in parallel (group) or sequentially (sequence)
        - testing whether phyics works on objects or inverse kinematics
        - there's also speed, timing mode, timing function etc.
        - constraints don't seem to have an effect

- Data model versioning (when it gets to a useable point)
- Expose all functionality via Javascript Core && Some Keymapping tool
- Investigate feasibility of externally loaded HTML interface that can be connected to Javascript core
- (need to calculate and export normals (incl. morphs), texture coords/indices)
- Animation/rig/bones
- Add textures/shaders
- Tests and a documentation tool before things get out of hand...
    - Visual testing guidelines for when testing display of objects in the builder and the mobile viewer
