
checkings={'init','patternZ','patternXY'}; 
checks


%% Getting case curves. Matching patterns to the case lines and form such lines.
disp('Getting case curves. Matching patterns to the case lines and form such lines.');
if defLoadCurves==false
    uiwait(msgbox('It will be loaded the cases and patterns. Select the line that belongs to the black and white figure for the showed pattern.'));
end

    %check if we are going to calculate the curves using differences between
%flat curves and modified curves
if flatcurves
    times=2;
else
    times=1;
end
for iflatplate = 1:times
    i1=20;
    i2=100;
    for iens = 1:length(scases)
        if iflatplate==2
            matfile=fullfile(strcat(pcases,'/flatcurves/',scases(iens).name,'.mat'));
            matfilesplit=fullfile(strcat(pcases,'/flatcurves/',scases(iens).name,'-split.mat'));
        else
            matfile=fullfile(strcat(pcases,'/',scases(iens).name,'.mat'));
            matfilesplit=fullfile(strcat(pcases,'/',scases(iens).name,'-split.mat'));
        end
        allcurves=false;
        numCurve=1;
        scurves=[];
        if defLoadCurves & exist(matfile, 'file')~=0
            load(matfile,'scurves');
            
            if Zplane.totLines==length(scurves)
                allcurves=true;
            else
                numCurve=length(scurves)+1;
            end
        end
        
        if iflatplate==2
            fprintf('Loading flat curve for the case %s\n',scases(iens).name);
            scases(iens).flatcurves=scurves;
        else
            fprintf('Loading case %s\n',scases(iens).name);
            scases(iens).curves=scurves;
        end
        if ~allcurves
            if iflatplate==2
                im=imread(scases(iens).flatpath); 
                textTitle=([scases(iens).name ' - Flat Curve']);
            else
                im=imread(scases(iens).path); %image of the case
                textTitle=(scases(iens).name);
            end
            
            fin = 0;
            fin2=-1;
            while fin==0
                if exist(matfilesplit, 'file')~=0 & fin2==-1
                    load(matfilesplit,'im_bw'); 
                    cc = bwconncomp(im_bw, 4);
                    labeled = labelmatrix(cc);
                    Lrgb = label2rgb(labeled, @lines, 'c', 'shuffle');
                    imshow(Lrgb);
                    title(textTitle);
                    set(gcf,'units','normalized','outerposition',[0 0 1 1]);
                else
                    %Calculating colour lines.
                    fin1 = 0;
                    while fin1==0
                        imshow(im);
                        title(textTitle);

                        set(gcf,'units','normalized','outerposition',[0 0 1 1])
                        prompt={'First intensity for the filter:','Pixel to be removed in isolated objects:'};
                        name='Seleccione intensidad filtro';
                        numlines=1;
                        defaultanswer={num2str(i1),num2str(i2)};

                        answer=inputdlg(prompt,name,numlines,defaultanswer);
                        
                        i1=str2num(answer{1});%First intensity for the filter
                        i2=str2num(answer{2});%Pixel to be removed in isolated objects

                        %first filter
                        %convert to gray
                        I=rgb2gray(im);

                        
                        se = strel('disk',i1);
                        tophatFiltered = imtophat(I,se);
                        I = imadjust(tophatFiltered);

                        %second filter
                        background = imopen(I,strel('disk',i1));

                        % Display the Background Approximation as a Surface
                        figure, surf(double(background(1:8:end,1:8:end))),zlim([0 255]);
                        set(gca,'ydir','reverse');


                        I2 = I - background;

                        I3 = imadjust(I2);

                        level = graythresh(I3);
                        im_bw = im2bw(I3,level);
                        im_bw = bwareaopen(im_bw, i2);%Remove all objects in the image containing fewer pixels than i2 pixel

                        %paint in different color the bodies
                        cc = bwconncomp(im_bw, 4);
                        labeled = labelmatrix(cc);
                        Lrgb = label2rgb(labeled, @lines, 'c', 'shuffle');
                        %show the result
                        close all;
                        imshow(Lrgb)
                        title(textTitle);
                        set(gcf,'units','normalized','outerposition',[0 0 1 1])
                        choice = questdlg('The lines must appear in colours and clearly separated, continue?', 	'Accept the image','Accept the image', 'No','End the capture','-');
                        if strcmp(choice,'Accept the image') | strcmp(choice,'')
                            fin1=1;
                            fin2=-1;
                            save(matfilesplit,'im_bw');
                        elseif strcmp(choice,'End the capture')
                            fin=1;
                            fin1=1;
                            fin2=1;
                            iens=length(scases)+1;
                            close all;
                            return
                        end
                    end
                end
                
                while fin2==-1

                    choice = questdlg('The lines must appear in colours and clearly separated.', 	'Accept the image', 'Edit the image','Accept the image','Repeat colour capture','-');                
                    if strcmp(choice,'Accept the image') | strcmp(choice,'')
                        fin = 1;
                        fin2=1;
                    elseif strcmp(choice,'Edit the image')
                        im_bw=EditGraphics(im_bw,true,matfilesplit);
                    elseif strcmp(choice,'Repeat colour capture')
                        fin2=1;
                    end
                end
            end
            %old file with case curves
            fin = 0;
            if exist(matfile, 'file')~=0
                choice = questdlg('It is found an old file that has the information of this case and theirs curves. Do you want to use it? Warning! If you say NO the file will be removed and you will have to repeat the proccess', 	'Accept the image', 'Yes','No','-');
                if strcmp(choice,'No')
                    delete(matfile);
                    numCurve=1;
                end
            end

            %Getting all the curves of this case and it is saved as projected
            if(~exist('scurves','var'))
                scurves=[];
            end
            for ipat = numCurve:Zplane.totLines
                fin2=-1;
                while fin2==-1
                    cc = bwconncomp(im_bw, 4);
                    labeled = labelmatrix(cc);
                    Lrgb = label2rgb(labeled, @lines, 'c', 'shuffle');

                    imshow(Lrgb);title('Filtered image');
                    fprintf('Select the lines that correspond with the pattern %s ',num2str(ipat) );
                    title(['Select the lines that correspon with the curve num.' num2str(ipat)]);
                    set(gcf,'units','normalized','outerposition',[0 0 1 1])
                    [x,y]=ginput22('v2','KeepZoom','k*');
                    x=round(x);
                    y=round(y);
                    im_sel=bwselect(im_bw,x,y,4);
                    close all;

                    disp('Wait, projecting images.......');
                    %im_proj=imtransform(im,spatterns(ipat).data.t);
                    im_sel_proj=imtransform(im_sel,pattern1.data.t);
                    disp('projected images');

                    %show the projected curve result 

                    subplot(221)
                    imshow(im);title('Original photo'); 
                    subplot(222)
                    imshow(im_sel);title('Selected image'); 
                    subplot(223)
                    imshow(im_bw);title('Filtered photo');
                    subplot(224)
                    imshow(im_sel_proj);title('Filtered and projected photo'); 
                    set(gcf,'units','normalized','outerposition',[0 0 1 1])


                    %save the curve
                    choice = questdlg(['Are you selected the right curve that corresponds to num.' num2str(ipat) '? If you press NO you will not have to repeat the choosing'], 'Accept the image','Yes','No','Any mistake','-');
                    if strcmp(choice,'Si') | strcmp(choice,'')
                        fin2=1;
                        relacXY=A+B*ipat;
                        curve=struct('im_sel',im_sel,'im_sel_proj',im_sel_proj,'pos',ipat,'relacXY',relacXY,'z',ipat*Zplane.distZ);
                        scurves=[scurves curve];
                        save(matfile,'scurves');
                        if iflatplate==2
                            scases(iens).flatcurves=scurves;
                        else
                            scases(iens).curves=scurves;
                        end
                        close all;
                    elseif strcmp(choice,'Any mistake')
                        choice = questdlg(['What do you want to do?'], 'Accept the image','Edit image','Quit','-');
                        if strcmp(choice,'Edit image') | strcmp(choice,'')
                            im_bw=EditGraphics(im_bw,true,matfilesplit);

                            close all;
                        else
                            close all;
                            return;
                        end
                    else
                        close all;
                    end
                end
            end     
        end
    end
end

