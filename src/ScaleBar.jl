"""
    ScaleBar

A Julia package for adding scale bars to images, particularly useful for scientific and microscopy applications.

## Features

- **Physical Scale Bars**: Add scale bars with proper physical dimensions (μm, nm, etc.)
- **Pixel-based Scale Bars**: Add scale bars with exact pixel dimensions
- **Flexible Positioning**: Place scale bars at any corner using CairoMakie-style position symbols
- **Smart Defaults**: Automatically calculates sensible scale bar dimensions based on image size
- **In-place and Non-destructive**: Choose between modifying images or creating new copies

# API Overview
For a comprehensive overview of the API, use the help mode on `api_overview`:

    ?ScaleBar.api_overview

Or access the complete API documentation programmatically:

    docs = ScaleBar.api_overview()
"""
module ScaleBar

using Colors
using Images

include("core.jl")
include("interface.jl")

# Export the public API functions and types
export scalebar, scalebar!, ScaleBarConfig

# Include the API overview functionality
include("api.jl")

end
