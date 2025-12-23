bl_info = {
    "name": "Place on Floor",
    "author": "ChatGPT",
    "version": (1, 0),
    "blender": (5, 0, 0),
    "location": "3D View > Sidebar > Floor Tab",
    "description": "Move active object so its bottom sits at Z=0",
    "category": "Object",
}

import bpy
from mathutils import Vector


class OBJECT_OT_place_on_floor(bpy.types.Operator):
    bl_idname = "object.place_on_floor"
    bl_label = "Place on Floor"
    bl_description = "Move the selected object so its bottom sits at Z=0"
    bl_options = {"REGISTER", "UNDO"}

    def execute(self, context):
        obj = context.active_object
        if not obj:
            self.report({"WARNING"}, "No active object")
            return {"CANCELLED"}
        if obj.type != "MESH":
            self.report({"WARNING"}, "Active object is not a mesh")
            return {"CANCELLED"}

        # World-space bounding box
        bbox_world = [obj.matrix_world @ Vector(corner) for corner in obj.bound_box]
        min_z = min(v.z for v in bbox_world)

        # Move object
        obj.location.z -= min_z

        return {"FINISHED"}


class VIEW3D_PT_place_on_floor_panel(bpy.types.Panel):
    bl_label = "Place on Floor"
    bl_idname = "VIEW3D_PT_place_on_floor_panel"
    bl_space_type = "VIEW_3D"
    bl_region_type = "UI"
    bl_category = "Floor"

    def draw(self, context):
        layout = self.layout
        layout.operator("object.place_on_floor", text="Place on Floor")


classes = [OBJECT_OT_place_on_floor, VIEW3D_PT_place_on_floor_panel]


def register():
    for cls in classes:
        bpy.utils.register_class(cls)


def unregister():
    for cls in reversed(classes):
        bpy.utils.unregister_class(cls)


if __name__ == "__main__":
    register()
