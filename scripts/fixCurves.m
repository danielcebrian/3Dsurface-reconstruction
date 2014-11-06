checkings={'init','patternZ','patternXY'}; 
checks


%% fix mistakes created by the patterns
disp('fixing mistakes created by the patterns');

if exist('fixedpoints.mat', 'file')==0
    choice = questdlg('Do you want to fix the pattern image in order to get the right curves?', 	'Fix curves?', 'Yes','No','-');
    if strcmp(choice,'Yes') | strcmp(choice,'')
        im=pattern1.data.fototrans_t;
        fin=0;
        while fin==0
            imshow(im);
            set(gcf,'units','normalized','outerposition',[0 0 1 1]);
            uiwait(msgbox('Select two points. The first one is the upper left corner of the interest region. The second one is the lower right corner.','Select the interest region'));
            [x,y]=ginput(2);
            close all;
            points.x=min(max(x,1),size(pattern1.data.fototrans_t,2));
            points.y=min(max(y,1),size(pattern1.data.fototrans_t,1));
            imt=im;
            imt(:,1:round(points.x(1)),:)=0;
            imt(:,round(points.x(2)):end,:)=0;
            imt(1:round(points.y(1)),:,:)=0;
            imt(round(points.x(2)):end,:,:)=0;
            imshow(imt);
            choice = questdlg('Is it right the region?', 	'Fix curves?', 'Yes','No','-');
            if strcmp(choice,'Yes') | strcmp(choice,'')
                fin=1;
            end
            close all;
        end
        save('fixedpoints.mat','points');
        %check if we are going to calculate the curves using differences between
        %flat curves and modified curves
        if flatcurves
            times=2;
        else
            times=1;
        end
        for iflatplate = 1:times
            for iens = 1:length(scases)
                if iflatplate==2
                    matfile=fullfile(strcat(pcases,'/flatcurves/',scases(iens).name,'.mat'));
                else
                    matfile=fullfile(strcat(pcases,'/',scases(iens).name,'.mat'));
                end

                if defLoadCurves & exist(matfile, 'file')~=0
                    load(matfile,'scurves');
                    for icur=1:length(scurves)
                        scurves(icur).im_sel_proj(:,1:round(points.x(1)))=0;
                        scurves(icur).im_sel_proj(:,round(points.x(2)):end)=0;
                        scurves(icur).im_sel_proj(1:round(points.y(1)),:)=0;
                        scurves(icur).im_sel_proj(round(points.x(2)):end,:)=0;
                        
                    end
                    if iflatplate==2
                        fprintf('Fixing flat curve for the case %s\n',scases(iens).name);
                        scases(iens).flatcurves=scurves;
                    else
                        fprintf('Fixing case %s\n',scases(iens).name);
                        scases(iens).curves=scurves;
                    end
                    save(matfile,'scurves');
                    %end

                end
            end
        end
    else
        [x,y]=size(pattern1.data.fototrans_t);
        points.x=[1 y];
        points.y=[1 x];
        save('fixedpoints.mat','points');
    end
    disp('ended fixing curves');
    saveCurves
else
    disp('The curves have been fixed before. If you want to fix again, remove fixedcurves.mat in the root');
end


