%recursive checkings
if (~exist('checklocal','var'))
    checklocal=checkings;
    numCheckingTot=1;
    checkingdone=[];
else
    for iind=1:length(checkings)
        ind=find(ismember(checklocal,checkings(iind)));
        if isempty(ind)
            checklocal=[checklocal checkings(iind)];
        end
    end
    numCheckingTot=numCheckingTot+1;
end

%Checkings
if ~isempty(find(ismember(checklocal,'init')) ) & isempty(find(ismember(checkingdone,'init')))
    checkingdone=[checkingdone {'init'}];
    if(~exist('inizialized','var'))
        init
    end
end
if ~isempty(find(ismember(checklocal,'patternZ')) ) & isempty(find(ismember(checkingdone,'patternZ')))
    checkingdone=[checkingdone {'patternZ'}];
    if(~exist('Zplane','var'))
        patternZ
    end
end
if ~isempty(find(ismember(checklocal,'patternXY')) ) & isempty(find(ismember(checkingdone,'patternXY')))
    checkingdone=[checkingdone {'patternXY'}];
    if(~isfield(pattern1,'data'))
        patternXY
    end
end
if ~isempty(find(ismember(checklocal,'curves')) ) & isempty(find(ismember(checkingdone,'curves')))
    checkingdone=[checkingdone {'curves'}];
    noCurves=false;
    for iens = 1:length(scases)
        if(~isfield(scases(iens),'curves'))
            noCurves=true;
        end
    end
    if(noCurves)
        CalculateCurves
    end
    noCurves=false;
    for iens = 1:length(scases)
        dattotfile=fullfile(strcat(pdata,scases(iens).name,'.dat'));
        if exist(dattotfile, 'file')==0
            noCurves=true;
        end
    end
    if(noCurves)
        saveCurves
    end
    if seeflatplate & isempty(find(ismember(checklocal,'flatplate')) )
        checklocal=[checklocal {'flatplate'}];
    end
end
if ~isempty(find(ismember(checklocal,'flatplate')) ) & isempty(find(ismember(checkingdone,'flatplate')))
    checkingdone=[checkingdone {'flatplate'}];
    if(~exist('sflatplate','var'))
        flatplate
    end
end

numCheckingTot=numCheckingTot-1;
%the last check
if numCheckingTot==0
    clearvars checklocal numCheckingTot checkings checkingdone;
end
