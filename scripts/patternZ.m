if(~exist('inizialized','var'))
    init
end

%% Calculate the distances in Z view
disp('Calculate the distances in Z view');
if defLoadRelacZ==false
    uiwait(msgbox('Calculating the ratio pixel/mm in Z.','Calculating the ratio pixel/mm in Z'));
end
[pathstr,name,ext] = fileparts(ppatternZ);
matfile=fullfile(strcat(pathstr,'/',name,'.mat'));

if exist(matfile, 'file')==0
    im=imread(ppatternZ);
    close all;
    imshow(im)
    set(gcf,'units','normalized','outerposition',[0 0 1 1]);

    prompt={'Type the channel width in Z direction:','Number of iteration:'};
    name='Calculating the ratio pixel/mm in Z (the depth)';
    numlines=1;
    defaultanswer={'65','1'};

    answer=inputdlg(prompt,name,numlines,defaultanswer);
    distPuntos=str2num(answer{1});
    d=str2num(answer{2});

    j=1;
    
    clear rel;
    for i2=d:-1:1,
        [x,y]=ginput22(2,'KeepZoom','k*');
        r=sqrt(abs(x(2)-x(1))^2+abs(y(2)-y(1))^2);
        rel(j)=distPuntos/r;
        j=j+1;
    end
    
    Zplane.channelWidth=distPuntos;

    Zplane.relacZ=mean(rel);%relacZ is the ratio pixel/mm for the z view
    Zplane.relacZdesv=std(rel);
   
    uiwait(msgbox('Now, select the distances between the lines in order to know the real separation among them','Find the ratio pixel/mm'));
    
    prompt={'Number of iteration to calculate the average:'};
    name='Find the ratio pixel/mm';
    numlines=1;
    defaultanswer={'6'};

    answer=inputdlg(prompt,name,numlines,defaultanswer);
    d=str2num(answer{1});

    j=1;
    clear rel;

    for i2=d:-1:1,
        [x,y]=ginput22(2,'KeepZoom','k*');
        r=sqrt(abs(x(2)-x(1))^2+abs(y(2)-y(1))^2);
        rel(j)=Zplane.relacZ*r;
        j=j+1;
    end
    
    %get the origin point 0,0,0
    uiwait(msgbox('1.Click in the first line at the beginning of the line. 2.Click in the origin point(0,0,0). This point must be aligned with all the origin lines','Get origin point'));
    [x,y]=ginput22(2,'KeepZoom','k*');
    r=sqrt(abs(x(2)-x(1))^2+abs(y(2)-y(1))^2);
    Zplane.ZeroPoint=Zplane.relacZ*r;
    close all

    Zplane.distZ=mean(rel);%distZ is the distance in mm between lines
    Zplane.distZdesv=std(rel);
    
    
    %number of lines
    prompt={'Number of lines (The first line is 1):'};
    name='Number of lines';
    numlines=1;
    defaultanswer={'14'};

    answer=inputdlg(prompt,name,numlines,defaultanswer);

    Zplane.totLines=str2num(answer{1});
    
    save(matfile,'Zplane');
else
    load(matfile,'Zplane');
end


