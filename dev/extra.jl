function scalebar!(img::AbstractArray, scale::Real, bar_length::Real;
    position::Tuple{Symbol,Symbol}=(:right,:bottom),
    padding::Integer=10,
    color::Colorant=RGB(1,1,1),
    thickness::Integer=5,
    text_size::Real=20,
    text_color::Colorant=RGB(1,1,1))

# Get the size of the image
height, width = size(img)

# Calculate the position of the scalebar based on the position argument
x, y = position == (:right, :bottom) ? (width - bar_length - padding, height - thickness - padding) :
position == (:left, :bottom) ? (padding, height - thickness - padding) :
position == (:right, :top) ? (width - bar_length - padding, padding) :
(padding, padding)  # default to (:left, :top)

# Draw the scalebar
for i in 1:thickness
for j in 1:bar_length
img[Int(round(y + i)), Int(round(x + j))] = color
end
end

# Draw the text
#text!(img, "$scale", (x, y - text_size - padding), color=text_color, fontsize=text_size)  
end

# To use the function, you can call it like this:

# Create a black image
img = zeros(RGB, 500, 500)

# Define the scale and bar length
scale = 0.1 # um
bar_length = 200

# Define the position, padding, color, thickness, text size, and text color
position = (:right, :bottom)
padding = 10
color = RGB(1, 1, 1)
thickness = 5
text_size = 20
text_color = RGB(1, 1, 1)

# Add the scale bar to the image
scalebar!(img, scale, bar_length, position=position, padding=padding, color=color, thickness=thickness, text_size=text_size, text_color=text_color)

# Display the image
display(img)