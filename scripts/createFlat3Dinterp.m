if(~exist('modeGraph','var'))
    modeGraph='3D';
end
dattotfile=fullfile(strcat(pdata,scases(iens).name,'.dat'));

if strcmp(modeGraph,'CurvesinZ')
    [xq,zq,vq]=create3Dinterp(dattotfile,piter,'2D',zsel);
else
    [xq,zq,vq]=create3Dinterp(dattotfile,piter);    
end

if flatcurves
    datflattotfile=fullfile(strcat(pdata,scases(iens).name,'-flat.dat'));
    if strcmp(modeGraph,'CurvesinZ')
        [xqf,zqf,vqf]=create3Dinterp(datflattotfile,piter,'2D',zsel);
    else
        [xqf,zqf,vqf]=create3Dinterp(datflattotfile,piter);   
    end

    vq=vq-vqf;
    if dimensionless
        xqf=xqf/dimensionless;
        zqf=zqf/dimensionless;
        vqf=vqf/dimensionless;
    end
end

if dimensionless
    xq=xq/dimensionless;
    zq=zq/dimensionless;
    vq=vq/dimensionless;
end
