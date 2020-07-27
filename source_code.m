close all, clear all, clc;

# load data and normalization
red = imread('data/SET001/red.png');
red = double(red) / 255.0;
green = imread('data/SET001/green.png');
green = double(green) / 255.0;
blue = imread('data/SET001/blue.png');
blue = double(blue) / 255.0;
nir = imread('data/SET001/nir.png');
nir = double(nir) / 255.0;
red_edge = imread('data/SET001/red_edge.png');
red_edge = double(red_edge) / 255.0;


# estimate vegetation indexes
#avoid divide for 0 in non information pixels
DEN_NDRE =  (nir + red_edge); DEN_NDRE(DEN_NDRE==0) = 1;

# estimate NDRE index
ndre = (nir - red_edge) ./ DEN_NDRE;

# ndre bias for 0 to 1 values instead mathematical normalization
ndre(ndre < 0) = 0; ndre(ndre > 1) = 1;

# avoid divide for 0 in non information pixels
DEN_NDVI =  (nir + red); DEN_NDRE(DEN_NDVI==0) = 1;

# estimate NDVI index
ndvi = (nir - red) ./ DEN_NDVI;

# ndVI bias for 0 to 1 values instead mathematical normalization
ndvi(ndvi < 0) = 0; ndvi(ndre > 1) = 1;

# clorophyll green index
DEN_GREEN = green; DEN_GREEN(DEN_GREEN == 0) = 1;
cloro_green = (nir ./ DEN_GREEN) - 1;
cloro_green(cloro_green < 0) = 0; cloro_green(cloro_green > 1) = 1;
 
# Clorophyll red_edge index
DEN_CLORO = red_edge; DEN_CLORO(DEN_CLORO ==0 ) = 1;
cloro_red_edge = (nir ./ DEN_CLORO) - 1;
cloro_red_edge(cloro_red_edge < 0) = 0; cloro_red_edge(cloro_red_edge > 1) = 1;

#create rgb image
rgb(:,:,1) = red; rgb(:,:,2) = green; rgb(:,:,3) = blue;
red_rgb (:,:,1) = nir; red_rgb (:,:,2) = green; red_rgb (:,:,3) = blue;

colors(:,:,3) = red;
colors(:,:,2) = green;
colors(:,:,1) = cloro_red_edge;
# visualization
figure, imshow(rgb), title('rgb')
figure, imshow(red_rgb), title('red rgb')
figure, imshow(colors), title('colo colors rgb')
figure, imshow(ndre), title('ndre')
figure, imshow(ndvi), title('ndvi')
figure, imshow(cloro_green), title('cloro green ')
figure, imshow(cloro_red_edge), title('cloro red edge')