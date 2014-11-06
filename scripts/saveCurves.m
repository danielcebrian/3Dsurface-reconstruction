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


%% Saving resulting points of the curves in a file
disp('Saving resulting points of the curves in a file');
for iens = 1:length(scases)
    dattotfile=fullfile(strcat(pdata,scases(iens).name,'.dat'));
    if flatcurves
        times=2;
        flattotsol = [];
        datflattotfile=fullfile(strcat(pdata,scases(iens).name,'-flat.dat'));
    else  
        times=1;
    end
    totsol = [];
    for iflatplate = 1:times  
        firstY = -1;
        for icur = 1:length(scases(iens).curves)
            if iflatplate==2
                curve=scases(iens).flatcurves(icur);
                fprintf('Calculando flat curve  for %s in the curve %s\n',scases(iens).name,num2str(curve.pos));
            else
                curve=scases(iens).curves(icur); 
                fprintf('Calculating point for %s in the curve %s\n',scases(iens).name,num2str(curve.pos));               
            end
            % im is the projected image with a single line
            im=curve.im_sel_proj;

	    % relacXY is the pixel-mm ratio in the XY plane
            relacXY=curve.relacXY;
	
	    % xsol, ysol and zsol are the set of points for all the curves
            xsol=[];
            ysol=[];
            zsol=[];
	    % errorsol is the error done by the line thick
            errorsol=[];
	    
            firstX = -1; % firstX is the value of the first pixel seen in the x-axis
            relfirstY=-1; % relfirstY is the position of the pixel where y must be 0
            for x = 1:size(im,2)
		% retrieve an array with all the pixels where there is part of the line
                y=find(im(:,x)==1);
                if isempty(y)==0
                    if firstX==-1
			% first time to retrieve an x value
                        firstX=x;
                    end
                    %xsol is added to the array of x values, and calculate x as the different between the origin pixel and the current pixel
                    xsol=[xsol;(x-firstX)*relacXY];
                    %y is calculated with the mean value between the highest y pixel position and the lowest y pixel position
                    y1=min(y);
                    y2=max(y);
                    y=(size(im,1)-mean([y1 y2]))*relacXY;
                    % first curve and value found for y in order to take it as reference and draw the curves for this value.
                    if firstY==-1
                        firstY=y;
                    end
                    if relfirstY==-1
                        relfirstY=firstY-y;
                    end
                    y=y+relfirstY-firstY;
                    ysol=[ysol;y];
                    %zsol is calculated using the position of the current line in the z-axis
                    zsol=[zsol;(curve.pos-1)*Zplane.distZ+Zplane.ZeroPoint];
                    %error
                    error=(y2-y1)/2;
                    errorsol=[errorsol;error*relacXY];
                end
            end
               % --- Create fit "fit 1"
            fo = fitoptions('method','SmoothingSpline','SmoothingParam',.1);
            ft = fittype('smoothingspline');
            % fitting with the mean value
            cf1 = fit(xsol,ysol,ft,fo);
            % fitting with the min and max value
            cf2 = fit([xsol;xsol],[ysol-errorsol;ysol+errorsol],ft,fo);

	    % obtaining the height (y coordinate) from the fitting curve for each x coordinate value
            ysoli=cf2(xsol);
            xyz = [xsol ysoli zsol errorsol];
            

            if iflatplate==2
                flattotsol = [flattotsol;xyz];
            else
                %save(datfile,'xyz','-ascii');
                totsol = [totsol;xyz];
            end
        end
    end
    
    %fix to flat plate
    if flatcurves
        save(datflattotfile,'flattotsol','-ascii');
%         figure
%         mesh(xq,zq,vq);
%         axis equal;
%         hold on
%         %plot3(x,z,y,'o');
%         title(scases(iens).name);
%             figure
%         mesh(xqf,zqf,vqf);
%         axis equal;
%         hold on
%         %plot3(x,z,y,'o');
%         title(scases(iens).name);
    end
    save(dattotfile,'totsol','-ascii');
end
