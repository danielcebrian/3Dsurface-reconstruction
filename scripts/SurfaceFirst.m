
checkings={'init','curves'}; 
checks

%% Show the graphics
close all;
if isdir(defResults)==0
    mkdir(defResults)
end
choice = questdlg('Do you want a fixed axis in "y"?', 	'Fix axes', 'Yes','No','-');                
if strcmp(choice,'Yes') | strcmp(choice,'')
    prompt={'Max y value:','Min y value:'};
    name='Seleccione intensidad filtro';
    numlines=1;
     %default
    if(~exist('axisminy','var'))
        axisminy=-0.475;
    end
    if(~exist('axismaxy','var'))
        axismaxy=0.475;
    end
    defaultanswer={num2str(axismaxy),num2str(axisminy)};

    answer=inputdlg(prompt,name,numlines,defaultanswer);
   
    axismaxy=str2num(answer{1});
    axisminy=str2num(answer{2});
else
    axisminy=0;
    axismaxy=0;
end

for iens = 1:length(scases)
    modeGraph='3D';
    createFlat3Dinterp
    
    figure
    mesh(xq,zq,vq,vq);
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
    hold on
    
    %title
    if(~exist('sflatplate','var'))
        title(['3D view of ' scases(iens).name],'fontsize',20)
    else
        iflat=find(strcmp({sflatplate.cases.name},scases(iens).name));
        if dimensionless==0
            h=[num2str(sflatplate.cases(iflat).height) 'mm'];
        else
            h=[num2str(sflatplate.cases(iflat).height/dimensionless) 'c'];
        end
        title(['3D view of ' num2str(sflatplate.cases(iflat).angle) 'º h=' h],'fontsize',20)
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
    
    paintfp='3D';
    paintFlatPlate
    
    
    %plot the points
%     totsol=load(dattotfile);
%     x= totsol(:,1);
%     y=totsol(:,2);
%     z=totsol(:,3);%     totsol=load(dattotfile);
%     x= totsol(:,1);
%     y=totsol(:,2);
%     z=totsol(:,3);
%     plot3(x,z,y,'o');

%     plot3(x,z,y,'o');
    dattotfile=fullfile(strcat(pgraphics,scases(iens).name,'_3D.fig'));
    saveas(gcf, dattotfile, 'fig')
    dattotfile=fullfile(strcat(pgraphics,scases(iens).name,'_3D.jpg'));
    saveas(gcf, dattotfile, 'jpg');
end

