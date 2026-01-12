# rgb_to_dng.py

import numpy as np
from pidng.core import RAW2DNG, DNGTags, Tag
from pidng.defs import *

def rgb_to_bayer(rgb: np.ndarray) -> np.ndarray:
    """
    Convert an RGB image to a single-channel Bayer array.

    pattern: one of {"RGGB", "BGGR", "GRBG", "GBRG"}
    """
    h, w, _ = rgb.shape
    bayer = np.zeros((h, w), dtype=rgb.dtype)

    # RGGB pattern:
    # R G
    # G B
    bayer[0::2, 0::2] = rgb[0::2, 0::2, 0]  # R
    bayer[0::2, 1::2] = rgb[0::2, 1::2, 1]  # G
    bayer[1::2, 0::2] = rgb[1::2, 0::2, 1]  # G
    bayer[1::2, 1::2] = rgb[1::2, 1::2, 2]  # B


    return bayer


def save_as_dng(image_data: np.ndarray, output_path: str, bits_per_sample: int = 16, focal: float = 50.0, fstop: float = 2.8):
    """
    Convert an RGB numpy array to a Bayer DNG.
    """
    height, width = image_data.shape[:2]
    white_level = 2 ** bits_per_sample - 1
    black_level = 0
#    ccm1 = [[1660300, 1000000], [-587570, 1000000], [-72890, 1000000],
# [-124380, 1000000], [1132830, 1000000], [-8360, 1000000],
# [-18110, 1000000], [-100580, 1000000], [1118770, 1000000]]

    # Convert RGB → Bayer mosaic
    bayer = np.flipud(image_data)
    bayer = rgb_to_bayer(bayer)

    # Ensure uint16 format
    bayer = (np.clip(bayer, 0, 1) * white_level).astype(np.uint16)

    # --- DNG metadata ---
    tags = DNGTags()
    tags.set(Tag.ImageWidth, width)
    tags.set(Tag.ImageLength, height)
    tags.set(Tag.TileWidth, width)
    tags.set(Tag.TileLength, height)
    tags.set(Tag.FocalLength, [[int(focal * 100), 100]])
    tags.set(Tag.FNumber, [[int(fstop * 100), 100]])
    tags.set(Tag.PhotographicSensitivity, 100)
    tags.set(Tag.Orientation, Orientation.Horizontal)
    tags.set(Tag.PhotometricInterpretation, PhotometricInterpretation.Color_Filter_Array)
    tags.set(Tag.SamplesPerPixel, 1)
    tags.set(Tag.BitsPerSample, bits_per_sample)
    tags.set(Tag.CFARepeatPatternDim, [2, 2])
    tags.set(Tag.CFAPattern, CFAPattern.RGGB)
    tags.set(Tag.BlackLevel, black_level)
    tags.set(Tag.WhiteLevel, white_level)
    #tags.set(Tag.ColorMatrix1, ccm1)
    tags.set(Tag.CalibrationIlluminant1, CalibrationIlluminant.D65)
    tags.set(Tag.AsShotNeutral, [[1, 1], [1, 1], [1, 1]])
    tags.set(Tag.BaselineExposure, [[1, 1]])
    tags.set(Tag.Make, "Blender")
    tags.set(Tag.Model, "Bayer Render")
    tags.set(Tag.DNGVersion, DNGVersion.V1_4)
    tags.set(Tag.DNGBackwardVersion, DNGVersion.V1_2)
    tags.set(Tag.PreviewColorSpace, PreviewColorSpace.sRGB)

    # --- Write DNG ---
    converter = RAW2DNG()
    converter.options(tags, path="", compress=False)
    converter.convert(bayer, output_path)

    print(f"[Export DNG] Saved Bayer-pattern DNG to {output_path}")
