%file = input('Enter filename: ');
I = imread('image10.png');
%convert to grayscale
I = rgb2gray(I);

% Apply edge detection using the Sobel operator
[~,threshold] = edge(I, 'sobel');
fudgeFactor = 0.9;
Iedge = edge(I, 'sobel', threshold*fudgeFactor);

% Dilate the edges to connect nearby pixels
se90 = strel('line', 3, 90);
se0 = strel('line', 3, 0);
Idilate = imdilate(Iedge, [se90 se0]);

% Fill holes in the binary image
Ifill = imfill(Idilate, 'holes');

% Remove small objects near the image border
Iborder = imclearborder(Ifill);

% Erode the binary image to refine the boundary
seD = strel('disk', 3);
Ifinal = imerode(Iborder, seD);
Ifinal = imerode(Ifinal, seD);

% Create a boundary around the tumor (if present)
%boundary = bwperim(Ifinal);

% Overlay the boundary on the original image in red (if tumor exists)
%if any(boundary(:))
   segmented_image = imshow(labeloverlay(I, Ifinal));
%else
%    segmented_image = I; % No tumor, display the original image
%end

% Calculate the centroid of the tumor (if present)
%stats = regionprops(Ifinal, 'Centroid');
%if ~isempty(stats)
  %  x = stats.Centroid(1);
  %  y = stats.Centroid(2);
%else
 %   x = NaN; % No tumor, set centroid to NaN
  %  y = NaN;
%end

% Display the results
%figure;
%subplot(1, 2, 1);
%imshow(I);
%title('Original Image');

%subplot(1, 2, 2);
%imshow(segmented_image);
