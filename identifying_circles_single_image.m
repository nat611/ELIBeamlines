% Loading image
RGB = imread('/Users/Nathalie/Desktop/ELI Beamlines/Unknown sample etched at 1h/011/5um');
%figure;
%imshow(RGB);
%title('RGB');

%convert to greyscale
I_8bit= im2gray(RGB);

%threshold the image
bw = I_8bit < 150; %this one i tried flipping around 
%figure;
%imshow(bw); 
%title('Thresholded'); 
 
%fill holes
bw_filled=imfill(bw,'holes'); 
%figure;
%imshow(~bw_filled); 
%title('Filled Holes'); 

% Find boundaries
[B,L] = bwboundaries(bw_filled, 'noholes',TraceStyle='pixeledge');
%disp(L)

%defining scale: 
scale= 4.86; 
%reigonprops
stats = regionprops(L,"Circularity", "Centroid", "Area", "Perimeter"); 
circularity_threshold = 0.94;

figure; 
imshow(L)
hold on 

blobs = [];
for k = 1:length(B)
    boundary=B{k}; 
    circularity = stats(k).Circularity; 

    if circularity > circularity_threshold 
        disp("Circularity")
        disp(circularity); 
        %scaled area 
        area = stats(k).Area;
        scaled_area= area/scale^2; 
        if scaled_area > 2.5 && scaled_area < 3.2 
            disp('scaled area')
            disp(scaled_area); 
            % Plot boundaries
            plot(boundary(:,2), boundary(:,1), 'cyan', 'LineWidth', 2);
            title('perimeters');  
            %get center
            %centroid= stats(k).Centroid; do i actually use this? 
            blobs = [blobs scaled_area];
        end
    end  
 text(centroid(1), centroid(2), num2str(k), 'Color', 'y', 'FontSize', 12, 'HorizontalAlignment', 'center');
end

%figure; 
%h1 = histogram(blobs); 
%h1.BinWidth = 0.0390; 


%title = {'area'};
%csvwrite('blobs.csv', blobs');

