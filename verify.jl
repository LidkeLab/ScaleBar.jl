println("Testing core functionality...")

# Define variables for testing
height, width = 200, 300
length_px, width_px = 50, 10
padding = 10

# Test positioning logic
println("Position tests:")
for position in [:br, :bl, :tr, :tl]
    if position == :br
        # Bottom right
        row_start = height - padding - width_px + 1
        row_end = height - padding
        col_start = width - padding - length_px + 1
        col_end = width - padding
    elseif position == :bl
        # Bottom left
        row_start = height - padding - width_px + 1
        row_end = height - padding
        col_start = padding
        col_end = padding + length_px - 1
    elseif position == :tr
        # Top right
        row_start = padding
        row_end = padding + width_px - 1
        col_start = width - padding - length_px + 1
        col_end = width - padding
    elseif position == :tl
        # Top left
        row_start = padding
        row_end = padding + width_px - 1
        col_start = padding
        col_end = padding + length_px - 1
    end
    
    println("Position $position: ($row_start, $row_end, $col_start, $col_end)")
end

println("All tests complete")
