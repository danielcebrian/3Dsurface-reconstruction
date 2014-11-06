if(~exist('inizialized','var'))
    init
end

%% Show the graphics
close all;
datfile = 'Results.dat';
totsol=load(datfile);

x=totsol(:,2);%height of the flat plate
y1=totsol(:,3);%depth of the first scour
y2=totsol(:,4);%dune of the first dune
y3=totsol(:,5);%depth of the second scour
y4=totsol(:,6);%volumen of the first scour
y5=totsol(:,7);%volumen of the first dune
z=totsol(:,1);%angle of the flat plate
angles=unique(z);% different angles studied
if dimensionless~=0
    x=x/dimensionless;
    y1=y1/dimensionless;
    y2=y2/dimensionless;
    y3=y3/dimensionless;
    y4=y4/dimensionless;
    y5=y5/dimensionless;
end

cc=hsv(length(angles));
%first scour
clearvars Leg;
for a=1:length(angles)
    plot(x(find(z==angles(a))),y1(find(z==angles(a))),'color',cc(a,:));
    title('Depth in the first scour','fontsize',20);
    hold on;
    %axis equal;
    Leg{a} = ['\alpha = ',num2str(angles(a)),'º']; 
end
legend(Leg);
%label
xlhand = get(gca,'xlabel');
ylhand = get(gca,'ylabel');
if dimensionless==0
    set(xlhand,'string','h (mm)','fontsize',20)
    set(ylhand,'string','Depth (mm)','fontsize',20)
else
    set(xlhand,'string','h/c','fontsize',20)
    set(ylhand,'string','Depth (y/c)','fontsize',20)
end
%axis to fontsize 20
set(gca,'fontsize',20)
dattotfile=fullfile(strcat(pgraphics,'results_first_scour'));
saveas(gcf, dattotfile, 'jpg')

figure
clearvars Leg;
for a=1:length(angles)
    plot(x(find(z==angles(a))),y4(find(z==angles(a))),'color',cc(a,:));
    title('Volume of the first scour','fontsize',20);
    hold on;
    %axis equal;
    Leg{a} = ['\alpha = ',num2str(angles(a)),'º']; 
end
legend(Leg);
%label
xlhand = get(gca,'xlabel');
ylhand = get(gca,'ylabel');
if dimensionless==0
    set(xlhand,'string','h (mm)','fontsize',20)
    set(ylhand,'string','Volume (mm^3)','fontsize',20)
else
    set(xlhand,'string','h/c','fontsize',20)
    set(ylhand,'string','Volume (y^3/c^3)','fontsize',20)
end
%axis to fontsize 20
set(gca,'fontsize',20)
dattotfile=fullfile(strcat(pgraphics,'results_volume_first_scour'));
saveas(gcf, dattotfile, 'jpg')

%first dune
figure
clearvars Leg;
for a=1:length(angles)
    plot(x(find(z==angles(a))),y2(find(z==angles(a))),'color',cc(a,:));
    title('Height in the first dune','fontsize',20);
    hold on;
    %axis equal;
    Leg{a} = ['\alpha = ',num2str(angles(a)),'º']; 
end
legend(Leg);
%label
xlhand = get(gca,'xlabel');
ylhand = get(gca,'ylabel');
if dimensionless==0
    set(xlhand,'string','h (mm)','fontsize',20)
    set(ylhand,'string','Height (mm)','fontsize',20)
else
    set(xlhand,'string','h/c','fontsize',20)
    set(ylhand,'string','Height (y/c)','fontsize',20)
end
%axis to fontsize 20
set(gca,'fontsize',20)
dattotfile=fullfile(strcat(pgraphics,'results_first_dune'));
saveas(gcf, dattotfile, 'jpg')
figure
clearvars Leg;
for a=1:length(angles)
    plot(x(find(z==angles(a))),y5(find(z==angles(a))),'color',cc(a,:));
    title('Volume of the first dune','fontsize',20);
    hold on;
    %axis equal;
    Leg{a} = ['\alpha = ',num2str(angles(a)),'º']; 
end
legend(Leg);
%label
xlhand = get(gca,'xlabel');
ylhand = get(gca,'ylabel');
if dimensionless==0
    set(xlhand,'string','h (mm)','fontsize',20)
    set(ylhand,'string','Volume (mm^3)','fontsize',20)
else
    set(xlhand,'string','h/c','fontsize',20)
    set(ylhand,'string','Volume (y^3/c^3)','fontsize',20)
end
%axis to fontsize 20
set(gca,'fontsize',20)
dattotfile=fullfile(strcat(pgraphics,'results_volume_first_dune'));
saveas(gcf, dattotfile, 'jpg')

%second scour
% figure
% clearvars Leg;
% for a=1:length(angles)
%     plot(x(find(z==angles(a))),y3(find(z==angles(a))),'color',cc(a,:));
%     title('Depth in the second scour','fontsize',20);
%     hold on;
%     %axis equal;
%     Leg{a} = ['\alpha = ',num2str(angles(a)),'º']; 
% end
% legend(Leg);
% %label
% xlhand = get(gca,'xlabel');
% ylhand = get(gca,'ylabel');
% if dimensionless==0
%     set(xlhand,'string','h (mm)','fontsize',20)
%     set(ylhand,'string','Depth (mm)','fontsize',20)
% else
%     set(xlhand,'string','h/c','fontsize',20)
%     set(ylhand,'string','Depth (y/c)','fontsize',20)
% end
% %axis to fontsize 20
% set(gca,'fontsize',20)
% dattotfile=fullfile(strcat(pgraphics,'results_second_scour'));
% saveas(gcf, dattotfile, 'jpg')
