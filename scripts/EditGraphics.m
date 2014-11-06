
function [im_bw] = EditGraphics(im_i,modeColor,saveFile)

if(~exist('modeColor','var'))
    modeColor=false;
end
close all;
cc = bwconncomp(im_i, 4);
labeled = labelmatrix(cc);
Lrgb = label2rgb(labeled, @lines, 'c', 'shuffle');
imshow(Lrgb)
set(gcf,'units','normalized','outerposition',[0 0 1 1]);

zoom;
uiwait(msgbox('You may zoom in the area that you want to edit before accept the message'));
choice2 = questdlg('What do you want to do?', 	'Accept the image', 'Draw','Erase','Cancel','-');


if strcmp(choice2,'Draw')
    h=imfreehand
    pos=getPosition(h);
    for i=1:length(pos)
        if i==length(pos)
            disp('end');
        else
            [r,c] = size(im_i);              %# Get the image size
            rpts = linspace(pos(i,2),pos(i+1,2),1000);   %# A set of row points for the line
            cpts = linspace(pos(i,1),pos(i+1,1),1000);   %# A set of column points for the line
            index = sub2ind([r c],round(rpts),round(cpts));  %# Compute a linear index
            im_i(index) = 1;               %# Set the line points to white
        end
    end
elseif strcmp(choice2,'Erase')
    h=imfreehand
    pos=getPosition(h);
    for i=1:length(pos)
        if i==length(pos)
            disp('end');
        else
            [r,c] = size(im_i);              %# Get the image size
            rpts = linspace(pos(i,2),pos(i+1,2),1000);   %# A set of row points for the line
            cpts = linspace(pos(i,1),pos(i+1,1),1000);   %# A set of column points for the line
            index = sub2ind([r c],round(rpts),round(cpts));  %# Compute a linear index
            im_i(index) = 0;               %# Set the line points to white
        end
    end
end
im_bw=im_i;
if(exist('saveFile','var'))
    save(saveFile,'im_bw');
end
if modeColor
    cc = bwconncomp(im_i, 4);
    labeled = labelmatrix(cc);
    Lrgb = label2rgb(labeled, @lines, 'c', 'shuffle');
    imshow(Lrgb)
    set(gcf,'units','normalized','outerposition',[0 0 1 1]);
end

end
