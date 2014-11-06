if(~exist('inizialized','var'))
    init
end

%Check curves
noCurves=false;
for iens = 1:length(scases)
    if(~isfield(scases(iens),'curves'))
        noCurves=true;
    end
end
if(noCurves)
    CalculateCurves
end

%% Show the graphics
close all;
if isdir(defResults)==0
    mkdir(defResults)
end
for iens = 1:length(scases)
    modeGraph='3D';
    createFlat3Dinterp
    
    %3D
    figure
    tri = delaunay(x,z);
    trisurf(tri,x,z,y)
    axis equal;
    hold on
    
    paintfp='3D';
    paintFlatPlate
end

