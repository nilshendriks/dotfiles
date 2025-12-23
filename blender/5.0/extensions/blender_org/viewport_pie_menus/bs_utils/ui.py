# SPDX-FileCopyrightText: 2025 Blender Studio Tools Authors
#
# SPDX-License-Identifier: GPL-3.0-or-later

from bpy.types import UILayout


def aligned_label(layout: UILayout, *, alert=False, alignment="LEFT", **kwargs):
    """Draw some text in the single-column-layout style, ie. offset by 60%."""
    row = layout.split(factor=0.4)
    row.separator()
    row.alert = alert
    row.alignment = alignment
    row.label(**kwargs)


def label_split(layout: UILayout, *, alert=False, **kwargs) -> UILayout:
    """Return an empty UILayout with a text label to its left in the single-column-layout style."""
    split = layout.split(factor=0.4, align=True)
    split.alert = alert
    row = split.row(align=True)
    row.alignment = "RIGHT"
    row.label(**kwargs)
    return split
