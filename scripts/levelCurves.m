
checkings={'init','curves'}; 
checks

%% Show the graphics
close all;
if isdir(defResults)==0
    mkdir(defResults)
end
choice = questdlg('Do you want a fixed axis in "y"?', 	'Fix axes', 'Yes','No','-');                
if strcmp(choice,'Yes') | strcmp(choice,'')
    prompt={'Max y value:','Min y value:','Step value:'};
    name='Select the filter intensity';
    numlines=1;
     %default
    if(~exist('axisminy','var'))
        axisminy=-0.475;
    end
    if(~exist('axismaxy','var'))
        axismaxy=0.475;
    end
    if(~exist('stepv','var'))
        stepv=0.05;
    end
    defaultanswer={num2str(axismaxy),num2str(axisminy),num2str(stepv)};

    answer=inputdlg(prompt,name,numlines,defaultanswer);
   
    axismaxy=str2num(answer{1});
    axisminy=str2num(answer{2});
    stepv=str2num(answer{3});
else
    axisminy=0;
    stepv=0;
    axismaxy=0;
end

for iens = 1:length(scases)
    modeGraph='3D';
    createFlat3Dinterp
    
    zmin = floor(min(vq(:)));
    zmax = ceil(max(vq(:)));
    zinc = (zmax - zmin) / 15;
    zlevs = axisminy:stepv:axismaxy;
    
    figure
    if ~isempty(zlevs)
        [c h] = contourf(xq,zq,vq, zlevs);
    else
        [c h] = contourf(xq,zq,vq); 
    end
    %colormap(hot);
    axis equal;
    if exist('axisminy','var') & exist('axismaxy','var')
        if axisminy~=axismaxy
            %caxis
            vcaxis=caxis;
            vcaxis(1)=min(axisminy,min(vq(:)));
            vcaxis(2)=max(axismaxy,max(vq(:)));
            caxis(vcaxis);
            %axis
            vaxis=axis;
            vaxis(5)=min(axisminy,min(vq(:)));
            vaxis(6)=max(axismaxy,max(vq(:)));
            axis(vaxis);
        end
    end
    colorbar('location','eastoutside')
    clabel(c,h,'FontSize', 15);
    
    %title
    if(~exist('sflatplate','var'))
        title(['Contour of ' scases(iens).name],'fontsize',20)
    else
        iflat=find(strcmp({sflatplate.cases.name},scases(iens).name));
        if dimensionless==0
            h=[num2str(sflatplate.cases(iflat).height) 'mm'];
        else
            h=[num2str(sflatplate.cases(iflat).height/dimensionless) 'c'];
        end
        title(['Contour to ' num2str(sflatplate.cases(iflat).angle) 'º h=' h],'fontsize',20)
    end
    
    %label
    xlhand = get(gca,'xlabel');
    ylhand = get(gca,'ylabel');
    zlhand = get(gca,'zlabel');
    if dimensionless
        set(xlhand,'string','Long (x/c)','fontsize',20)
        set(ylhand,'string','Width (z/c)','fontsize',20)
        set(zlhand,'string','Height (y/c)','fontsize',20)
    else
        set(xlhand,'string','Long (mm)','fontsize',20)
        set(ylhand,'string','Width (mm)','fontsize',20)
        set(zlhand,'string','Height (mm)','fontsize',20)
    end
    %axis to fontsize 20
    set(gca,'fontsize',20)
    
    paintfp='Contour';
    paintFlatPlate
    
    
    dattotfile=fullfile(strcat(pgraphics,scases(iens).name,'_contour.jpg'));
    saveas(gcf, dattotfile, 'jpg');
end

