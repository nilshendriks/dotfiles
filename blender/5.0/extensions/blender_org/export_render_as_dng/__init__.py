# __init__.py

bl_info = {
    "name": "Export Render as DNG",
    "author": "FloBEAUG",
    "version": (1, 0, 2),
    "blender": (4, 0, 0),
    "location": "Image Editor > Image > Export as DNG",
    "description": "Exports the current render or image as a Bayer-style DNG file",
    "category": "Image",
}

import bpy
import numpy as np
import sys
import subprocess
import importlib
import os

#addon_dir = os.path.dirname(__file__)
#if addon_dir not in sys.path:
#    sys.path.insert(0, addon_dir)

from .rgb_to_dng import save_as_dng


class IMAGE_OT_export_to_dng(bpy.types.Operator):
    """Export the current image as DNG"""
    bl_idname = "image.export_to_dng"
    bl_label = "Export as DNG"
    bl_options = {'REGISTER'}

    filepath: bpy.props.StringProperty(subtype="FILE_PATH")

    def execute(self, context):
        img = context.space_data.image
        if img is None:
            self.report({'ERROR'}, "No image selected")
            return {'CANCELLED'}

        cam = bpy.context.scene.camera
        if cam and cam.type == 'CAMERA':
            focal = round(cam.data.lens, 2)
            fstop = round(cam.data.dof.aperture_fstop, 2)

        scene = bpy.context.scene
        prev_view_transform = scene.view_settings.view_transform
        orig_format = scene.render.image_settings.file_format
        orig_color_mode = scene.render.image_settings.color_mode

        # Set color management to Raw (important for true linear data)
        scene.view_settings.view_transform = 'Raw'
        scene.render.image_settings.file_format = 'TARGA_RAW'
        scene.render.image_settings.color_mode = 'RGBA'

        tmp_path = bpy.path.abspath("//__temp_export__.tiff")
        img.save_render(tmp_path)
        img = bpy.data.images.load(tmp_path)

        # Get pixel data as numpy array
        w, h = img.size
        pixels = np.array(img.pixels[:]).reshape(h, w, 4)[:, :, :3]  # RGB

        save_as_dng(pixels, self.filepath, focal=focal, fstop=fstop)

        # Restore the original view transform
        scene.view_settings.view_transform = prev_view_transform
        scene.render.image_settings.file_format = orig_format
        scene.render.image_settings.color_mode = orig_color_mode

        # Cleanup temp
        try:
            os.remove(tmp_path)
        except OSError:
            self.report({'WARNING'}, f"Can't clean temporary file : {tmp_path}")
            pass

        self.report({'INFO'}, f"DNG saved to {self.filepath}")
        return {'FINISHED'}

    def invoke(self, context, event):
        blend_path = bpy.data.filepath
        if not blend_path.endswith('.dng'):
            default_name = os.path.splitext(os.path.basename(bpy.data.filepath))[0]+'.dng'
            default_dir = os.path.dirname(bpy.data.filepath)
        else:
            default_name = "untitled.dng"
            default_dir = bpy.path.abspath("//")

        # Suggest output path in the file selector
        self.filepath = default_dir + "/" + default_name

        context.window_manager.fileselect_add(self)
        return {'RUNNING_MODAL'}


def menu_func(self, context):
    self.layout.operator(IMAGE_OT_export_to_dng.bl_idname, text="Export as DNG")


def register():
    bpy.utils.register_class(IMAGE_OT_export_to_dng)
    bpy.types.IMAGE_MT_image.append(menu_func)


def unregister():
    bpy.utils.unregister_class(IMAGE_OT_export_to_dng)
    bpy.types.IMAGE_MT_image.remove(menu_func)


if __name__ == "__main__":
    register()
