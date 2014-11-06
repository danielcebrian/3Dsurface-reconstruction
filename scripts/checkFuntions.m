function [ichecking] = checkFuntions(checkings)


if (~exist('checklocal','var'))
    checklocal=checkings;
    for ichecking=1:length(checklocal)
        checking=checklocal(ichecking);
        %Check curves
        if strcmp(checking,'init')
            if(~exist('inizialized','var'))
                init
            end
        elseif strcmp(checking,'curves')
            noCurves=false;
            for iens = 1:length(scases)
                if(~isfield(scases(iens),'curves'))
                    noCurves=true;
                end
            end
            if(noCurves)
                CalculateCurves
            end
        elseif strcmp(checking,'patternZ')
            if(~exist('Zplane','var'))
                patternZ
            end
        elseif strcmp(checking,'patternXY')
            if(~isfield(pattern1,'data'))
                patternXY
            end
        elseif strcmp(checking,'flatplate')
            if(~exist('sflatplate','var'))
                flatplate
            end
        end
    end

    clearvars checklocal
else
    for iind=1:length(checkings)
        ind=find(ismember(checklocal,checkings(iind)));
        if isempty(ind)
            checking=checkings(iind);
            %Check curves
            if strcmp(checking,'init')
                if(~exist('inizialized','var'))
                    init
                end
            elseif strcmp(checking,'curves')
                noCurves=false;
                for iens = 1:length(scases)
                    if(~isfield(scases(iens),'curves'))
                        noCurves=true;
                    end
                end
                if(noCurves)
                    CalculateCurves
                end
            elseif strcmp(checking,'patternZ')
                if(~exist('Zplane','var'))
                    patternZ
                end
            elseif strcmp(checking,'patternXY')
                if(~isfield(pattern1,'data'))
                    patternXY
                end
            elseif strcmp(checking,'flatplate')
                if(~exist('sflatplate','var'))
                    flatplate
                end
            end
        end
    end
end
end
