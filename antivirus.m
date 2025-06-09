clc;
clear all;

jsonrulesfolder = 'tlsh';
ruleslist = dir(fullfile(jsonrulesfolder, '*.json'));
signatures = {};

for k = 1:length(ruleslist)
    rawofrules = fileread(fullfile(jsonrulesfolder, ruleslist(k).name));
    data = jsondecode(rawofrules);
    signatures{end+1} = upper(data.tlsh);
end

malwarefolder = 'testfiles';
folderfiles = dir(fullfile(malwarefolder, '*.*'));
folderfiles = folderfiles(~[folderfiles.isdir]);

numberoffilesindirectory = length(folderfiles);
if numberoffilesindirectory == 0
    error('Malware directory is empty');
end

numberofmalwaresignatures = length(signatures);

results(numberoffilesindirectory) = struct('Filename', '', 'Matches', false(1, numberofmalwaresignatures), 'MatchedSignatures', {{}}, 'MatchCount', 0);

parfor i = 1:numberoffilesindirectory
    filepath = fullfile(malwarefolder, folderfiles(i).name);
    fid = fopen(filepath, 'rb');
    if fid == -1
        warning('Error in opening: %s', filepath);
        continue;
    end
    bytes = fread(fid, inf, '*uint8');
    fclose(fid);

    hexstring = upper(join(arrayfun(@(b) dec2hex(b,2), bytes, 'UniformOutput', false), ''));

    matchedflags = false(1, numberofmalwaresignatures);
    matchedsignatures = cell(1, numberofmalwaresignatures);
    matchidx = 0;

    for j = 1:numberofmalwaresignatures
        if contains(hexstring, signatures{j})
            matchedflags(j) = true;
            matchidx = matchidx + 1;
            matchedsignatures{matchidx} = signatures{j};
        end
    end

    matchedsignatures = matchedsignatures(1:matchidx);

    results(i).Filename = folderfiles(i).name;
    results(i).Matches = matchedflags;
    results(i).MatchedSignatures = matchedsignatures;
    results(i).MatchCount = sum(matchedflags);
end

T = struct2table(results);
for i = 1:height(T)
    if isempty(T.MatchedSignatures{i})
        T.MatchedSignatures{i} = 'It is safe file';
    else
        T.MatchedSignatures{i} = strjoin(T.MatchedSignatures{i}, ', ');
    end
end
disp(T(:, {'Filename', 'MatchCount', 'MatchedSignatures'}));