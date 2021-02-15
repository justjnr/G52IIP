% Load original images
imA = imread('plant001_rgb.png');
imB = imread('plant017_rgb.png');
imC = imread('plant223_rgb.png');

% Plot the original images
subplot(4,3,1),
imshow(imA),
subplot(4,3,2),
imshow(imB),
subplot(4,3,3),
imshow(imC);

% Main function calls
processPlant(imA, 4);
processPlant(imB, 5);
processPlant(imC, 6);

% Main function takes in two parameters (image, subplot index)
function processPlant(im, index)
    %grayIm = rgb2gray(im); % Convert image to grayscale colour space
    %hueC = hsvIm(:,:,1); % Filter out Hue channel only
    greenIm = im(:,:,2); % Filter out Green channel only
    greenIm = greenIm * 2; % Adjust contrast of image by multiplying by a constant factor
    
    greenIm = medfilt2(greenIm); % Median Filter noise removal
    binThresh = graythresh(greenIm); % Use Otsu thresholding method on the image to find ideal threshold
    binIm = imbinarize(greenIm, binThresh); % Binarise image by threshold

    %filtBin = bwareaopen(binIm, 1500); % Removes all connected objects smaller than N pixels
    binImOut = bwareafilt(binIm, 3); % Choose largest N objects
    binImOut = bwpropfilt(binImOut, 'Eccentricity', 1, "smallest"); % Filter out objects in binary image with non circular like properties

    mIm = bsxfun(@times, im, cast(binImOut, "like", im)); % Mask original RGB image with binary image - NOT REQUIRED
    
    % Output binary images to file - NOT REQUIRED
        %filename = sprintf('out_%d.png', index);
        %imwrite(binImOut, filename);

    % Plot the images
    subplot(4, 3, index),
    imshow(greenIm),
    subplot(4, 3, index + 3),
    imshow(binIm),
    subplot(4, 3, index + 6),
    imshow(binImOut);
end