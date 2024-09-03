# ELIBeamlines
 ELI-Beamlines Internship Porject July-Sept 2024
Welcome to the ELI Beamlines App. In this README is some important information to aid in navigating the app.

1. Firstly, there is a order in which the images should be uploaded, processed, and analysed. This is:
   1. Upload images
   2. Fill out 'threshold' input. Then go Threshold > Create Mask
   3. Process Image > Fill Holes
   4. Process Image > Watershed
   5. Analyse Particles. The area limits, scale, and circularity must be filled out before Analyse Particles can be 
      clicked
   6. Graphs > Histogram 
   7. Graphs > Energy Distribution - The remainins inputs (Diameter limits, # of shots, Distance from Source, CR-39 
      Area, Y0, A1, T1, A2, T2) must be filled out first

2. **Important Comment**:
   1. If analysis is done on a set of images and new images want to be analysed, simply click 'upload' again and 
      upload a new set of images. The analysis should then be carried out the same as in the steps above.
   2. The 'Create Mask' can be clicked repeatedly with different threshold inputs to determine the desired 
      thresholding. Each time the threhsold is updated, the 'Fill Holes' > 'Watershed' analysis should then be 
      carried out.
   3. If the photo has already been watershedded and 'Analyse Particles' has been carried out but the user wishes to 
      change some inputs (for example circularity or area limits) these inputs can be changed and the 'Analysed 
      Particles' can be clicked again. The resulting histogram will always match the most recent particle analysis.
   4. Finally, if the entire analysis including the 'Energy Distribution' graph has been done but the user wants to 
      change the inputs for the 'Energy Distribution' graph, the user should change the inputs and can create a new 
      Energy Distribution graph that matches the new inputs. However, if the user wishes to change previous inputs 
      such as the circularity or area limits, they need to re-click 'Analyse Particles' and ''Histogram' with the 
      desired changes.  
3. **Area limits vs Diameter limits** The area limits are used to determine the limits for 'Analyse Particles'. These can be set at a small range to immediatley try isolate a specific particle, or can be set very large (say 0-100)  in order to detect every potential particle. The diameter limits are used later, when specifying the limitations for the energy distribution analysis and graph. These limits should be more refined to find the energy distribution of the desired particle.
4. **Comments on the inputs**
   1. Threshold: Should be a value between 0 and 255. This should be tweaked to best fit each individual set of 
      images.
   2. Circularity: Can be any value between 0 and 1. Determines how close to a circle the detected particles should 
      be, with a value of 1 being a perfect circle.
   3. Distance from source: Should be inputted in meters.
   4. CR-39 Area: The CR-39 area is defined as the total area of the image in meters. This can be found by 
      determining the height and width of the image in pixles. Calculating this area, and then using the scale to get 
      the area in meters. Then, this area needs to be multiplied by the number of images uploaded. Only after this 
      final number is found can it be inputted into the app.
       
5. **Tables** When the energy distribution graph is created, the app will ask the user to save the data as a csv file. The data included in here are the areas of each particle found in the initial analysis, along with the corresponding diameters and a count of the number of particles that had this area. The energy and energy difference calculations are included here as well. Then, the remaining columns of the table correspond to the new limits imposed by the diameter limits. Therefore, these columns are shorted and have 'NaN' filling the rest of the rows if they are empty. The final two colums, 'dN_dE' and 'dN_dE_sr_s' are the x and y values of the energy distribution. The 'Areas' and 'Counts' columns are the x and y values for the histogram. The total number of particles detected is equal to the sum of the 'Counts' column.
   1. **If the table heading wish to be changed** they can be altered by going to the function 
      EnergyDistributionMenuSelected(app, event) in the code, and the 'Variable Names' should be changed (making sure 
      they are called in the same order as the data is called).
   2. **Uploading CSV files** the user can upload csv files themselves and use these to generate histograms, energy 
      distributions, and mean/min/max energy distributions. The csv files can be the same files saved from the app, 
      or alternatively, the user can upload any csv file as long as it follows the same template as the saved files. 
      The csv files needs to be a table where the column headers are called the exact same names (Counts, Areas, 
      dN_dE and dN_dE_sr_s) as in the code, unless the table headers are changed by the user within the code itself.
6. **Analyse Particles Images** The images that pop up during anlayse particles are figures which highlight and label the particles found. These can be saved, zoomed in on/ inspected. These figures are captured as screenshots and uploaded to the app for easier viewing. However, if these figures are to be saved it is better to save them from the pop-ups as the screenshots do not have good resolution.
7. **Graphs** There are 5 graphs that can be produced. 'Histogram' and 'Energy Distribution' can only be created after images have been uploaded and analysed. However, the remaining three graphs are created from csv files. These can be either one csv files or multiple for the Histogram and Energy Distribution, however, for the Energy Distribution Mean this graph requires at least two csv files. This graph will also ask the user if they would like to save the mean, maximum, and minimum values as a new csv file. The graphs can be saved as figures or png images. Also, the title and axes titles can be easily edited by double clicking them.

Hope this is clear and that the app is helpful!!  
