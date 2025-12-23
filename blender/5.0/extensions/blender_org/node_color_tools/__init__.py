# SPDX-License-Identifier: GPL-3.0-or-later

bl_info = {
    "name": "Node Color Tools Pie",
    "author": "Johannes Kollmer (Lumpengnom)",
    "version": (1, 0, 3),
    "blender": (4, 2, 0),
    "location": "Node Editor -> Pie Menu OR Node Editor -> Sidebar -> Node Tab",
    "description": "Quick, organized node colors with pie menu ease",
    "category": "Node",
}

import bpy
import numpy
import colorsys





# N-Panel Layout in the Node editor

class NodeColorTools(bpy.types.PropertyGroup):
    nodecolor1: bpy.props.FloatVectorProperty(name = "Color 1", subtype = 'COLOR', default=(0.8, 0.3, 0.25),  min=0.0, max=1.0)
    nodecolor2: bpy.props.FloatVectorProperty(name="Color 2", subtype='COLOR', default=(0.3, 0.6, 0.25), min=0.0, max=1.0)
    nodecolor3: bpy.props.FloatVectorProperty(name="Color 3", subtype='COLOR', default=(0.0, 0.5, 0.9), min=0.0, max=1.0)
    nodecolor4: bpy.props.FloatVectorProperty(name="Color 4", subtype='COLOR', default=(0.7, 0.6, 0.2), min=0.0, max=1.0)
    nodecolor5: bpy.props.FloatVectorProperty(name="Color 5", subtype='COLOR', default=(0.4, 0.3, 0.8), min=0.0, max=1.0)



class NODE_PT_color_tools_panel(bpy.types.Panel):
    bl_label = "Node Color Tools"
    bl_idname = "NODE_PT_color_tools_panel"
    bl_space_type = 'NODE_EDITOR'
    bl_region_type = 'UI'
    bl_category = 'Node'

    def draw(self, context):
        layout = self.layout
        
        nodeColorTools = bpy.context.scene.node_color_tools
        
        # Section for Random and Copy Color functions
        layout.operator("node.set_color_random", text="Random Color")
        layout.operator("node.set_color_copyfromactive", text="Copy Color from Active Node")


        # Section for Predefined Colors
        #layout.label(text="Set Colors:")

        # Create a grid layout with four columns
        row = layout.row(align=True)
        
        # First column with Buttons
        col1 = row.column(align=True)
        color1_item = col1.operator("node.set_color_1", text="Set")
        color1_item.color = nodeColorTools.nodecolor1
        color2_item = col1.operator("node.set_color_1", text="Set")
        color2_item.color = nodeColorTools.nodecolor2
        color3_item = col1.operator("node.set_color_1", text="Set")
        color3_item.color = nodeColorTools.nodecolor3

        # Second column with Color Pickers
        col2 = row.column(align=True)
        col2.prop(nodeColorTools, "nodecolor1", text="")
        col2.prop(nodeColorTools, "nodecolor2", text="")
        col2.prop(nodeColorTools, "nodecolor3", text="")

        # Third column with Buttons
        col3 = row.column(align=True)
        color4_item = col3.operator("node.set_color_1", text="Set")
        color4_item.color = nodeColorTools.nodecolor4
        color5_item = col3.operator("node.set_color_1", text="Set")
        color5_item.color = nodeColorTools.nodecolor5
        

        # Fourth column with Color Pickers
        col4 = row.column(align=True)
        col4.prop(nodeColorTools, "nodecolor4", text="")
        col4.prop(nodeColorTools, "nodecolor5", text="")  # Added Purple Color Picker here

        # Section for Remove color Button
        #layout.label(text="Remove Color:")

        layout.operator("node.set_color_remove", text="Remove Color")


## Dummy Operator for layout only, no functionality
#class NODE_OT_dummy_action(bpy.types.Operator):
#    bl_idname = "node.dummy_action"
#    bl_label = "Dummy Action"
#    
#    def execute(self, context):
#        return {'FINISHED'}
#    




# Button Classes

#################### Customizable color operator ########
class NODE_OT_set_color_1(bpy.types.Operator):
    bl_idname = "node.set_color_1"
    bl_label = "Set Color 1"
    color: bpy.props.FloatVectorProperty(name="Node Color", subtype='COLOR', size=3)
    
    def execute(self, context):
        
        
        nodes = bpy.context.selected_nodes
        newColor = self.color
        
        for node in nodes:
            node.use_custom_color = True
            node.color = newColor
            
        
        
        return {'FINISHED'}


###################### Hard coded color operator #############

    
class NODE_OT_set_hardcoded_color_1(bpy.types.Operator):
    bl_idname = "node.set_hardcoded_color_1"
    bl_label = "Set Color"
    color: bpy.props.FloatVectorProperty(name="Node Color", subtype='COLOR', size=3)
    
    def execute(self, context):
        
        
        nodes = bpy.context.selected_nodes
        
        newColor = self.color
        
        for node in nodes:
            node.use_custom_color = True
            node.color = newColor

        return {'FINISHED'}



################ Remove, copy from Active and Random Operators ###############

class NODE_OT_set_color_remove(bpy.types.Operator):
    bl_idname = "node.set_color_remove"
    bl_label = "Remove Color"

    def execute(self, context):
        #Remove colors from nodes
        
        nodes = bpy.context.selected_nodes

        
        for node in nodes:
            node.use_custom_color = False
                    
        
        return {'FINISHED'}


class NODE_OT_set_color_copyFromActive(bpy.types.Operator):
    bl_idname = "node.set_color_copyfromactive"
    bl_label = "Copy Color from Active Node"

    
    @classmethod
    def poll(cls, context):
        # Check if we are in the node editor
        if context.space_data.type == 'NODE_EDITOR':
            # Check if there is an active node tree (e.g., a material node tree)
            if context.space_data.node_tree:
                # Check if there is an active node selected
                if context.space_data.node_tree.nodes.active:
                    return True
        return False
    
    def execute(self, context):
        # Copy the color of the active node to all selected nodes
                
        nodes = bpy.context.selected_nodes
        activeColor = bpy.context.active_node.color
        
        for node in nodes:
            node.use_custom_color = True
            node.color = activeColor
        
        return {'FINISHED'}
    
    
class NODE_OT_set_color_random(bpy.types.Operator):
    bl_idname = "node.set_color_random"
    bl_label = "Set random color"

    def execute(self, context):
        
        # set selected nodes to a random color    
        nodes = bpy.context.selected_nodes
                
        for node in nodes:
            node.use_custom_color = True
            randomHSV = numpy.random.rand(1,3)
            # never make random colors too bright. The V value of the HSV get divided by 1.7 to ensure this
            randomRGB = colorsys.hsv_to_rgb(randomHSV[0][0],randomHSV[0][1],randomHSV[0][2]/1.7)
            node.color = [randomRGB[0],randomRGB[1],randomRGB[2]]
        
        return {'FINISHED'}



    

    



# Pie Menu Class

class NODE_MT_color_tools_pie(bpy.types.Menu):
    bl_label = "Precise Colors"
    bl_idname = "NODE_MT_color_tools_pie"

    def draw(self, context):
        layout = self.layout
        
            
        # Define the pie menu layout
        pie = layout.menu_pie()

        
        col3 = pie.column(align=True)
        color3_item = col3.operator("node.set_color_1", text="Color 3")
        color3_item.color = context.scene.node_color_tools.nodecolor3
        col3.prop(context.scene.node_color_tools, "nodecolor3", text="")
        
        col4 = pie.column(align=True)
        color4_item = col4.operator("node.set_color_1", text="Color 4")
        color4_item.color = context.scene.node_color_tools.nodecolor4
        col4.prop(context.scene.node_color_tools, "nodecolor4", text="")
        
        col7 = pie.column(align=True)
        col7.operator("node.set_color_copyfromactive", text="Copy from Active")
        
        col6 = pie.column(align=True)
        col6.operator("node.set_color_random", text="Random")
        
        col1 = pie.column(align=True)
        color1_item = col1.operator("node.set_color_1", text="Color 1")
        color1_item.color = context.scene.node_color_tools.nodecolor1
        col1.prop(context.scene.node_color_tools, "nodecolor1", text="")
        
        col2 = pie.column(align=True)
        color2_item = col2.operator("node.set_color_1", text="Color 2")
        color2_item.color = context.scene.node_color_tools.nodecolor2
        col2.prop(context.scene.node_color_tools, "nodecolor2", text="")
                
        col5 = pie.column(align=True)
        color5_item = col5.operator("node.set_color_1", text="Color 5")
        color5_item.color = context.scene.node_color_tools.nodecolor5
        col5.prop(context.scene.node_color_tools, "nodecolor5", text="")
                
        col8 = pie.column(align=True)
        col8.operator("node.set_color_remove", text="Remove Color")
        


class NODE_MT_color_tools_pie_2(bpy.types.Menu):
    bl_label = "Quick Colors"
    bl_idname = "NODE_MT_color_tools_pie_2"

    def draw(self, context):
        layout = self.layout

        # Define the pie menu layout
        pie = layout.menu_pie()
        
        # Define hardcoded colors
        color1 = (0.8, 0.3, 0.25)
        color2 = (0.3, 0.6, 0.25)  
        color3 = (0.0, 0.5, 0.9) 
        color4 = (0.7, 0.6, 0.2) 
        color5 = (0.4, 0.3, 0.8) 
        
        # Get Blender Version
        version = bpy.app.version
        if version >= (4,4,0):
        
            icon03 = 'STRIP_COLOR_05'
            icon04 = 'STRIP_COLOR_03'
            icon01 = 'STRIP_COLOR_01'
            icon02 = 'STRIP_COLOR_04'
            icon05 = 'STRIP_COLOR_06'
        
        else:
            icon03 = 'SEQUENCE_COLOR_05'
            icon04 = 'SEQUENCE_COLOR_03'
            icon01 = 'SEQUENCE_COLOR_01'
            icon02 = 'SEQUENCE_COLOR_04'
            icon05 = 'SEQUENCE_COLOR_06' 
            
        # Pie menue Butto
        color3_item = pie.operator("node.set_hardcoded_color_1", text="Color 3", icon=icon03)
        color3_item.color = color3
       
        color4_item = pie.operator("node.set_hardcoded_color_1", text="Color 4", icon=icon04)
        color4_item.color = color4
        
        pie.operator("node.set_color_copyfromactive", text="Copy from Active")
        
        pie.operator("node.set_color_random", text="Random")
        
        color1_item = pie.operator("node.set_hardcoded_color_1", text="Color 1", icon=icon01)
        color1_item.color = color1
        
        color2_item = pie.operator("node.set_hardcoded_color_1", text="Color 2", icon=icon02)
        color2_item.color = color2
        
        color5_item = pie.operator("node.set_hardcoded_color_1", text="Color 5", icon=icon05)        
        color5_item.color = color5
        
        pie.operator("node.set_color_remove", text="Remove Color")        
        

def update_keymap(self, context):
    unregister_keymap()  # Unregister old keymaps
    register_keymap()    # Register new keymaps
    

addon_keymaps = []

# Operator to capture key press für Pie Menu 1
class NODECOLOR_OT_capture_key(bpy.types.Operator):
    bl_idname = "nodecolor.capture_key"
    bl_label = "Press any key to set as shortcut"
    bl_description = "Press any key to assign as a shortcut"
    #bl_options = {'REGISTER', 'UNDO'}

    def modal(self, context, event):
        prefs = context.preferences.addons[__package__].preferences
        
        if event.type == 'ESC':  # Cancel if ESC is pressed
            prefs.capturing_key = False
            context.area.tag_redraw()
            return {'CANCELLED'}
        
        if event.value == 'PRESS':

#            # Detect modifier keys separately
#            prefs.ctrl = event.ctrl
#            prefs.alt = event.alt
#            prefs.shift = event.shift
            
            # Store the main key
            prefs.pie_menu_hotkey = event.type
            prefs.capturing_key = False
            context.area.tag_redraw()
            return {'FINISHED'}
        
        return {'RUNNING_MODAL'}

    def invoke(self, context, event):
        prefs = context.preferences.addons[__package__].preferences
        prefs.capturing_key = True
        context.window_manager.modal_handler_add(self)
        context.area.tag_redraw()
        return {'RUNNING_MODAL'}


# Operator to capture key press for Pie Menu 2
class NODECOLOR_OT_capture_key_2(bpy.types.Operator):
    bl_idname = "nodecolor.capture_key_2"
    bl_label = "Press any key to set as shortcut"
    bl_description = "Press any key to assign as a shortcut"
    #bl_options = {'REGISTER', 'UNDO'}

    def modal(self, context, event):
        prefs = context.preferences.addons[__package__].preferences
        
        if event.type == 'ESC':  # Cancel if ESC is pressed
            prefs.capturing_key_2 = False
            context.area.tag_redraw()
            return {'CANCELLED'}
        
        if event.value == 'PRESS':

#            # Detect modifier keys separately
#            prefs.ctrl_2 = event.ctrl
#            prefs.alt_2 = event.alt
#            prefs.shift_2 = event.shift
            
            # Store the main key
            prefs.pie_menu_hotkey_2 = event.type
            prefs.capturing_key_2 = False
            context.area.tag_redraw()
            return {'FINISHED'}
        
        return {'RUNNING_MODAL'}

    def invoke(self, context, event):
        prefs = context.preferences.addons[__package__].preferences
        prefs.capturing_key_2 = True
        context.window_manager.modal_handler_add(self)
        context.area.tag_redraw()
        
        return {'RUNNING_MODAL'}

    
    
#class SimpleAddonPreferences(bpy.types.AddonPreferences):
class NodeColorPreferences(bpy.types.AddonPreferences):
    bl_idname = __package__

    # Key selection property PIe Menu 1
    pie_menu_hotkey: bpy.props.StringProperty(
        name="Pie Menu Hotkey",
        description="Press the button to assign a key for the pie menu",
        
        default='Z',
        update=update_keymap
    )
    
    capturing_key: bpy.props.BoolProperty(
        name="Capturing Key",
        default=False
    )
    
    ctrl: bpy.props.BoolProperty(name="Ctrl", default=False, update=update_keymap)
    alt: bpy.props.BoolProperty(name="Alt", default=False, update=update_keymap)
    shift: bpy.props.BoolProperty(name="Shift", default=False, update=update_keymap)
    
    
    # Key selection property PIe Menu 2
    pie_menu_hotkey_2: bpy.props.StringProperty(
        name="Pie Menu Hotkey 2",
        description="Press the button to assign a key for the pie menu",
        
        default='D',
        update=update_keymap
    )
    
    capturing_key_2: bpy.props.BoolProperty(
        name="Capturing Key 2",
        default=False
    )
    
    ctrl_2: bpy.props.BoolProperty(name="Ctrl", default=False, update=update_keymap)
    alt_2: bpy.props.BoolProperty(name="Alt", default=False, update=update_keymap)
    shift_2: bpy.props.BoolProperty(name="Shift", default=False, update=update_keymap)
    
    def draw(self, context):
        layout = self.layout
        prefs = context.preferences.addons[__package__].preferences
        
        # check Blender Version
        version = bpy.app.version
        if version >= (4,4,0):
            icon01 = "STRIP_COLOR_09"
            icon02 = "STRIP_COLOR_05"
        else:
            icon01 = "SEQUENCE_COLOR_09"
            icon02 = "SEQUENCE_COLOR_05"
        
        if prefs.capturing_key:
            button_label = "Press any key to assign..."
            button_icon = bpy.utils.icon_id=icon01
        else:
            #button_label = f"Set Shortcut ({prefs.pie_menu_hotkey})"
            button_label = prefs.pie_menu_hotkey
            button_icon = bpy.utils.icon_id=icon02
        
        if prefs.capturing_key_2:
            button_label_2 = "Press any key to assign..."
            button_icon_2 = bpy.utils.icon_id=icon01
        else:
            #button_label_2 = f"Set Shortcut ({prefs.pie_menu_hotkey_2})"
            button_label_2 = prefs.pie_menu_hotkey_2
            button_icon_2 = bpy.utils.icon_id=icon02
        
        row = layout.row()
        
        row.label(text="Assign Hotkeys")
        
        box2 = row.box()
        box2.label(text = "Quick Color Pie Menu")
        row3 = box2.row(align = True)
        col2 = row3.column(align = True)
        col3 = row3.column(align = True)
        col3.scale_y = 3.0
        col3.operator("nodecolor.capture_key_2", text=button_label_2, icon=button_icon_2)
        col2.prop(self, "ctrl_2", text="Ctrl")
        col2.prop(self, "alt_2", text="Alt")
        col2.prop(self, "shift_2", text="Shift")


        box = row.box()
        box.label(text = "Precise Color Pie Menu")
        row2 = box.row(align = True)
        col = row2.column(align = True)
        col4 = row2.column(align = True)
        col.prop(self, "ctrl", text="Ctrl")
        col.prop(self, "alt", text="Alt")
        col.prop(self, "shift", text="Shift")
        col4.scale_y = 3.0
        col4.operator("nodecolor.capture_key", text=button_label, icon=button_icon)
        
        

        
#        row = layout.row()
#        row.prop(self, "pie_menu_hotkey", text="Pie Menu Key")
#        row.operator("nodecolor.capture_key", text=shortcut_label)


# Basic operator for pie menu 1
class SIMPLE_OT_call_node_color_pie(bpy.types.Operator):
    bl_idname = "wm.call_node_color_pie"
    bl_label = "Node Color Tools"

    def execute(self, context):
        bpy.ops.wm.call_menu_pie(name="NODE_MT_color_tools_pie")
        return {'FINISHED'}
    
    
# Basic operator for pie menu 2
class SIMPLE_OT_call_node_color_pie_2(bpy.types.Operator):
    bl_idname = "wm.call_node_color_pie_2"
    bl_label = "Node Color Tools Quick"

    def execute(self, context):
        bpy.ops.wm.call_menu_pie(name="NODE_MT_color_tools_pie_2")
        return {'FINISHED'}




def register_keymap():
    prefs = bpy.context.preferences.addons[__package__].preferences
    
    key = prefs.pie_menu_hotkey.upper()
    key_2 = prefs.pie_menu_hotkey_2.upper()
    
    wm = bpy.context.window_manager
    km = wm.keyconfigs.addon.keymaps.new(name="Node Editor", space_type='NODE_EDITOR')
    
    kmi = km.keymap_items.new(
        "wm.call_node_color_pie",
         type=key, 
         value="PRESS",
         ctrl=prefs.ctrl,
         shift=prefs.shift,
         alt=prefs.alt, 
    )
    
    kmi_2 = km.keymap_items.new(
        "wm.call_node_color_pie_2",
         type=key_2, 
         value="PRESS",
         ctrl=prefs.ctrl_2,
         shift=prefs.shift_2,
         alt=prefs.alt_2, 
    )
    
    
    
    addon_keymaps.append((km, kmi))
    addon_keymaps.append((km, kmi_2))

def unregister_keymap():
    for km, kmi in addon_keymaps:
        km.keymap_items.remove(kmi)
    addon_keymaps.clear()
    



# Register properties for each color picker
def register():
    bpy.utils.register_class(NodeColorTools)
    bpy.utils.register_class(NODE_PT_color_tools_panel)
    bpy.utils.register_class(NODE_OT_set_color_1)
    bpy.utils.register_class(NODE_OT_set_color_remove)
    bpy.utils.register_class(NODE_OT_set_color_copyFromActive)
    bpy.utils.register_class(NODE_OT_set_color_random)
    bpy.utils.register_class(NODE_MT_color_tools_pie)
    bpy.utils.register_class(NODE_MT_color_tools_pie_2)
    bpy.utils.register_class(NODE_OT_set_hardcoded_color_1)
    bpy.utils.register_class(NodeColorPreferences)
    bpy.utils.register_class(SIMPLE_OT_call_node_color_pie)
    bpy.utils.register_class(SIMPLE_OT_call_node_color_pie_2)
    bpy.utils.register_class(NODECOLOR_OT_capture_key)
    bpy.utils.register_class(NODECOLOR_OT_capture_key_2)
    
    register_keymap()  # Register the keymaps
    
    # Add custom properties for color pickers in the Scene
    
    bpy.types.Scene.node_color_tools = bpy.props.PointerProperty(type=NodeColorTools)

#    # Add keymap for pie menus
#    wm = bpy.context.window_manager
#    km = wm.keyconfigs.addon.keymaps.new(name="Node Editor", space_type='NODE_EDITOR')
#    
#    kmi = km.keymap_items.new("wm.call_menu_pie", 'Z', 'RELEASE', ctrl=True)  # Change 'P' and ctrl as desired
#    kmi.properties.name = "NODE_MT_color_tools_pie"  # The ID of your pie menu

#    kmi2 = km.keymap_items.new("wm.call_menu_pie", 'Z', 'PRESS', ctrl=False)  # Change 'P' and ctrl as desired
#    kmi2.properties.name = "NODE_MT_color_tools_pie_2"  # The ID of your pie menu


def unregister():
    bpy.utils.unregister_class(NODE_PT_color_tools_panel)
    bpy.utils.unregister_class(NODE_OT_set_color_1)
    bpy.utils.unregister_class(NODE_OT_set_color_remove)
    bpy.utils.unregister_class(NODE_OT_set_color_copyFromActive)
    bpy.utils.unregister_class(NODE_OT_set_color_random)
    bpy.utils.unregister_class(NODE_MT_color_tools_pie)
    bpy.utils.unregister_class(NODE_MT_color_tools_pie_2)
    bpy.utils.unregister_class(NODE_OT_set_hardcoded_color_1)
    bpy.utils.unregister_class(NodeColorPreferences)
    bpy.utils.unregister_class(SIMPLE_OT_call_node_color_pie)
    bpy.utils.unregister_class(SIMPLE_OT_call_node_color_pie_2)
    bpy.utils.unregister_class(NODECOLOR_OT_capture_key)    
    bpy.utils.unregister_class(NODECOLOR_OT_capture_key_2)    
    bpy.utils.unregister_class(NodeColorTools)    
    
    unregister_keymap()
    


    
    # Remove custom properties from Scene
    del bpy.types.Scene.node_color_tools



#    wm = bpy.context.window_manager
#    km = wm.keyconfigs.addon.keymaps.get("Node Editor")
#    if km:
#        for kmi in km.keymap_items:
#            if kmi.idname == "wm.call_menu_pie" and kmi.properties.name == "NODE_MT_color_tools_pie":
#                km.keymap_items.remove(kmi)



#    wm = bpy.context.window_manager
#    kc = wm.keyconfigs.active
#    
#    # Create a new keymap for the Node Editor space
#    km = kc.keymaps.new(name="Node Editor", space_type='NODE_EDITOR')
#    # Access preferences to get user-defined hotkeys
#    prefs = bpy.context.preferences.addons[__name__].preferences
#    # Keymap for the first pie menu
#    kmi1 = km.keymap_items.new("wm.call_menu_pie", prefs.pie_menu_hotkey_1, 'PRESS', shift=False)
#    kmi1.properties.name = "NODE_MT_color_pie"  # First pie menu
#    # Keymap for the second pie menu
#    kmi2 = km.keymap_items.new("wm.call_menu_pie", prefs.pie_menu_hotkey_2, 'PRESS', shift=True)
#    kmi2.properties.name = "NODE_MT_second_color_pie"  # Second pie menu
    

# Run the script in Blender’s Text Editor
if __name__ == "__main__":
    register()



    
    