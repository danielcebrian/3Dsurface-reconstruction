checkings={'init','patternZ'}; 
checks


%% Calculate the position of the flat plate in the graphics
if seeflatplate
    disp('Getting the position of the flat plate in the graphics');
    if defLoadRelacZ==false
        uiwait(msgbox('It is necessary the distance of the flat plate to the beginning','Flat plate position'));
    end

    if exist(pflatplate, 'file')==0
        im=imread(ppatternZ);
        close all;
        imshow(im)
        set(gcf,'units','normalized','outerposition',[0 0 1 1]);

        prompt={'Width of the flat plate (mm):','Thickness (mm):'};
        name='Flat plate dimensions';
        numlines=1;
        defaultanswer={'25','1'};

        answer=inputdlg(prompt,name,numlines,defaultanswer);
        sflatplate.width=str2num(answer{1});
        sflatplate.thickness=str2num(answer{2});

        uiwait(msgbox('Select longitudinally a point in the center of the flat plate and another at the beginning of the curves','Find distance to the beginning of the graphics'));

        %get the center of the flat plate
        [x,y]=ginput22(2,'KeepZoom','k*');
        r=sqrt(abs(x(2)-x(1))^2+abs(y(2)-y(1))^2);
        sflatplate.dist=Zplane.relacZ*r;
        close all
        
        clearvars cases;
        cases=[];
        angle=0;
        h=0;
        for iensflat = 1:length(scases)
            prompt={'Angle of the flat plate (degree):','Height of the flat plate to the seabed (mm):'};
            name=['Ensayo ' scases(iensflat).name];
            numlines=1;
            defaultanswer={num2str(angle),num2str(h)};
            options.Resize='on';
            options.WindowStyle='normal';
            options.Interpreter='tex';

            answer=inputdlg(prompt,name,numlines,defaultanswer,options);
            angle=str2num(answer{1});
            h=str2num(answer{2});
            cases=[cases struct('name',scases(iensflat).name,'angle',angle,'height',h)];
        end
        sflatplate.cases=cases;

        save(pflatplate,'sflatplate');
    else
        load(pflatplate,'sflatplate');
    end
    
    %check that the cases number is the same as flat plate cases
    angle=0;
    h=0;
    changes=0;
    for iensflat = 1:length(scases)
        test=find(strcmp({sflatplate.cases.name},scases(iensflat).name));
        if isempty(test)
            cases=sflatplate.cases;
            prompt={'Angle of the flat plate:','Height of the flat plate to the seabed (mm):'};
            name=['Ensayo ' scases(iensflat).name];
            numlines=1;
            defaultanswer={num2str(angle),num2str(h)};
            options.Resize='on';
            options.WindowStyle='normal';
            options.Interpreter='tex';

            answer=inputdlg(prompt,name,numlines,defaultanswer,options);
            angle=str2num(answer{1});
            h=str2num(answer{2});
            cases=[cases struct('name',scases(iensflat).name,'angle',angle,'height',h)];
            changes=1;
        end
    end
    if changes==1
        sflatplate.cases=cases;

        save(pflatplate,'sflatplate');
    end
end


