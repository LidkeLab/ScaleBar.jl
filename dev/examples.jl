using Revise
using ScaleBar
using Images

# show in place 

img = RGB.(zeros(512, 512))
display(img)
pxsize = 1.0
scalebar!(img, pxsize; position="br", len=50, width=5, scale = 15, color = :white)
display(img)


# show out of place 
img_in = RGB.(zeros(512, 512))
display(img_in)
pxsize = 1.0
img_out = scalebar(img_in, pxsize; position="br", len=50, width=5, scale = 15, color = :white)
display(img_out)

# show out of place 2 
img_in = RGB.(zeros(512, 512))
display(img_in)
pxsize = 1.0
img_out = scalebar(img_in, pxsize; position="tl", len=50, width=5, scale = 15, color = :white)
display(img_out)


# show out of place w defaults 
img_in = RGB.(zeros(512, 512))
display(img_in)
pxsize = 0.5
img_out = scalebar(img_in, pxsize, scale = 50)
display(img_out)







