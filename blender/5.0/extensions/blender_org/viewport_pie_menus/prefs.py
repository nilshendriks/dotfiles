# SPDX-FileCopyrightText: 2016-2024 Blender Foundation
#
# SPDX-License-Identifier: GPL-3.0-or-later

import platform, struct, urllib

import bpy
import addon_utils
from bpy.types import AddonPreferences, KeyMap, KeyMapItem
from bpy.props import BoolProperty
from bl_ui.space_userpref import USERPREF_PT_interface_menus_pie

from .bs_utils.prefs import get_addon_prefs
from .bs_utils.hotkeys import get_sidebar, draw_hotkey_list

class ExtraPies_AddonPrefs(
    AddonPreferences,
    USERPREF_PT_interface_menus_pie, # We use this class's `draw_centered` function to draw built-in pie settings.
):
    bl_idname = __package__

    show_in_sidebar: BoolProperty(
        name="Show in Sidebar",
        default=False,
        description="Show a compact version of the preferences in the sidebar. Useful when picking up the add-on for the first time to learn and customize it to your liking",
    )
    debug: BoolProperty(
        name="Debug Mode",
        default=False,
        description="Enable some debugging UI",
    )

    def draw(self, context):
        draw_prefs(self.layout, context, compact=False)

def draw_prefs(layout, context, compact=False):
    prefs = get_addon_prefs(context)

    sidebar = get_sidebar(context)
    if sidebar:
        compact = sidebar.width < 600

    layout.use_property_split = True
    layout.use_property_decorate = False

    if not compact:
        col = layout.column()
        row = col.row()
        row.operator('wm.url_open', text="Report Bug", icon='URL').url = (
            get_bug_report_url()
        )
        row.prop(prefs, 'debug', icon='BLANK1', text="", emboss=False)
        col.prop(prefs, 'show_in_sidebar')

    header, builtins_panel = layout.panel(idname="Extra Pies Builtin Prefs")
    header.label(text="Pie Preferences")
    if builtins_panel:
        prefs.draw_centered(context, layout)

    if not sidebar:
        # In the Preferences UI, still draw compact hotkeys list if the window is quite small.
        compact = context.area.width < 600
    header, hotkeys_panel = layout.panel(idname="Extra Pies Hotkeys")
    header.label(text="Hotkeys")
    if hotkeys_panel:
        hotkeys_panel.operator('window.restore_deleted_hotkeys', icon='KEY_RETURN')
        draw_hotkey_list(context, hotkeys_panel, sort_mode='BY_OPERATOR', compact=compact, button_draw_func=button_draw_func)

def button_draw_func(layout, km: KeyMap, kmi: KeyMapItem, compact=False):
    """This function is passed as a callback to draw_hotkey_list, which will in turn call it
    with these parameters to draw the key combo UI, where we want to insert a "Drag" button."""
    split = layout.split(factor=0.65, align=True)
    split.prop(kmi, "type", text="", full_event=True)

    if kmi.idname != 'wm.call_menu_pie_drag_only':
        return
    if not kmi.properties:
        sub.label(text="Missing properties. This should never happen!")
        return
    text = "" if compact else "Drag"

    sub = split.row(align=True)
    sub.enabled = kmi.active
    sub.context_pointer_set("keymapitem", kmi)
    sub.use_property_split=False
    sub.prop(kmi.properties, 'on_drag', icon='MOUSE_MOVE', text=text)

def get_bug_report_url():
    op_sys = "%s %d Bits\n" % (
        platform.platform(),
        struct.calcsize("P") * 8,
    )
    blender_version = "%s, branch: %s, commit: [%s](https://projects.blender.org/blender/blender/commit/%s)\n" % (
        bpy.app.version_string,
        bpy.app.build_branch.decode('utf-8', 'replace'),
        bpy.app.build_commit_date.decode('utf-8', 'replace'),
        bpy.app.build_hash.decode('ascii'),
    )

    addon_ver = ""
    for addon_module in addon_utils.modules():
        if addon_module.bl_info['name'] == '3D Viewport Pie Menus':
            addon_ver = str(addon_module.bl_info['version'])

    return (
        "https://projects.blender.org/extensions/space_view3d_pie_menus/issues/new?template=.gitea/issue_template/bug.yaml"
        + "&field:body="
        + urllib.parse.quote("Description of the problem:  \n\n\nSteps to reproduce:  \n\n\nBlend file:")
        + "&field:addon_ver="
        + urllib.parse.quote(addon_ver)
        + "&field:blender_ver="
        + urllib.parse.quote(blender_version)
        + "&field:op_sys="
        + urllib.parse.quote(op_sys)
    )

registry = [ExtraPies_AddonPrefs]
