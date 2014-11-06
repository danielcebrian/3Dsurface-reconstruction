
checkings={'init','curves'}; 
checks

%% Show the graphics
close all;
if isdir(defResults)==0
    mkdir(defResults)
end
for iens = 1:length(scases)
    
    dattotfile=fullfile(strcat(pdata,scases(iens).name,'.dat'));
    totsol=load(dattotfile);
    x= totsol(:,1);
    y=totsol(:,2);
    z=totsol(:,3);
    
    zcurve=unique(z);
    
    %2D
    figure
    cc=hsv(length(scases(iens).curves));
    for icur = 1:length(zcurve)
        plot(x(find(z==zcurve(icur))),y(find(z==zcurve(icur))),'color',cc(icur,:));
        hold on;
        axis equal;
        Leg{icur} = ['z = ',num2str(scases(iens).curves(icur).pos*Zplane.distZ),' mm']; 
    end
    hold on;
    
%     rectangle('Position',[45,35,48,35],...
%           'Curveture',[0,0],...
%          'LineWidth',2,'LineStyle','-')
    
    legend(Leg);
    %title
        title(['Graphic of all the Z curves'],'fontsize',20)
   
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
    paintfp='2D';
    paintFlatPlate
    
    dattotfile=fullfile(strcat(pgraphics,scases(iens).name,'_2Dcurves.jpg'));
    saveas(gcf, dattotfile, 'jpg')
    
    
end

