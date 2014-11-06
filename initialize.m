%all the scripts must be runned in the root folder

%add funtions folder that has the function scripts
pscripts='scripts';
addpath(genpath(pscripts));

checkings={'init'}; 
checks

home;

fprintf('\nThe software has the next actions:\n')

fprintf('\nPatterns:\n')
fprintf('\tpatternZ\t\tCalculate the relaction pixel/mm in the Z component\n')
fprintf('\tpatternXY\t\tCalculate the relaction pixel/mm in the X and Y component\n')

fprintf('\nCurves:\n')
fprintf('\tCalculateCurves\t\tCalculate and assing the curves for the experiments\n')
fprintf('\tsaveCurves\t\tSave the curves for the experiments\n')
fprintf('\tEditCurve\t\tSelect or edit a curve\n')

fprintf('\nResults:\n')
fprintf('\tMaxMinResults\t\tDisplay the max and min values for the experiments\n')
fprintf('\tCalculateVolume\t\tCalculate the volume in a region\n')
fprintf('\tGlobalResults\n')

fprintf('\nGraphics:\n')
fprintf('\tCurvesinZ\n')
fprintf('\tCurvesinZdefined\n')
fprintf('\tSurfaceFirst\n')
fprintf('\tSurfaceSecond\n')
fprintf('\tlevelCurves\n')

fprintf('\nUtils:\n')
fprintf('\tsimetric\t\tTransform the image to the simatric vertical plane\n')
fprintf('\tfixCurves\t\tFixing mistakes created by the patterns\n')
fprintf('\tflatplate\t\tSet the flat plate in the graphics\n')
fprintf('\tAllSteps\t\tExecute all the basic steps for the software\n')

