3Dsurface-reconstruction
========================
##Introduction
This code has been written in Matlab for reconstruct 3D underwater surfaces. This is a part of the work generated in the PhD "Numerical and experimental study of the hydrodynamic efficiency of a tidal energy extraction system and its effect on the re-suspension of sea bed sediments" and can be downloaded [here](http://hdl.handle.net/10630/8265#sthash.rc0JW7X9.dpuf). I encourage to read the third chapter because it is explained the methodology and this software.

##Basic information
There are four different folders and a file to initialize the software in the project folder where the code will be set. The required folders are the "scripts" (where all the codes are), the "cases" (where there are all the files with the images to digitize), the "patterns" (where there are four files: pattern1, pattern2, patternZ and patternXY) and the "results" (with all the images generated by the software).
 
All the codes are written in the script folder and initialize.m is the main file to run the software. A menu is showed and then you can choose what action you prefer. Furthermore, you could execute all the basic scripts sorted in the right steps, running initialize.m and then typing in the Matlab console "AllSteps". 

##For a quick test
In order to see an example used in the PhD to validate the code is possible to follow the next steps:

git clone https://github.com/danielcebrian/3Dsurface-reconstruction

cd 3Dsurface-reconstruction

Now, open Matlab and move to the software root path. Type in Matlab: initialize. Then you will see a menu with the options of the software and execute the result that you want to see. If you want to experiment all the steps by yourself, you could remove all the .mat files found inside the folders, they have the saved information to reconstruct a seashell.
