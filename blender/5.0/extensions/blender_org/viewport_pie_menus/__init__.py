# SPDX-FileCopyrightText: 2016-2024 Blender Foundation
#
# SPDX-License-Identifier: GPL-3.0-or-later

import bpy
from bpy.utils import register_class, unregister_class
import importlib

_VPM_AGENT_IMMEDIATE_REGISTER_DONE = locals().get("_VPM_AGENT_IMMEDIATE_REGISTER_DONE", False)

module_names = (
    "op_pie_wrappers",
    "op_copy_to_selected",
    "bs_utils",
    "prefs",
    "sidebar",
    "tweak_builtin_pies",

    "pie_animation",
    "pie_apply_transform",
    "pie_camera",
    "pie_preferences",
    "pie_editor_split_merge",
    "pie_editor_switch",
    "pie_file",
    "pie_manipulator",
    "pie_mesh_delete",
    "pie_mesh_flatten",
    "pie_mesh_merge",
    "pie_object_add",
    "pie_object_display",
    "pie_object_parenting",
    "pie_proportional_editing",
    "pie_relationship_delete",
    "pie_sculpt_brush_select",
    "pie_selection",
    "pie_set_origin",
    "pie_view_3d",
    "pie_window",
)

modules = [
    __import__(__package__ + "." + submod, {}, {}, submod)
    for submod in module_names
]

def register_unregister_modules(modules: list, register: bool):
    """Recursively register or unregister modules by looking for either
    un/register() functions or lists named `registry` which should be a list of
    registerable classes.
    """
    register_func = register_class if register else unregister_class
    un = 'un' if not register else ''

    for m in modules:
        if register:
            importlib.reload(m)
        if hasattr(m, 'registry'):
            for c in m.registry:
                try:
                    register_func(c)
                except (AttributeError, RuntimeError, TypeError, ValueError) as e:
                    print(f"Warning: Pie Menus failed to {un}register class: {c.__name__}")
                    print(e)

        if hasattr(m, 'modules'):
            register_unregister_modules(m.modules, register)

        if register and hasattr(m, 'register'):
            m.register()
        elif hasattr(m, 'unregister'):
            m.unregister()

def delayed_register(_scene=None):
    # Register whole add-on with a slight delay,
    # to make sure Keymap data we need already exists on Blender launch.
    # Otherwise, keyconfigs.user.keymaps is an empty list, we can't find fallback ops.
    register_unregister_modules(modules, True)

def register():
    """
    We prefer an *immediate* register during startup, because other add-ons may touch
    keyconfig initialization very early, and Blender's keymap diff application appears
    sensitive to timing.

    If immediate registration fails (e.g. missing WM in edge cases), fall back to the
    legacy timer-based delayed registration.
    """
    global _VPM_AGENT_IMMEDIATE_REGISTER_DONE
    if not _VPM_AGENT_IMMEDIATE_REGISTER_DONE:
        try:
            register_unregister_modules(modules, True)
            _VPM_AGENT_IMMEDIATE_REGISTER_DONE = True
            return
        except Exception as e:
            # Keep behavior unchanged (fallback to timer), but avoid raising during registration.
            pass

    # NOTE: persistent=True must be set, otherwise this doesn't work when opening 
    # a .blend file directly from a file browser.
    bpy.app.timers.register(delayed_register, first_interval=0.0, persistent=True)

def unregister():
    register_unregister_modules(reversed(modules), False)
