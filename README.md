# ELIBeamlines
 ELI-Beamlines Internship Porject July-Sept 2024
Welcome to the ELI Beamlines App. I will speak on some important things to aid in navigating the app.

1. Firstly, there is a order in which the images should be uploaded, processed, and analysed. This is:
   1. Upload images
   2. Fill out 'threshold' input. Then go Threshold > Create Mask
   3. Process Image > Fill Holes and then Process Image > Watershed
   4. Analyse Particles. The area limits, scale, and circularity must be filled out before Analyse Particles can be clicked
   5. Graphs > Histogram can be immediately produced
   6.  The remainins inputs (Diameter limits, # of shots, Distance from Source, CR-39 Area, Y0, A1, T1, A2, T2) must be filled out. 
       then Graphs > Energy Distribution can be clicked.

2. An important comment to make about the analysis. If at one point during the process an input wishes to be changed (for example the area limits) but the analysis (i.e Analyse Particles or Energy Distribution) has already been carried out, the app needs to be closed down and rebooted- with the images uploaded agian. Similarly, if analysis has been done on a set of images and new images are uploaded, the app should be closed and opened again. This is due to the app storing data from the analysis which cannot be override but is rather added to the old data.
3. **Area limits vs Diameter limits** The area limits are used to determine the limits for 'Analyse Particles'. These can be set at a small range to immediatley try isolate a specific particle, or can be set very large (say 0-100)  in order to detect every potential particle. The diameter limits are used later, when specifying the limitations for the energy distribution analysis and graph. These limits should be more refined- to find the energy distribution of the required particle.
4. **Comments on the inputs**
   1. Threshold: Should be a value between 0 and 255. This should be tweaked to best fit each individual set of images.
   2. Circularity: Can be any value between 0 and 1. Determines how close to a circle the detected particles should be, with a value 
      of 1 being a perfect circle.
   3. Distance from source: Should be inputted in meters.
   4. CR-39 Area: The CR-39 area is defined as the total area of the image in meters. This can be found by determining the height and 
      width of the image in pixles. Calculating this area, and then using the scale to get the area in meters. Then, this area needs 
      to be multiplied by the number of images uploaded. Only after this final number is found can it be inputted into the app.
       
5. **Tables** When the energy distribution graph is created, the app will ask the user to save the data as a csv file. The data included in here are the areas of each particle found in the initial analysis, along with the corresponding diameters and a count of the number of particles that had this area. The energy and energy different calculations are included here as well. Then, the remaining columns of the table correspond to the new diameter limits included. Therefore, these columns are shorted and have 'NaN' filling the rest of the rows if they are empty. The final two colums, 'dN_dE' and 'dN_dE_sr_s' are the x and y values of the energy distribution. The 'Counts' and 'Areas' columns are the y and x values for the histogram. The total number of particles detected is equal to the sum of the 'Counts' column.
   1. **If the table heading wish to be changed** they can be altered by going to the function EnergyDistributionMenuSelected(app, 
      event) in the code, and the 'Variable Names' should be changed (making sure they are called in the same order as the data is 
      called).
   2. **Uploading CSV files** the user can upload csv files themselves and use these to generate histograms, energy distributions, 
      and mean/min/max energy distributions. The csv files can be the same files saved from the app, or alternatively, the user can 
      upload any csv file as long as it follows the same template as the saved files. The csv files needs to be a table where the 
      column headers are called the exact same names (Counts, Areas, dN_dE and dN_dE_sr_s), unless the table headers are changed by 
      the user within the code itself.
6. **Analyse Particles Images** The images that pop up during anlayse particles are figuring which highlight and label the particles found. These can be saved, zoomed in on/ inspected. These figures are captured as screenshots and uploaded to the app for easier viewing. However, if these figures are to be saved- it is better to save them from the pop-ups as the screenshots do not have good resolution.
7. **Graphs** There are 5 graphs that can be produced. 'Histogram' and 'Energy Distribution' can only be created after images have been uploaded and analysed. However, the remaining three graphs are created from csv files. These can be either one csv files or multiple for the Histogram and Energy Distribution, however, for the Energy Distribution Mean this graph requires at least two csv files. This graph will also ask the user if they would like to save the mean, maximum, and minimum values as a new csv file. The graphs can be saved as figures or png images. Also, the title and axes titles can be easily edited by double clicking them.

Hope this is clear and that the app is helpful!!  
