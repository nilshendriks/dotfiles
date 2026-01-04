import math
from string import printable

import bpy


# ---------- Properties ----------
class CameraExposureProps(bpy.types.PropertyGroup):
    def update_exposure(self, context):
        print("update_exposure")
        cam = self.id_data
        # if not cam or cam.type != "CAMERA":
        #     return
        iso = self.ISO
        print(iso)
        fstop = self.F_Stop
        # Base assumptions: ISO=100, f8 → exposure=1
        ev_diff = math.log2(iso / 100) - 2 * math.log2(fstop / 8)
        # Update Film exposure
        print(context.scene.camera)
        # context.scene.cycles.film_exposure = 1 * 2 ** (-ev_diff)
        context.scene.cycles.film_exposure = 2 ** (ev_diff)
        context.scene.cycles.preview_pause ^= True
        context.scene.cycles.preview_pause ^= True

    ISO: bpy.props.IntProperty(
        name="ISO",
        description="Camera ISO",
        default=100,
        min=80,
        max=6400,
        update=update_exposure,
    )

    F_Stop: bpy.props.FloatProperty(
        name="f-stop",
        description="Camera f-number",
        default=8.0,
        min=1.7,
        max=22.0,
        update=update_exposure,
    )


# ---------- UI Panel ----------
class CAMERA_PT_exposure_panel(bpy.types.Panel):
    bl_label = "GFX Exposure Rig"
    bl_idname = "CAMERA_PT_exposure_rig"
    bl_space_type = "PROPERTIES"
    bl_region_type = "WINDOW"
    bl_context = "data"

    @classmethod
    def poll(cls, context):
        return context.camera is not None

    def draw(self, context):
        layout = self.layout
        cam = context.camera
        layout.prop(cam.exposure_props, "ISO")
        layout.prop(cam.exposure_props, "F_Stop")
        # layout.label(text=f"Exposure: {cam.exposure:.3f}")


# ---------- Registration ----------
classes = [CameraExposureProps, CAMERA_PT_exposure_panel]


def register():
    for cls in classes:
        bpy.utils.register_class(cls)
    bpy.types.Camera.exposure_props = bpy.props.PointerProperty(
        type=CameraExposureProps
    )


def unregister():
    for cls in reversed(classes):
        bpy.utils.unregister_class(cls)
    del bpy.types.Camera.exposure_props


if __name__ == "__main__":
    register()
