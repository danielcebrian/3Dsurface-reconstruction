if(exist('paintfp','var'))
    if seeflatplate
        w=sflatplate.width;
        t=sflatplate.thickness;
        d=sflatplate.dist;
        chw=Zplane.channelWidth;
        case1=find(strcmp({sflatplate.cases.name},scases(iens).name)); %find the case1 in the flat plate database for retrieve the angle and height
        angle=deg2rad(sflatplate.cases(case1).angle);
        height=sflatplate.cases(case1).height;
        
        maxx=d+sin(angle)*w/2;
        minx=d-sin(angle)*w/2;
        maxz=chw/2+cos(angle)*w/2;
        minz=chw/2-cos(angle)*w/2;
        miny=height;
        maxy=height+w;
        if dimensionless
            w=w/dimensionless;
            t=t/dimensionless;
            d=d/dimensionless;
            chw=chw/dimensionless;
            height=height/dimensionless;
            maxx=maxx/dimensionless;
            minx=minx/dimensionless;
            maxz=maxz/dimensionless;
            minz=minz/dimensionless;
            miny=miny/dimensionless;
            maxy=maxy/dimensionless;
        end
        if strcmp(paintfp,'3D')
            [Y Z] = meshgrid(linspace(miny,maxy,5),linspace(minz,maxz,5));

            X=tan(angle)*(chw/2-Z)+d;
            m=mesh(X-t/2*cos(angle),Z-t/2*sin(angle),Y,0,'FaceLighting','phong','facecolor','none','LineWidth',1.5,'EdgeColor','black','LineStyle','--');
            m=mesh(X+t/2*cos(angle),Z+t/2*sin(angle),Y,0,'FaceLighting','phong','facecolor','none','LineWidth',1.5,'EdgeColor','black','LineStyle','--');
        elseif strcmp(paintfp,'2D')
            %rectangle('Position',[x,y,w,h])
            rectangle('Position',[minx,miny,(maxx-minx),(maxy-miny)],'LineStyle','--')
        elseif strcmp(paintfp,'Contour')
            line([minx-t/2*cos(angle) maxx-t/2*cos(angle)],[maxz-t/2*sin(angle) minz-t/2*sin(angle)],'LineStyle','--','Color','w');
            line([minx+t/2*cos(angle) maxx+t/2*cos(angle)],[maxz+t/2*sin(angle) minz+t/2*sin(angle)],'LineStyle','--','Color','w');

        end
    end
end
