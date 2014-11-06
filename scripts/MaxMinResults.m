if(~exist('inizialized','var'))
    init
end

%Check curves
noCurves=false;
for iens = 1:length(scases)
    if(~isfield(scases(iens),'curves'))
        noCurves=true;
    end
end
if(noCurves)
    CalculateCurves
end

%% Max and Min
zm=0;
zM=0;
xm=0;
xM=0;
for iens = 1:length(scases)
    fin = 0;
    while fin==0
        close all;
        modeGraph='3D';
        createFlat3Dinterp

        %show fig
        figure
        [c h] = contour(xq,zq,vq, 'b-');
        %axis equal;
        clabel(c,h);
        title(scases(iens).name);
        xlabel('Long'), ylabel('Wide')
        set(gcf,'units','normalized','outerposition',[0 0 1 1]);

        choice = questdlg('Max and Min:', 	'Max and Min', 'Absolute','Relative','-');
        if strcmp(choice,'Relative') | strcmp(choice,'')
            prompt={'Region Xmin:','Region Xmax:','Region Zmin:','Region Zmax:'};
            name='Get the ratio pixel/mm';
            numlines=1;
            defaultanswer={num2str(xm),num2str(xM),num2str(zm),num2str(zM)};

            answer=inputdlg(prompt,name,numlines,defaultanswer);
            xm=str2num(answer{1});
            xM=str2num(answer{2});
            zm=str2num(answer{3});
            zM=str2num(answer{4});

            %X
            endX=(xq(1,piter+1));
            endZ=(zq(piter+1,1));
            vq(:,1:(xm*(piter)/endX+1))=NaN;
            vq(:,(xM*(piter)/endX+1):end)=NaN;
            %Z
            vq(1:(zm*(piter)/endZ+1),:)=NaN;
            vq((zM*(piter)/endZ+1):end,:)=NaN;
            %fixed the last point in the array
            vq(1,1)=NaN;
            vq(end,end)=NaN;
        end


        %Min
        [xmin,xpos]=min(vq);
        [vqmin,zpos]=min(xmin);
        xpos=xpos(zpos);
        zminz=zq(xpos,zpos);
        xminx=xq(xpos,zpos);
        %Max
        [xmax,xpos]=max(vq);
        [vqmax,zpos]=max(xmax);
        xpos=xpos(zpos);
        zmaxz=zq(xpos,zpos);
        xmaxx=xq(xpos,zpos);

        fprintf('\nCase: %s\n',scases(iens).name);
        fprintf('\t Min (x=%f z=%f y=%f), abs(Min)=%f\n',xminx,zminz,vqmin,abs(vqmin));
        fprintf('\t Max (x=%f z=%f y=%f), abs(max)=%f\n',xmaxx,zmaxz,vqmax,abs(vqmax));
        
        
        close all;
        %show fig
        figure
        [c h] = contour(xq,zq,vq, 'b-');
        axis equal;
        clabel(c,h);
        xlabel('Long'), ylabel('Wide')
        title(scases(iens).name);
        set(gcf,'units','normalized','outerposition',[0 0 1 1]);
        
        %set max/min
        hold on;
        plot(xminx,zminz,'k*');
        text(xminx,zminz,['min (' num2str(vqmin) ')'],'VerticalAlignment','bottom','HorizontalAlignment','right');
        plot(xmaxx,zmaxz,'k*');
        text(xmaxx,zmaxz,['max (' num2str(vqmax) ')'],'VerticalAlignment','bottom','HorizontalAlignment','right');

        
        choice = questdlg('Is the result what you have expected?', 	'Accept image','Yes', 'No (Repeat)','Finish','-');
        if strcmp(choice,'Yes') | strcmp(choice,'')
            fin=1;
        elseif strcmp(choice,'Finish')
            disp('End');
            close all;
            return
        end

    end  
end
