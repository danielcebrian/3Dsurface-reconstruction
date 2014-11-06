
checkings={'init','patternZ','curves'}; 
checks


str={scases.name};
[s,v] = listdlg('PromptString','Select an case to edit:','SelectionMode','single','ListString',str);


choice = questdlg('Do you want to edit the flat curves of this Case?', 	'Flat curves','No', 'Flat curves','-');
if strcmp(choice,'No') | strcmp(choice,'')
    iflatplate=1;
else
    iflatplate=2;
end

if v
    disp(['You are editing the Case ' scases(s).name])
    
        
    if iflatplate==2
        matfile=fullfile(strcat(pcases,'/flatcurves/',scases(s).name,'.mat'));
        matfilesplit=fullfile(strcat(pcases,'/flatcurves/',scases(s).name,'-split.mat'));
    else
        matfile=fullfile(strcat(pcases,'/',scases(s).name,'.mat'));
        matfilesplit=fullfile(strcat(pcases,'/',scases(s).name,'-split.mat'));
    end
    
    if exist(matfilesplit, 'file')~=0
        load(matfilesplit,'im_bw');
        cc = bwconncomp(im_bw, 4);
        labeled = labelmatrix(cc);
        Lrgb = label2rgb(labeled, @lines, 'c', 'shuffle');
    else
        Lrgb=imread(scases(s).path);
    end
    close all;
    imshow(Lrgb);
    set(gcf,'units','normalized','outerposition',[0 0 1 1])
    
    prompt={'What number of line you want to edit?'};
    name='Number of line';
    numlines=1;
    defaultanswer={'1'};

    answer=inputdlg(prompt,name,numlines,defaultanswer);

    line=str2num(answer{1});
    
    
    close all;
    if iflatplate==2
        im_sel_proj=scases(s).flatcurves(line).im_sel_proj;
        curves=scases(s).flatcurves;
    else
        im_sel_proj=scases(s).curves(line).im_sel_proj;
        curves=scases(s).curves;
    end
    imshow(im_sel_proj);
    
    choice = questdlg('Do you want to select again or edit?', 	'Curve','Edit', 'Select again','-');
    if strcmp(choice,'Edit') | strcmp(choice,'')
        fin2=-1;
        while fin2==-1
            im_sel_proj = EditGraphics(im_sel_proj);
            scurves=curves;
            
            close all;
            cc = bwconncomp(im_sel_proj, 4);
            labeled = labelmatrix(cc);
            Lrgb = label2rgb(labeled, @lines, 'c', 'shuffle');
            imshow(Lrgb)
            set(gcf,'units','normalized','outerposition',[0 0 1 1]);
            
            choice = questdlg(['Is it right the curve Nº' num2str(line) '?'], 'Accept Image','Yes','No','Quit','-');
            if strcmp(choice,'Yes') | strcmp(choice,'')
                fin2 = 1;
                close all;
            elseif strcmp(choice,'No')
                choice = questdlg(['Do you want to select fragments of the line or edit again?'], 'Accept Image','Select fragments','Edit','Quit','-');
                if strcmp(choice,'Select fragments') | strcmp(choice,'')
                    %to-do
                elseif strcmp(choice,'Quit')
                    close all;
                    return
                end
            elseif strcmp(choice,'Quit')
                close all;
                return
            end
        end
    else
        load(matfilesplit,'im_bw'); 

        fin2=-1;
        while fin2==-1
            im=im_sel_proj;
            cc = bwconncomp(im_bw, 4);
            labeled = labelmatrix(cc);
            Lrgb = label2rgb(labeled, @lines, 'c', 'shuffle');

            imshow(Lrgb);title('Filtered photo');
            fprintf('Select the lines that correspond with the pattern number %s ',num2str(line) );
            title(['Select the lines that correspond with the curve number' num2str(line)]);
            set(gcf,'units','normalized','outerposition',[0 0 1 1])
            [x,y]=ginput22('v2','KeepZoom','k*');
            x=round(x);
            y=round(y);
            im_sel=bwselect(im_bw,x,y,4);
            close all;

            disp('Wait, projecting images.......');
            im_sel_proj=imtransform(im_sel,pattern1.data.t);%projected curve with the transformed pattern array
            disp('Projected images');

            %show the selected and projected curve result

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
            choice = questdlg(['Are you selected the right curve number' num2str(line) '? If you press NO you will have to choose again'], 'Accept the image','Yes','No','Any mistake','-');
            if strcmp(choice,'Yes') | strcmp(choice,'')

                fin2 = 1;
                if iflatplate==2
                    scases(s).flatcurves(line).im_sel=im_sel;
                    scases(s).flatcurves(line).im_sel_proj=im_sel_proj;
                    scurves=scases(s).flatcurves;
                    
                else
                    scases(s).curves(line).im_sel=im_sel;
                    scases(s).curves(line).im_sel_proj=im_sel_proj;
                    scurves=scases(s).curves;
                    
                end
                save(matfile,'scurves');
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
    close all;
end
