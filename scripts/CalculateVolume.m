
checkings={'init','curves'}; 
checks

%% Max and Min
zm=0;
zM=0;
xm=0;
xM=0;
level=0;
integrate='up';
for iens = 1:length(scases)
    fin = 0;
    while fin==0
        close all;
        dattotfile=fullfile(strcat(pdata,scases(iens).name,'.dat'));
        totsol=load(dattotfile);
        x= totsol(:,1);
        y=totsol(:,2);
        z=totsol(:,3);
        if dimensionless
            x=x/dimensionless;
            y=y/dimensionless;
            z=z/dimensionless;
        end


        p=500;%number of points to interpolate the x and z variables
        px=(max(x)-min(x))/p;
        pz=(max(z)-min(z))/p;
        [xq,zq] = meshgrid(min(x):px:max(x), min(z):pz:max(z));
        vq = griddata(x,z,y,xq,zq);

        %show fig
        figure
        [c h] = contour(xq,zq,vq, 'b-');
        %axis equal;
        clabel(c,h);
        title(scases(iens).name);
        xlabel('Long'), ylabel('Wide')
        set(gcf,'units','normalized','outerposition',[0 0 1 1]);

        
        prompt={'Region Xmin:','Region Xmax:','Region Zmin:','Region Zmax:','Level to integrate:','where integrate to? (Up or Down)'};
        name='Calculate region volume';
        numlines=1;
        defaultanswer={num2str(xm),num2str(xM),num2str(zm),num2str(zM),num2str(level),integrate};

        answer=inputdlg(prompt,name,numlines,defaultanswer);
        xm=str2num(answer{1});
        xM=str2num(answer{2});
        zm=str2num(answer{3});
        zM=str2num(answer{4});
        level=str2num(answer{5});
        integrate=answer{6};

        %X
        endX=(xq(1,p+1));
        endZ=(zq(p+1,1));
        vq(:,1:(xm*(p)/endX+1))=NaN;
        vq(:,(xM*(p)/endX+1):end)=NaN;
        %Z
        vq(1:(zm*(p)/endZ+1),:)=NaN;
        vq((zM*(p)/endZ+1):end,:)=NaN;
        %fixed the last point in the array
        vq(1,1)=NaN;
        vq(end,end)=NaN;
        
        %limit the maximum /minimum value
        if strcmp(integrate,'Up') | strcmp(integrate,'up')
            vq=max(vq,level);
        elseif strcmp(integrate,'Down') | strcmp(integrate,'down')
            vq=min(vq,level);
        end
        
        sum=0;
        dx=abs(xq(1,2)-xq(1,1));
        dz=abs(zq(2,1)-zq(1,1));
        
        for i=1:length(xq)
            for j=1:length(zq)
                dv=abs(level-vq(i,j));
                vu=dx*dz*dv;
                sum=sum+vu;
            end
        end
                
        if strcmp(integrate,'Down') | strcmp(integrate,'down')
            %Min
            [xmin,xpos]=min(vq);
            [vqmin,zpos]=min(xmin);
            xpos=xpos(zpos);
            zminz=zq(xpos,zpos);
            xminx=xq(xpos,zpos);
        elseif strcmp(integrate,'Up') | strcmp(integrate,'up')
            %Max
            [xmax,xpos]=max(vq);
            [vqmax,zpos]=max(xmax);
            xpos=xpos(zpos);
            zmaxz=zq(xpos,zpos);
            xmaxx=xq(xpos,zpos);
        end

        fprintf('\nCase: %s\n',scases(iens).name);
        fprintf('\tVolume = %f (u^3)\n',sum);
        
        
        
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
        if strcmp(integrate,'Down') | strcmp(integrate,'down')
            plot(xminx,zminz,'k*');
            text(xminx,zminz,['vol (' num2str(sum) ')'],'VerticalAlignment','bottom','HorizontalAlignment','right');
        elseif strcmp(integrate,'Up') | strcmp(integrate,'up')
            plot(xmaxx,zmaxz,'k*');
            text(xmaxx,zmaxz,['vol (' num2str(sum) ')'],'VerticalAlignment','bottom','HorizontalAlignment','right');
        end

        
        choice = questdlg('Is the result what you have expected?', 	'Aceptar imagen','Yes', 'No (Repeat)','Finish','-');
        if strcmp(choice,'Yes') | strcmp(choice,'')
            fin=1;
        elseif strcmp(choice,'Finish')
            disp('End');
            close all;
            return
        end

    end  
end
