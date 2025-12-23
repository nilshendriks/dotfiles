# SPDX-FileCopyrightText: 2016-2024 Blender Foundation
#
# SPDX-License-Identifier: GPL-3.0-or-later

from .bs_utils.hotkeys import register_hotkey

def register():
    register_hotkey(
        'screen.area_join',
        hotkey_kwargs={'type': "ACCENT_GRAVE", 'value': "PRESS", 'alt': True},
        keymap_name="Window",
    )
