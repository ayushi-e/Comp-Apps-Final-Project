%Final Project

%read image
file = input('Enter image name: '); 
image = imread(file);

%convert to grayscale & perform median filtering for noise reduction
gray_image = rgb2gray(image);
filtered_image = medfilt2(gray_image, [3 3]);

%Simple thresholding
threshold = 80;
binary_image = filtered_image < threshold;

%Clean up segmentation
se = strel('disk', 3);
binary_image = imclose(binary_image, se);
binary_image = imfill(binary_image, 'holes');

% Extract connected components
cc = bwconncomp(binary_image);
stats = regionprops(cc, 'Area', 'Perimeter', 'PixelIdxList');

% Initialize a mask for the tumor region
tumor_mask = false(size(binary_image));

% Threshold for circularity to identify round/oval-shaped components
circularity_threshold = 0.4; % Adjust as needed

% Initialize variables to store information about the largest tumor
largest_tumor_area = 0;
largest_tumor = 0;

min_tumor_area = 800;

% Iterate over connected components
for i = 1:cc.NumObjects
    % Calculate circularity
    circularity = (4 * pi * stats(i).Area) / (stats(i).Perimeter ^ 2);
    
    % Filter components based on circularity
    if circularity > circularity_threshold
        % Check if the current component has a larger area than the largest tumor found so far
        if stats(i).Area > largest_tumor_area  && stats(i).Area > min_tumor_area
            largest_tumor_area = stats(i).Area;
            largest_tumor = i;
        end
    end
end

% Create a mask for the largest circular-shaped connected component (tumor)
largest_tumor_mask = false(size(binary_image));
if largest_tumor > 0
    largest_tumor_mask(stats(largest_tumor).PixelIdxList) = true;
end

% Overlay the largest circular-shaped tumor region on the original binary image
overlay = imoverlay(image, largest_tumor_mask, [1,0,0]);

%Display message if a tumor is or isn't detected
if  any(largest_tumor_mask(:))
    fprintf('A tumor is detected in the image.\n');
else
    fprintf('No tumor is detected in the image.\n');
end

% Display the largest circular-shaped tumor region
imshow(overlay);
