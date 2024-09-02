% Loading folder
folder = "/Users/Nathalie/Desktop/ELI Beamlines/Pals_2022_decovolution test/321_p5"; %locate folder
filePattern = fullfile(folder, '*.tif'); 
tifs= dir(filePattern); 

num_images= length(tifs); %initialising number of images and empty arrays 
images= cell(1,num_images); 
masks = cell(1, num_images); 
all_blobs = []; 

for k = 1:num_images %looping through files and reading each image 
    baseFileName = tifs(k).name;
    fullfileName = fullfile(folder, baseFileName);
    I = imread(fullfileName); 
    RGBimage = I(:, :, 1:3); % reducing from 4 chanels 
    images{k} = RGBimage; %stores image at I

    %convert to greyscale
    I_8bit= im2gray(RGBimage);

    %threshold the image
    bw = I_8bit < 115; 

    %watershed & fill holes 
    bw_filled=imfill(bw,'holes'); %filling holes 
    bw_filled_blur = imgaussfilt(double(bw_filled), 1); %blurring for watershedding 

    D = -bwdist(~bw_filled_blur); %distance transformation for watershed 
    W = watershed(D); %watershed transformation 

    W(~bw_filled) = 0; %anything that isnt in original fill holes goes to zero (retains area) 
    bw_watershed = W==0;
    
    masks{k}=~bw_watershed; %saving as mask 

end 

%defining scale and circularity 
scale= 4.86; 
circularity_threshold = 0.9;

for n=1:numel(masks) %looping through masks to identify objects 
    % Find boundaries
    [B,L] = bwboundaries(masks{n}, 'noholes',TraceStyle='pixeledge');

    %reigonprops
    stats = regionprops(L,"Circularity", "Centroid", "Area", "Perimeter"); 
    figure; 
    imshow(L);
    hold on

    %looping through each boundary element
    blobs = [];
    for j = 1:length(B)
        boundary=B{j}; 
        circularity = stats(j).Circularity; %setting circularity limit
        if circularity > circularity_threshold 
            %scaled area 
            area = stats(j).Area;
            scaled_area= area/scale^2;
            if scaled_area > 1 && scaled_area < 100 %area limits (from calibration) 
                plot(boundary(:,2), boundary(:,1), 'cyan', 'LineWidth', 2); %plotting boundaries
                blobs = [blobs scaled_area]; %saving boundary data 
                centroid = stats(j).Centroid; 
                text(centroid(1), centroid(2), num2str(j), 'Color', 'r', 'FontSize', 9, 'HorizontalAlignment', 'center');
            end
        end     
    end 
    title('perimeters');  
    all_blobs = [all_blobs blobs]; %saving each individual image data 
end 
% save all data 
%csvwrite('all_blobs.csv', all_blobs');

%calculating diameters
diameters=[]; 
for i= 1:length(all_blobs) 
    diameter = sqrt((all_blobs(i)*4) / pi);
    diameters = [diameters diameter];
end 
%saving diameters
%csvwrite('all_blobs_diameters.csv', diameters); 

% unique areas and their frequency
[unique_blobs, ~, indices] = unique(all_blobs);
counts = histcounts(indices, length(unique_blobs));
%csvwrite('counts.csv', counts');
%csvwrite('unique_blobs.csv', unique_blobs');

%calculating unique diameters 
%unique_diameters=[]; 
%for i= 1:length(unique_blobs) 
    %diameter = sqrt((unique_blobs(i)*4) / pi);
    %unique_diameters = [unique_diameters diameter];
%end
[unique_diameters, ~, indices] = unique(diameters);
%csvwrite('unique_diameters.csv', unique_diameters');

%calculations
%energy calc 
energies_5um= [];
for i =1:length(unique_diameters)
    energy_calc_5um = 586.80959 * exp(-(unique_diameters(i))/0.23051) +...
                      586.80959 * exp(-(unique_diameters(i))/0.28173) + 4.40957;
    energies_5um = [energies_5um energy_calc_5um];
end 
%change in energy
energy_difference = abs(diff(energies_5um)); 
%csvwrite('energy_difference.csv', energy_difference);

%solid angle 
CR_area = ((395.0617*10^-6)*(246.9135*10^-6)); 
distance = 52.5*10^-2;
solid_angle = (CR_area*10)/((distance)^2); 
number_of_shots= 62; 
sr_s= solid_angle*number_of_shots; 

% Apply diameter limits (1.3 to 2.7)
diameter_limits = unique_diameters > 1.32566 & unique_diameters < 2.76630; %check limits! 
filtered_diameters = unique_diameters(diameter_limits);
filtered_counts = counts(diameter_limits);
filtered_energies_5um = energies_5um(diameter_limits);
filtered_energy_diff = energy_difference(diameter_limits(1:end-1));

%dN/dE: 
dN_dE = filtered_counts ./ filtered_energy_diff;
%csvwrite('dN_dE.csv', dN_dE);

%graphs: 
% plot histogram with unique areas 
figure;
bar(unique_blobs, counts); % plot frequency of each unique area
hold on;

% labels and title
title('Number of Particles VS Area (5um)');
xlabel('Area');
ylabel('Number of Particles');

%plotting energies graph 
y_axis = [];
for i =1:length(dN_dE)
    y= dN_dE(i)/sr_s; 
    y_axis = [y_axis, y]; 
end
x_axis= filtered_energies_5um; 

% plot with log y-axis
figure;
semilogy(x_axis, y_axis, 'o'); 

% Add labels and title
xlabel('Energy (MeV)');
ylabel('(dN/dE)/(sr*shot)');
title('Energy Distribution (5um)');
