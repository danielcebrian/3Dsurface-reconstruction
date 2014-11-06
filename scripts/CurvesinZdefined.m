
checkings={'init','curves','flatplate'}; 
checks

%% Show the graphics
close all;
if isdir(defResults)==0
    mkdir(defResults)
end
if dimensionless==0
    prompt={'Select curve in Z (mm):'};
    name='Curve in Z';
    numlines=1;
    defaultanswer={'32.5'};
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    zsel=str2num(answer{1});
else
    prompt={'Select curve in Z:'};
    name='Curve in Z';
    numlines=1;
    defaultanswer={num2str(32.5/dimensionless)};
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    zsel=str2num(answer{1})*dimensionless;
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


cc=hsv(length(scases));
modeGraph='CurvesinZ';
if(~exist('sflatplate','var'))
    for iens = 1:length(scases)
        if ~isempty(iens)
            createFlat3Dinterp

           

            plot(xq(1,:),vq(1,:));
            hold on;
            ex=xq(1:10:end);
            ev=vq(1:10:end);
            e = (0.617)*ones(size(ex));
            errorbar(ex(1,:),ev(1,:),e(1,:));
            axis equal;
            %Leg{iens} = ['Curve ',num2str(scases(iens).name),' mm'];
        end
    end
else
    for iflat = 1:length(sflatplate.cases)set(gca,'fontsize',20)
        iens=find(strcmp({scases.name},sflatplate.cases(iflat).name));
        if ~isempty(iens)
            createFlat3Dinterp
            plot(xq(1,:),vq(1,:));
            ex=xq(1:10:end);
            
e = (0.617)*ones(size(ex));
            ev=vq(1:10:end);
            hold on;
            errorbar(ex(1,:),ev(1,:),e,'color',cc(iens,:));
       %     axis equal;
            
            if(~exist('sflatplate','var'))
                h=[num2str(sflatplate.cases(iflat).height) 'mm'];
            else
                iflat=find(strcmp({sflatplate.cases.name},scases(iens).name));
                if dimensionless==0
                    h=[num2str(sflatplate.cases(iflat).height) 'mm'];
                else
                    h=[num2str(sflatplate.cases(iflat).height/dimensionless) 'c'];
                end
            end
            Leg{iens} = ['h = ',h];
            
        end
    end
    legend(Leg);
end

if exist('axisminy','var') & exist('axismaxy','var')
    if axisminy~=axismaxy
        %axis
        vaxis=axis;
        vaxis(3)=min(axisminy,min(vq(:)));
        vaxis(4)=max(axismaxy,max(vq(:)));
        axis(vaxis);
    end
end
%title
if(~exist('sflatplate','var'))
    if dimensionless
        title(['Curve in Z=' num2str(zsel/dimensionless) 'c of ' scases(iens).name],'fontsize',20)
    else
        title(['Curve in Z=' num2str(zsel) 'mm of ' scases(iens).name],'fontsize',20)
    end
else
    iflat=find(strcmp({sflatplate.cases.name},scases(iens).name));
    if dimensionless==0
        title(['Curve in Z=' num2str(zsel) 'mm of ' num2str(sflatplate.cases(iflat).angle) 'º'],'fontsize',20)
    else
        title(['Curve in Z=' num2str(zsel/dimensionless) 'c of ' num2str(sflatplate.cases(iflat).angle) 'º'],'fontsize',20)
    end
end

%label
xlhand = get(gca,'xlabel');
ylhand = get(gca,'ylabel');
if dimensionless
    set(xlhand,'string','Width (x/c)','fontsize',20)
    set(ylhand,'string','Height (y/c)','fontsize',20)
else
    set(xlhand,'string','Width (mm)','fontsize',20)
    set(ylhand,'string','Height (mm)','fontsize',20)
end
%axis to fontsize 20
set(gca,'fontsize',20)

dattotfile=fullfile(strcat(pgraphics,'curves_in_Z_',num2str(zsel),'.jpg'));
saveas(gcf, dattotfile, 'jpg');
