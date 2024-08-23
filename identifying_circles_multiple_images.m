% Loading folder
folder = "/Users/Nathalie/Desktop/ELI Beamlines/Unknown sample etched at 1h/011/10um"; 
filePattern = fullfile(folder, '*.tif'); 
tifs= dir(filePattern); 

num_images= length(tifs); 
images= cell(1,num_images); 
masks = cell(1, num_images); 
all_blobs = []; 

for k = 1:num_images
    baseFileName = tifs(k).name;
    fullfileName = fullfile(folder, baseFileName);
    I = imread(fullfileName); 
    RGBimage = I(:, :, 1:3); % Extract the first three channels (R, G, B)
    images{k} = RGBimage; %stores image at value I
    figure; 
    imshow(images{k}); 

    %convert to greyscale
    I_8bit= im2gray(RGBimage);
    %figure; 
    %imshow(I_8bit); 

    %threshold the image
    bw = I_8bit < 115; 
    figure; 
    imshow(bw); 

    %watershed 
    bw_filled=imfill(bw,'holes');
    bw_filled_blur = imgaussfilt(double(bw_filled), 1);

    D = -bwdist(~bw_filled_blur);
    W = watershed(D);

    W(~bw_filled) = 0;
    bw_watershed = W==0;
    
    masks{k}=~bw_watershed; 
    %figure; 
    %imshow(masks{k}); 
end 

%defining scale: 
scale= 4.86; 
circularity_threshold = 0.9;

for n=1:numel(masks) 
    % Find boundaries
    [B,L] = bwboundaries(masks{n}, 'noholes',TraceStyle='pixeledge');

    %reigonprops
    stats = regionprops(L,"Circularity", "Centroid", "Area", "Perimeter"); 
    figure; 
    imshow(L);
    hold on
    
    blobs = [];
    for j = 1:length(B)
        boundary=B{j}; 
        circularity = stats(j).Circularity; 
        if circularity > circularity_threshold %circularity limits 
            %scaled area 
            area = stats(j).Area;
            scaled_area= area/scale^2;
            if scaled_area > 1 && scaled_area < 7 %area limits 
                %disp(scaled_area); 
                % Plot boundaries
                plot(boundary(:,2), boundary(:,1), 'cyan', 'LineWidth', 2);
                %get center
                %centroid= stats(k).Centroid; do i actually use this? 
                blobs = [blobs scaled_area];
            end
        end     
    end
    drawnow
    title('perimeters');  
    all_blobs = [all_blobs blobs];
end 

diameters=[]; 
for i= 1:length(all_blobs) 
    diameter = sqrt((all_blobs(i)*4) / pi);
    diameters = [diameters diameter];
end 
%saving diameters
csvwrite('all_blobs_diameters.csv', diameters); 

% save all data 
csvwrite('all_blobs.csv', all_blobs');

%standard deviation ---->dont need for now in other one, just needed for
%calibration 
std_dev = std(all_blobs);
disp(['Standard Deviation: ', num2str(std_dev)]);

%peak ----> this one is to check my calibration/peak histograms data 
%pd = fitdist(all_blobs', 'Normal');
%peak_value = pd.mu; %finding mean (peak) 
%disp(['Peak of Gaussian Distribution: ', num2str(peak_value)]);

% Find unique areas and their counts
[unique_blobs, ~, indices] = unique(all_blobs);
counts = histcounts(indices, length(unique_blobs));

% Plot the histogram with unique bins 
figure;
bar(unique_blobs, counts); % Plot the frequency of each unique area
hold on;

% Add labels and title
title('Number of Particles VS Area (10um)');
xlabel('Area');
ylabel('Number of Particles');


%figure; if you want gaussian curve overlayed (automatic one) 
%histfit(all_blobs, 20, 'normal'); % '20' specifies the number of bins; adjust as needed

% plot histogram --> this is the regular histogram plotting 
%figure;
%histogram(all_blobs, 'BinWidth', 0.0390);
%title('Number of Particles VS Area');
%xlabel('Area');
%ylabel('Frequency');

unique_diameters=[]; 
for i= 1:length(unique_blobs) 
    diameter = sqrt((unique_blobs(i)*4) / pi);
    unique_diameters = [unique_diameters diameter];
end 