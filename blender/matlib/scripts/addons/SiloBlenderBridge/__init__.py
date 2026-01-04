bl_info = {
    "name": "Silo Blender Bridge",
    "author": "Nevercenter",
    "version": (1, 0, 1),
    "blender": (3, 0, 0),
    "location": "3D View > Sidebar > Tool",
    "description": "Connect to Silo for external modeling round-trip",
    "category": "3D View",
}

import bpy
import os
import uuid
import re
import platform
import subprocess
from bpy.types import AddonPreferences, Operator, Panel
from bpy.props import StringProperty
from mathutils import Matrix

# ------------------------------------------------------------------------
# Constants and Globals
# ------------------------------------------------------------------------

# TEMP_EXPORT_PATH = os.path.join(os.path.expanduser("~"), "silo_bridge_temp.fbx")
TEMP_EXPORT_PATH = os.path.join(bpy.app.tempdir, "silo_bridge_temp.fbx")
TIMER_INTERVAL = 1.0
original_objects = {}
last_mod_time = None
watching_file = False
bridge_active = False
watcher_skip = False
exported_uuids = set()

# ------------------------------------------------------------------------
# Preferences
# ------------------------------------------------------------------------
def find_silo_path():
    """Try to locate the Silo app automatically, return full executable path or None."""
    system = platform.system()

    # --- macOS ---
    if system == "Darwin":
        candidates = [
            "/Applications/Silo.app/Contents/MacOS/Silo",
            os.path.expanduser("~/Applications/Silo.app/Contents/MacOS/Silo")
        ]
        for path in candidates:
            if os.path.isfile(path):
                return path

    # --- Windows ---
    elif system == "Windows":
        import winreg
        # Try registry first
        try:
            key = winreg.OpenKey(winreg.HKEY_LOCAL_MACHINE, r"SOFTWARE\Nevercenter\Silo")
            install_dir, _ = winreg.QueryValueEx(key, "Install_Dir")
            exe_path = os.path.join(install_dir, "Silo.exe")
            if os.path.isfile(exe_path):
                return exe_path
        except Exception:
            pass

        # Common fallback locations
        candidates = [
            r"C:\Program Files\Nevercenter Silo\Silo.exe",
            r"C:\Program Files (x86)\Nevercenter Silo\Silo.exe",
        ]
        for path in candidates:
            if os.path.isfile(path):
                return path

    # --- Linux (less common, but supported) ---
    elif system == "Linux":
        for path in ["/usr/bin/silo", "/usr/local/bin/silo"]:
            if os.path.isfile(path):
                return path

    return None

class ExternalModelerPreferences(AddonPreferences):
    bl_idname = __package__ or __name__  # Works in both dev and installed

    # Try to find Silo automatically
    default_path = find_silo_path() or ""


    app_path: StringProperty(
        name="Path to Silo App",
        description="Path to the Silo application",
        subtype='FILE_PATH',
        default=default_path,
    )

    def draw(self, context):
        version = bl_info.get("version", (0, 0, 0))
        layout = self.layout
        layout.label(text=f"Version {version[0]}.{version[1]}.{version[2]}")
        layout.label(text="Path to External Silo App:")
        layout.prop(self, "app_path")

# ------------------------------------------------------------------------
# Operators
# ------------------------------------------------------------------------


def capture_original_state(objs):
    """
    Call this once before sending to Silo.
    Stores the object reference and keeps original materials for later restore.
    """
    state = {}
    for obj in objs:
        slot_map = {}
        slot_names = []
        for slot in obj.material_slots:
            slot_names.append(slot.name)
            slot_map[slot.name] = slot.material
        state[obj.name] = {
            "object": obj,
            "slot_names": slot_names,
            "materials": slot_map  # original materials
        }
    return state

class WM_OT_send_to_silo(Operator):
    bl_idname = "wm.send_to_silo"
    bl_label = "Edit Selected In Silo"
    bl_description = "Export selected object(s) to Silo and monitor for changes"

    def execute(self, context):
        global original_objects, last_mod_time, watching_file, bridge_active

        export_temp_fbx(TEMP_EXPORT_PATH)

        last_mod_time = os.path.getmtime(TEMP_EXPORT_PATH)
        watching_file = True
        bridge_active = True

        prefs = context.preferences.addons[__package__].preferences
        app_path = bpy.path.abspath(prefs.app_path)
        # If not set or invalid, try auto-detecting
        if not app_path or not os.path.isfile(app_path):
            app_path = find_silo_path()

        if not app_path or not os.path.isfile(app_path):
            self.report({'ERROR'}, "Could not locate Silo. Please manually set the location in the plugin preferences.")
            return {'CANCELLED'}


        if platform.system() == "Darwin" and app_path.endswith(".app"):
            app_name = os.path.basename(app_path).replace(".app", "")
            app_path = os.path.join(app_path, "Contents", "MacOS", app_name)

        try:
            subprocess.Popen([app_path, TEMP_EXPORT_PATH, "-watch" ])
        except Exception as e:
            self.report({'ERROR'}, f"Failed to launch Silo: {e}")
            return {'CANCELLED'}

        bpy.app.timers.register(check_obj_modified, first_interval=TIMER_INTERVAL)

        self.report({'INFO'}, "Sent to Silo")
        # print(f"[Silo Bridge] Exported {len(selected)} objects to Silo")

        return {'FINISHED'}

    

class WM_OT_create_new_in_silo(Operator):
    bl_idname = "wm.create_new_in_silo"
    bl_label = "Create New In Silo"
    bl_description = "Create an empty file in Silo and monitor for changes"

    def execute(self, context):
        global original_objects, last_mod_time, watching_file, bridge_active
        
        original_objects = {}

        global exported_uuids
        exported_uuids = set()

        bpy.ops.export_scene.fbx(
            filepath=TEMP_EXPORT_PATH,
            use_selection=False,
            apply_unit_scale=False,
            apply_scale_options='FBX_SCALE_UNITS',
            bake_space_transform=True,
            object_types = {'EMPTY'}
        )


        last_mod_time = os.path.getmtime(TEMP_EXPORT_PATH)
        watching_file = True
        bridge_active = True

        prefs = context.preferences.addons[__package__].preferences
        app_path = bpy.path.abspath(prefs.app_path)
        # If not set or invalid, try auto-detecting
        if not app_path or not os.path.isfile(app_path):
            app_path = find_silo_path()

        if not app_path or not os.path.isfile(app_path):
            self.report({'ERROR'}, "Could not locate Silo. Please manually set the location in the plugin preferences.")
            return {'CANCELLED'}



        if platform.system() == "Darwin" and app_path.endswith(".app"):
            app_name = os.path.basename(app_path).replace(".app", "")
            app_path = os.path.join(app_path, "Contents", "MacOS", app_name)

        try:
            subprocess.Popen([app_path, TEMP_EXPORT_PATH])
        except Exception as e:
            self.report({'ERROR'}, f"Failed to launch Silo: {e}")
            return {'CANCELLED'}

        bpy.app.timers.register(check_obj_modified, first_interval=TIMER_INTERVAL)

        self.report({'INFO'}, "Sent to Silo")
        return {'FINISHED'}


# Activate/Deactivate Bridge operator
class WM_OT_toggle_bridge_monitoring(Operator):
    bl_idname = "wm.toggle_bridge_monitoring"
    bl_label = "Toggle Bridge"
    bl_description = "Activate or deactivate monitoring for updates from Silo"

    def execute(self, context):
        global bridge_active, last_mod_time, watching_file
        bridge_active = not bridge_active
        watching_file = bridge_active
        if bridge_active:
            import_modified_obj()
            bpy.app.timers.register(check_obj_modified, first_interval=TIMER_INTERVAL)
        last_mod_time = os.path.getmtime(TEMP_EXPORT_PATH)
        msg = "Activated Bridge" if bridge_active else "Deactivated Bridge"
        self.report({'INFO'}, msg)
        return {'FINISHED'}
    

class WM_OT_open_silo_preferences(bpy.types.Operator):
    bl_idname = "wm.open_silo_preferences"
    bl_label = "Open Silo Blender Bridge Preferences"

    def execute(self, context):
        module = __package__  # name of this addon’s module

        # Ensure the Preferences window is visible
        bpy.ops.screen.userpref_show('INVOKE_DEFAULT')

        # Show this addon's preferences
        bpy.ops.preferences.addon_show(module=module)

        return {'FINISHED'}

# ------------------------------------------------------------------------
# File Watching and Reimport
# ------------------------------------------------------------------------

def check_obj_modified():
    global last_mod_time, watching_file, bridge_active, watcher_skip

    if not watching_file:
        return None

    if not os.path.exists(TEMP_EXPORT_PATH):
        return TIMER_INTERVAL
    
    if watcher_skip:
        watcher_skip = False
        last_mod_time = os.path.getmtime(TEMP_EXPORT_PATH)
        return TIMER_INTERVAL

    current_time = os.path.getmtime(TEMP_EXPORT_PATH)
    if current_time > last_mod_time:
        # print(f"times: {last_mod_time} - {current_time}")
        # print(f"last mod time is: {last_mod_time}")
        # print("[Silo Bridge] file modified, re-importing...")
        import_modified_obj(TEMP_EXPORT_PATH)
        last_mod_time = current_time
        # watching_file = True

    return TIMER_INTERVAL



# ------------------------------------------------------------------------
# UI Panel
# ------------------------------------------------------------------------

class VIEW3D_PT_silo_bridge_panel(Panel):
    bl_label = "Silo Blender Bridge"
    bl_idname = "VIEW3D_PT_silo_bridge_panel"
    bl_space_type = 'VIEW_3D'
    bl_region_type = 'UI'
    bl_category = 'Tool'

    def draw(self, context):
        layout = self.layout

        # --- NEW: Preferences Button ---
        # row = layout.row()
        layout.operator("wm.open_silo_preferences", text="Preferences…", icon='PREFERENCES')

        layout.separator()
        layout.operator("wm.send_to_silo", icon='EXPORT')
        layout.operator("wm.create_new_in_silo", icon='EXPORT')

        layout.separator()

        # Bridge toggle
        label = "Deactivate Bridge" if bridge_active else "Activate Bridge"
        if bridge_active:
            layout.operator("wm.toggle_bridge_monitoring", text=label, icon='LINKED')

        # --- Centered, disabled version text at bottom ---
        version = bl_info.get("version", (0, 0, 0))
        row = layout.row()
        row.enabled = False  # Makes the text appear grayed out
        row.alignment = 'CENTER'
        row.label(text=f"Version {version[0]}.{version[1]}.{version[2]}")

# ------------------------------------------------------------------------
# Registration
# ------------------------------------------------------------------------

classes = (
    ExternalModelerPreferences,
    WM_OT_send_to_silo,
    WM_OT_create_new_in_silo,
    WM_OT_toggle_bridge_monitoring,
    WM_OT_open_silo_preferences,
    VIEW3D_PT_silo_bridge_panel,
)

def register():
    for cls in classes:
        bpy.utils.register_class(cls)

def unregister():
    for cls in reversed(classes):
        bpy.utils.unregister_class(cls)

if __name__ == "__main__":
    register()






# ────────────────────────────────────────────────
# UUID PATTERNS
# ────────────────────────────────────────────────

UUID_PATTERN = re.compile(r"\.__\[(.*?)\]$")
MATERIAL_UUID_PATTERN = re.compile(r"\.__\[(.*?)\]$")

# ────────────────────────────────────────────────
# Utility functions
# ────────────────────────────────────────────────

def extract_uuid(name):
    """Extracts UUID suffix from object name."""
    m = UUID_PATTERN.search(name)
    return m.group(1) if m else None

def find_original_by_uuid(uuid_str):
    """Finds an existing object with the given silo_uuid."""
    for obj in bpy.data.objects:
        if obj.get("silo_uuid") == uuid_str:
            return obj
    return None

def ensure_uuid_on_material(mat):
    """Assigns a persistent silo_mat_uuid to the material if it doesn't already have one."""
    uid = mat.get("silo_mat_uuid")
    if not uid:
        uid = uuid.uuid4().hex[:8]
        mat["silo_mat_uuid"] = uid
    return uid

def extract_material_uuid(name):
    """Extracts UUID suffix from material name."""
    m = MATERIAL_UUID_PATTERN.search(name)
    return m.group(1) if m else None

def find_material_by_uuid(uid):
    """Finds an existing material with the given UUID (in name or custom property)."""
    for mat in bpy.data.materials:
        if mat.get("silo_mat_uuid") == uid or extract_material_uuid(mat.name) == uid:
            return mat
    return None

def ensure_uuid_on_original(obj):
    """Ensure original object has persistent silo_uuid."""
    uid = obj.get("silo_uuid")
    if uid:
        return uid
    uid = uuid.uuid4().hex[:8]
    obj["silo_uuid"] = uid
    return uid

def make_export_name_from(obj, uid):
    """Generate export name with UUID suffix (with period)."""
    base_name = UUID_PATTERN.sub("", obj.name).rstrip()
    return f"{base_name}.__[{uid}]"

def append_material_uuids_for_export(obj):
    """Create copies of each material with its own persistent UUID tag (with period)."""
    new_materials = []
    for slot in obj.material_slots:
        mat = slot.material
        if mat:
            mat_uid = ensure_uuid_on_material(mat)
            mat_copy = mat.copy()
            base_name = MATERIAL_UUID_PATTERN.sub("", mat.name).rstrip()
            mat_copy.name = f"{base_name}.__[{mat_uid}]"
            new_materials.append(mat_copy)
        else:
            new_materials.append(None)
    return new_materials

def duplicate_objects_to_temp_collection_with_uuids(selected_objects):
    """Duplicate selected objects into a temp collection for export."""
    temp_coll = bpy.data.collections.new("SiloBridge_TempExport")
    bpy.context.scene.collection.children.link(temp_coll)
    duplicates = []

    for obj in selected_objects:
        uid = ensure_uuid_on_original(obj)

        dup = obj.copy()
        if obj.data:
            dup.data = obj.data.copy()

        # Assign new materials tagged by their own UUID (not object UUID)
        new_mats = append_material_uuids_for_export(obj)
        dup.data.materials.clear()
        for mat in new_mats:
            dup.data.materials.append(mat)

        dup.name = make_export_name_from(obj, uid)
        dup["silo_uuid"] = uid

        temp_coll.objects.link(dup)
        duplicates.append(dup)

    return temp_coll, duplicates

def export_temp_fbx(export_path):
    """Exports selected objects to a temporary FBX with UUIDs, then cleans up temporary objects and materials."""
    # selected = bpy.context.selected_objects

    # if not selected:
    #     print("[Silo Bridge] No objects selected for export.")
    #     return
    # Filter: only real geometry objects
    selected = [
        obj for obj in bpy.context.selected_objects 
        if obj.type == 'MESH'
    ]

    if not selected:
        # print("[Silo Bridge] No valid mesh objects selected for export.")
        return

    temp_coll, duplicates = duplicate_objects_to_temp_collection_with_uuids(selected)

    bpy.ops.object.select_all(action='DESELECT')
    for dup in duplicates:
        dup.select_set(True)
    bpy.context.view_layer.objects.active = duplicates[0]

    bpy.ops.export_scene.fbx(
        filepath=export_path,
        use_selection=True,
        apply_unit_scale=True,
        apply_scale_options='FBX_SCALE_NONE',
        bake_space_transform=True,
    )


    global exported_uuids
    exported_uuids = set(ensure_uuid_on_original(obj) for obj in selected)

    # Collect names of temporary materials we created
    temp_mat_names = set()
    for dup in duplicates:
        for slot in dup.material_slots:
            if slot.material:
                temp_mat_names.add(slot.material.name)

    # --- cleanup objects ---
    for dup in duplicates:
        bpy.data.objects.remove(dup, do_unlink=True)
    bpy.data.collections.remove(temp_coll)

    # --- cleanup materials ---
    for mat in list(bpy.data.materials):
        if mat.name in temp_mat_names:
            bpy.data.materials.remove(mat)

    # print(f"[Silo Bridge] Exported temporary FBX with UUID names: {export_path}")

# ────────────────────────────────────────────────
# Import modified FBX and sync changes
# ────────────────────────────────────────────────

def import_modified_obj(filepath):
    global watching_file, last_mod_time, watcher_skip
    """Imports modified FBX, updates existing objects, adds new ones, and removes deleted ones."""
    # print("[Silo Bridge] Importing modified objects...")

    watching_file = False

    # Snapshot before import
    before_objs = set(bpy.data.objects)

    bpy.ops.import_scene.fbx(
        filepath=filepath,
        bake_space_transform=True,
        use_custom_props=False,
        automatic_bone_orientation=False,
        use_custom_normals=False
    )

    after_objs = set(bpy.data.objects)
    imported_objs = after_objs - before_objs
    # print(f"[Silo Bridge] Found {len(imported_objs)} imported objects.")

    imported_uuids = set()
    updated_count = 0
    new_count = 0
    removed_count = 0

    # ─────────────────────────────────────────────────────────────
    # NEW: function to delete materials not actively used on mesh
    # ─────────────────────────────────────────────────────────────
    def clean_unused_materials(obj):
        """Remove materials from the object that are not actively used by any polygon."""
        if not obj.data or obj.type != 'MESH':
            return

        mesh = obj.data
        used_slots = set()

        # Track material indices used by polygons
        for poly in mesh.polygons:
            used_slots.add(poly.material_index)

        # Build a list of materials to keep
        keep_mats = []
        for i, slot in enumerate(obj.material_slots):
            if i in used_slots:
                keep_mats.append(slot.material)

        # Clear and rebuild slots
        obj.data.materials.clear()
        for m in keep_mats:
            obj.data.materials.append(m)

    # ─────────────────────────────────────────────────────────────
    loaded_objs = set()
    for new_obj in imported_objs:
        uid = extract_uuid(new_obj.name)
        if uid:
            imported_uuids.add(uid)
            # print(f"[Silo Bridge] Found uuid {uid}")

        orig = find_original_by_uuid(uid) if uid else None

        # Clean up unused materials immediately after import
        clean_unused_materials(new_obj)

        if orig:
            # Fix materials on imported mesh
            for slot in new_obj.material_slots:
                if not slot.material:
                    continue
                mat_uid = extract_material_uuid(slot.material.name)
                if mat_uid:
                    match = find_material_by_uuid(mat_uid)
                    if match:
                        slot.material = match
                    else:
                        slot.material["silo_mat_uuid"] = mat_uid

            # Update mesh + transforms
            orig.data = new_obj.data
            orig.matrix_world = new_obj.matrix_world.copy()
            updated_count += 1
            bpy.data.objects.remove(new_obj)
            loaded_objs.add(orig)

        else:
            # New object
            for i, slot in enumerate(new_obj.material_slots):
                if not slot.material:
                    continue
                mat = slot.material
                base_name = MATERIAL_UUID_PATTERN.sub("", mat.name).rstrip()
                existing = next((m for m in bpy.data.materials if m.name == base_name), None)
                if existing:
                    new_obj.material_slots[i].material = existing
                    if "silo_mat_uuid" not in existing:
                        existing["silo_mat_uuid"] = uuid.uuid4().hex[:8]
                else:
                    if "silo_mat_uuid" not in mat:
                        mat["silo_mat_uuid"] = uuid.uuid4().hex[:8]

            uid = uuid.uuid4().hex[:8]
            new_obj["silo_uuid"] = uid
            imported_uuids.add(uid)
            new_count += 1
            loaded_objs.add(new_obj)
            # print(f"[Silo Bridge] Added new object (assigned new UUID): {new_obj.name}")

    # Remove Blender objects deleted in Silo
    existing_tracked = [o for o in bpy.data.objects if "silo_uuid" in o and o["silo_uuid"] in exported_uuids]
    # print(f"[Silo Bridge] existing tracked count: {len(existing_tracked)}")
    for obj in existing_tracked:
        if obj["silo_uuid"] not in imported_uuids:
            # print(f"[Silo Bridge] REMOVING item from import...")
            bpy.data.objects.remove(obj)
            removed_count += 1

    # Remove unreferenced imported materials
    for mat in list(bpy.data.materials):
        if not mat.users and extract_material_uuid(mat.name):
            # print(f"[Silo Bridge] removing material {mat.name}")
            bpy.data.materials.remove(mat)

    # print(f"[Silo Bridge] Updated {updated_count}, added {new_count}, removed {removed_count}.")
    # print("[Silo Bridge] Import complete.")

    # Re-export if necessary
    if new_count > 0:
        print(f"[Silo Bridge] {new_count} new untracked object(s) found — re-exporting to update names with UUIDs...")
        bpy.ops.object.select_all(action='DESELECT')

        for obj in loaded_objs:
            try:
                obj.select_set(True)
            except ReferenceError:
                # Object was deleted, skip it
                # print(f"[Silo Bridge] SKIPPING deleted object")
                continue
        # bpy.context.view_layer.objects.active = imported_objs[0] if imported_objs else None

        # tracked_objs = [o for o in bpy.data.objects if "silo_uuid" in o]
        # for obj in tracked_objs:
        #     obj.select_set(True)
        # bpy.context.view_layer.objects.active = tracked_objs[0] if tracked_objs else None

        export_temp_fbx(filepath)

        last_mod_time = os.path.getmtime(TEMP_EXPORT_PATH)
        watcher_skip = True
        # print("[Silo Bridge] Auto re-export complete — Silo file now updated with UUID names.")

    watching_file = True
