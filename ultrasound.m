function[I] = ultrasound(result)

for i = 1:150
    I = imread('image#d.png', i);
    [~, threshold] = edge(I, 'sobel');
    fudgeFactor = 0.9;
    Iedge = edge(I, 'sobel', threshold*fudgeFactor);
    
    if % determines if normal
        result = fprintf('normal');
    else
        se90 = strel('line',3,90); 
        se0 = strel('line',3,0);
        Idilate = imdilate(Iedge,[se90 se0]);

        Ifill= imfill(Idilate,'holes');

        Iborder = imclearborder(Ifill,5);

        seD = strel('diamond',1);
        Ifinal=imerode(Iborder,seD);
        Ifinal=imerode(Ifinal,seD);

        area = labeloverlay(I,Ifinal);
        [x, y] = centroid(polyshape(area));
        th = 0:pi/50:2*pi;
        xunit = r * cos(th) + x;
        yunit = r * sin(th) + y;
        h = plot(xunit, yunit);
        circle_area = area(h);
        median_value = median(circle_area);

        if median_value % between 2 values for malignant
            result = fprintf('malignant');
        elseif median_value % between 2 values for benign
            result = fprintf('benign');
        end
    end
end