%% Initial data of the software
%Las variables pueden empezar por:
%n = number | p = path | f = file/folder | s = array struct | im = image
%los colores para las líneas pueden ser Rojo, Verde y Azul nada más. Estos
%colores han de ser lo más puro posibles, a ser posible 255 de color, para
%mayor contraste

clearvars -except checkings checklocal numCheckingTot checkingdone;
close all;
home;

%default values -except c f
defPattern1='patterns/pattern1.JPG'; %first pattern name
defPattern2='patterns/pattern2.JPG'; %second pattern name
defPatternXY='patterns/patternXY.png'; %nombre archivo patrón horizontal real
defPatternZ='patterns/patternZ.jpg'; %nombre archivo patrón horizontal real
defCases='cases'; %nombre carpeta contenedora de imagenes con cases
defFlatplate='flatplate'; %nombre archivo con objeto que crea erosion
defLoadOldPoints=true; %si está true cargará los puntos tomados anteriormente sin preguntar
defLoadCurves=true; %si está true cargará las curves tomados anteriormente sin preguntar
defLoadRelacZ=true; %si está true cargará la relación de pixel/mm en Z tomados anteriormente sin preguntar
defResults='results';%carpeta que se generará con los results de las curves
defGraphics=[defResults '/graphics'];%carpeta que se generará con las gráficas
defData=[defResults '/data'];%carpeta que se generará con las gráficas
defConfFile='conf.mat';

%default
flatcurves=false;%check if we are going to calculate the curves using differences between flat curves and modified curves
piter=500;%value to iterate
seeflatplate=true; %options to see flat plate in the graphics
dimensionless=20; %dimensionless is the value to dimensionless the units in the graphics. If is equal to 0 or false => there is dimensions. 
applysymmetry=false;


if exist(defConfFile, 'file')
    load(defConfFile,'conf');
       
else
    uiwait(msgbox('Welcome! It is the first time and it is necessary the previous configuration'));
    choice = questdlg('Do you want to transform all the pictures to the simetric?', 	'simetric', 'Yes','No','-');
    if strcmp(choice,'Yes') | strcmp(choice,'')
        applysymmetry=true;
    end
    choice = questdlg('Do you want to calculate the curves using differences between flat curves and modified curves?', 	'flat curves', 'Yes','No','-');
    if strcmp(choice,'Yes') | strcmp(choice,'')
        conf.flatcurves=true;
    else
        conf.flatcurves=false; 
    end
    choice = questdlg('Do you want to see the flat plate in the graphics?', 	'flat plate', 'Yes','No','-');
    if strcmp(choice,'Yes') | strcmp(choice,'')
        conf.seeflatplate=true;
    else
        conf.seeflatplate=false; 
    end
    prompt={'Number of points to interpolate one curve:','Value to dimensionless the graphic results (0 or false means with dimensions):'};
    name='Options';
    numlines=1;
    defaultanswer={num2str(piter),num2str(dimensionless)};

    answer=inputdlg(prompt,name,numlines,defaultanswer);
    conf.piter=str2num(answer{1});
    conf.dimensionless=str2num(answer{2});

   
    save(defConfFile,'conf');
end

piter=conf.piter;
dimensionless=conf.dimensionless;
flatcurves=conf.flatcurves;
seeflatplate=conf.seeflatplate;

%path results
presults=strcat(pwd,'/',defResults,'/');
pgraphics=strcat(pwd,'/',defGraphics,'/');
pdata=strcat(pwd,'/',defData,'/');

%Detecta si existe el archivo patrón inicial
if exist(fullfile(cd, defPattern1), 'file')==0
    fprintf('\nNo existe patrón inicial\n')
    %toma patrón inicial (pattern1)
    [fpattern1, ppattern1, filterindex] = uigetfile({'*.png','Image PNG';'*.jpg','Image JPG'}, 'Abre foto PATRON inicial');
    if ppattern1==0
        fprintf('\nNo se ha seleccionado imagen patrón\n\nFin\n\n')
        f = errordlg('No se ha seleccionado imagen patrón.', 'Error Dialog');
        return
    end
    ppattern1=strcat(ppattern1,fpattern1);
else
    ppattern1=fullfile(cd, defPattern1);
end
fprintf('\nArchivo patrón inicial en: %s\n',ppattern1)

%Detecta si existe el archivo patrón final
if exist(fullfile(cd, defPattern2), 'file')==0
    fprintf('\nNo existe patrón final\n')
    %toma patrón final (pattern2)
    [fpattern2, ppattern2, filterindex] = uigetfile({'*.png','Image PNG';'*.jpg','Image JPG'}, 'Abre foto PATRON final');
    if ppattern2==0
        fprintf('\nNo se ha seleccionado imagen patrón\n\nFin\n\n')
        f = errordlg('No se ha seleccionado imagen patrón.', 'Erroapplysymmetryr Dialog');
        return
    end
    ppattern2=strcat(ppattern2,fpattern2);
else
    ppattern2=fullfile(cd, defPattern2);
end
fprintf('\nArchivo patrón final en: %s\n',ppattern2)

%Detecta si existe carpeta cases
if exist(fullfile(cd, defCases), 'file')==0
    fprintf('\nNo existe la carpeta contenedora de imagenes con cases\n')
    pcases = uigetdir(cd, 'Toma la carpeta contenedora de imagenes cases');
    if pcases==0
        fprintf('\nNo se ha seleccionado ninguna carpeta contenedora de imagenes con cases\n\nFin\n\n')
        f = errordlg('No se ha seleccionado ninguna carpeta contenedora de imagenes con cases', 'Error Dialog');
        return
    end
else
    pcases=fullfile(cd, defCases);
end
fprintf('\nCarpeta cases en: %s\n',pcases)

%Detecta si existe el archivo patrón horizontal real (patternReal)
if exist(fullfile(cd, defPatternXY), 'file')==0
    fprintf('\nNo existe patrón horizontal real\n')
    %toma patrón horizontal real (patternReal)
    [fpatternReal, ppatternReal, filterindex] = uigetfile({'*.png','Image PNG';'*.jpg','Image JPG'}, 'Abre foto PATRON horizontal real');
    if ppatternReal==0
        fprintf('\nNo se ha seleccionado imagen patrón\n\nFin\n\n')
        f = errordlg('No se ha seleccionado imagen patrón.', 'Error Dialog');
        return
    end
    ppatternReal=strcat(ppatternReal,fpatternReal);
else
    ppatternReal=fullfile(cd, defPatternXY);
end
fprintf('\nArchivo patrón real en: %s\n',ppatternReal)


%Detecta si existe el archivo patrón Z
if exist(fullfile(cd, defPatternZ), 'file')==0
    fprintf('\nNo existe patrón Z\n')
    %toma patrón Z (patternZ)
    [fpatternZ, ppatternZ, filterindex] = uigetfile({'*.png','Image PNG';'*.jpg','Image JPG'}, 'Abre foto PATRON Z');
    if ppatternZ==0
        fprintf('\nNo se ha seleccionado imagen patrón\n\nFin\n\n')
        f = errordlg('No se ha seleccionado imagen patrón.', 'Error Dialog');
        return
    end
    ppatternZ=strcat(ppatternZ,fpatternZ);
else
    ppatternZ=fullfile(cd, defPatternZ);
end
fprintf('\nArchivo patrón Z en: %s\n',ppatternZ)

%crear array con todos los patternes
[pathstr,name,ext] = fileparts(ppattern1);
if strcmp(ext,'.jpg') | strcmp(ext,'.JPG') | strcmp(ext,'.png') | strcmp(ext,'.PNG')
    pattern1=struct('path',ppattern1,'name',name,'ext',ext);
end
[pathstr,name,ext] = fileparts(ppattern2);
if strcmp(ext,'.jpg') | strcmp(ext,'.JPG') | strcmp(ext,'.png') | strcmp(ext,'.PNG')
    pattern2=struct('path',ppattern2,'name',name,'ext',ext);
end


%crear array con todos los cases
fcases=dir(pcases);
scases=[];
for i = 1:length(fcases)
    if fcases(i).isdir==0
        filename=strcat(pcases,'/',fcases(i).name);
        [pathstr,name,ext] = fileparts(filename);
        if strcmp(ext,'.jpg') | strcmp(ext,'.JPG') | strcmp(ext,'.png') | strcmp(ext,'.PNG')
            case1=struct('path',filename,'name',name,'ext',ext);
            scases=[scases case1];
        end
    end
end

if flatcurves
    disp('Flat curves calculations is active');
    for i = 1:length(scases)
        filename=strcat(pcases,'/flatcurves/',scases(i).name,scases(i).ext);
        scases(i).flatpath=filename;
    end
end 

%flat plate positionapplysymmetry
if seeflatplate
    pflatplate=fullfile(cd, [defFlatplate '.mat']);
end

if exist(fullfile(cd, defResults), 'file')==0
    mkdir(defResults)
end
if exist(fullfile(cd, defGraphics), 'file')==0
    mkdir(defGraphics)
end
if exist(fullfile(cd, defData), 'file')==0
    mkdir(defData)
end

%salva el pattern real
impatternReal=imread(ppatternReal);

inizialized=true;

if applysymmetry
    simetric
end


