if(~exist('inizialized','var'))
    init
end

%% Calculate the pattern properties. Create the projected images to the image plan.
disp('Calculate the pattern properties. Create the projected images to the image plan.');
%calculate the transformation array for each patter
if defLoadOldPoints==false
    uiwait(msgbox('Match 6 points at least in the real image of the pattern and the known pattern.','Matching points'));
end

%find if there is a file with the transformation array for this pattern
[pathstr,name,ext] = fileparts(ppattern1);
matfile=fullfile(strcat(pathstr,'/',name,'.mat'));
[pathstr,name,ext] = fileparts(ppattern2);
matfile2=fullfile(strcat(pathstr,'/',name,'.mat'));
im=imread(pattern1.path);
im2=imread(pattern2.path);

fin=0;
while fin==0
    if exist(matfile, 'file')==0
        [inputPoints,basePoints]=cpselect(im(:,:,3),impatternReal,'Wait',true);
        set(gcf,'units','normalized','outerposition',[0 0 1 1]);

        t=cp2tform(inputPoints,basePoints,'polynomial',2);%

        pattern1.data.t =t;
        pattern2.data.t =t;

        fototrans_t=imtransform(im,t);
        fototrans_t2=imtransform(im2,t);

        pattern1.data.fototrans_t =fototrans_t;
        pattern2.data.fototrans_t =fototrans_t2;

        subplot(121)
        imshow(im);
        subplot(122)
        imshow(fototrans_t)
        set(gcf,'units','normalized','outerposition',[0 0 1 1]);

        choice = questdlg('Is it right the points that you have matched? Warning! If you press NO you will have to repeat', 	'Accept image', 'Yes','No','-');
        if strcmp(choice,'Yes') | strcmp(choice,'')
            pattern1.data.pos=0;
            pattern1.data.z=0;
            fin=1;
            
            
            imshow(pattern2.data.fototrans_t)
            set(gcf,'units','normalized','outerposition',[0 0 1 1]);
            prompt={'Number of the second pattern line position knowing that the first pattern line is 1:'};
            name='Type second pattern position';
            numlines=1;
            defaultanswer={'13'};

            answer=inputdlg(prompt,name,numlines,defaultanswer);
            
            pattern2.data.pos=(str2num(answer{1})-1);
            pattern2.data.z=(str2num(answer{1})-1)*Zplane.distZ;
        end
        close all
    else
        fin=1;
    end
    % Finding the ratio pixel/mm
    if fin 
        if exist(matfile, 'file')~=0
            fprintf('there is a ratio pixel/mm for %s\n',pattern1.name);
            load(matfile,'data');
            pattern1.data=data;
            if exist(matfile2, 'file')~=0
                fprintf('there is a ratio pixel/mm for %s\n',pattern2.name);
                load(matfile2,'data');
                pattern2.data=data;
            else
                %pattern2
                pattern2.data.t=pattern1.data.t;
                pattern2.data.fototrans_t=imtransform(im2,pattern1.data.t);
                imshow(pattern2.data.fototrans_t)
                set(gcf,'units','normalized','outerposition',[0 0 1 1]);
                
                prompt={'Number of the second pattern line position knowing that the first pattern line is 1:'};
                name='Type second pattern position';
                numlines=1;
                defaultanswer={'13'};

                answer=inputdlg(prompt,name,numlines,defaultanswer);

                pattern2.data.pos=(str2num(answer{1})-1);
                pattern2.data.z=(str2num(answer{1})-1)*Zplane.distZ;
                prompt={'Type the known distance in mm:','Number of iteration to calculate the average:'};
                name='Finding the ratio pixel/mm';
                numlines=1;
                defaultanswer={'2.5','3'};

                answer=inputdlg(prompt,name,numlines,defaultanswer);
                distPuntos=str2num(answer{1});
                d=str2num(answer{2});

                j=1;
                zoom on
                uiwait(msgbox('Select known distances in HORIZONTAL','Finding the ratio pixel/mm'));

                for i2=d:-1:1,
                    [x,y]=ginput22(2,'KeepZoom','k*');
                    r=abs(x(2)-x(1));
                    rel(j)=distPuntos/r;
                    j=j+1;
                end
                uiwait(msgbox('Select known distances in VERTICAL','Finding the ratio pixel/mm'));

                for i2=d:-1:1,

                    [x,y]=ginput22(2,'KeepZoom','k*');
                    r=abs(y(2)-y(1));
                    rel(j)=distPuntos/r;
                    j=j+1;
                end
                close all

                relacXY=mean(rel);%relacXY is the ratio pixel/mm for the xy view
                desv=std(rel);
                pattern2.data.relacXY = relacXY;
                save(matfile2,'data');
            end
        else
            imshow(pattern1.data.fototrans_t)
            set(gcf,'units','normalized','outerposition',[0 0 1 1]);
            prompt={'Type a known distance in mm:','Number of iteration to calculate the average:'};
            name='Finding the ratio pixel/mm';
            numlines=1;
            defaultanswer={'2.5','3'};

            answer=inputdlg(prompt,name,numlines,defaultanswer);
            distPuntos=str2num(answer{1});
            d=str2num(answer{2});

            j=1;
            zoom on
            uiwait(msgbox('Select known distances in HORIZONTAL','Finding the ratio pixel/mm'));

            for i2=d:-1:1,
                [x,y]=ginput22(2,'KeepZoom','k*');
                r=abs(x(2)-x(1));
                rel(j)=distPuntos/r;
                j=j+1;
            end
            uiwait(msgbox('Select known distances in VERTICAL','Finding the ratio pixel/mm'));

            for i2=d:-1:1,

                [x,y]=ginput22(2,'KeepZoom','k*');
                r=abs(y(2)-y(1));
                rel(j)=distPuntos/r;
                j=j+1;
            end
            close all

            relacXY=mean(rel);%relacXY is the ratio pixel/mm for the xy view
            desv=std(rel);
            pattern1.data.relacXY = relacXY;
            data=pattern1.data;
            save(matfile,'data');
            
            %pattern2
            imshow(pattern2.data.fototrans_t)
            set(gcf,'units','normalized','outerposition',[0 0 1 1]);
            prompt={'Type a known distance in mm:','Number of iteration to calculate the average:'};
            name='Finding the ratio pixel/mm';
            numlines=1;
            defaultanswer={'2.5','3'};

            answer=inputdlg(prompt,name,numlines,defaultanswer);
            distPuntos=str2num(answer{1});
            d=str2num(answer{2});

            j=1;
            zoom on
            uiwait(msgbox('Select known distances in HORIZONTAL','Finding the ratio pixel/mm'));

            for i2=d:-1:1,
                [x,y]=ginput22(2,'KeepZoom','k*');
                r=abs(x(2)-x(1));
                rel(j)=distPuntos/r;
                j=j+1;
            end
            uiwait(msgbox('Select known distances in VERTICAL','Finding the ratio pixel/mm'));

            for i2=d:-1:1,

                [x,y]=ginput22(2,'KeepZoom','k*');
                r=abs(y(2)-y(1));
                rel(j)=distPuntos/r;
                j=j+1;
            end
            close all

            relacXY=mean(rel);%relacXY is the ratio pixel/mm for the xy view
            desv=std(rel);
            pattern2.data.relacXY = relacXY;
            data=pattern2.data;
            save(matfile2,'data');
        end
    end
end

%calculate the parameters to fit the curve as relacXY=A+Bx
A=pattern1.data.relacXY;
B=(pattern2.data.relacXY-pattern1.data.relacXY)/pattern2.data.pos;


