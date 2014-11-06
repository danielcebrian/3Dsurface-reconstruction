function [xq,zq,vq] = create3Dinterp(dattotfile,piter,threeD,zsel)
%threeD = '3D' interp in 3D and '2D' interp in 2D
if(~exist('threeD','var'))
    threeD='3D';
    zsel=0;
end

totsol=load(dattotfile);
x= totsol(:,1);
y=totsol(:,2);
z=totsol(:,3);

if strcmp(threeD,'3D')
    px=(max(x)-min(x))/piter;
    pz=(max(z)-min(z))/piter;
    [xq,zq] = meshgrid(min(x):px:max(x), min(z):pz:max(z));
    vq = griddata(x,z,y,xq,zq);
else
    xq=linspace(min(x),max(x),piter);
    zq=zsel*ones(1,piter);
    vq = griddata(x,z,y,xq,zq);
end

end
