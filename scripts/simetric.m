if(~exist('inizialized','var'))
    init
end

%% calculate the simatry plane of the image

filename=pattern1.path;
im=imread(filename);
S=im(:,[size(im,2)-1:-1:1],:);
imwrite(S, filename, 'jpg')

filename=pattern2.path;
im=imread(filename);
S=im(:,[size(im,2)-1:-1:1],:);
imwrite(S, filename, 'jpg')

%         filename=ppatternZ;
%         im=imread(filename);
%         S=im(:,[size(im,2)-1:-1:1],:);
%         imwrite(S, filename, 'jpg')

for iens = 1:length(scases)
    filename=scases(iens).path;
    im=imread(filename);
    S=im(:,[size(im,2)-1:-1:1],:);
    imwrite(S, filename, 'jpg')
    if flatcurves
        filename=scases(iens).flatpath;
        im=imread(filename);
        S=im(:,[size(im,2)-1:-1:1],:);
        imwrite(S, filename, 'jpg')
    end
end

disp('end');
