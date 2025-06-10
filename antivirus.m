clc;
clear all;
system = ('python generate_tlsh_hashes.py')
jsonrulesfolder = 'tlsh';
ruleslist = dir(fullfile(jsonrulesfolder, '*.json'));
signatures = {};
for k = 1:length(ruleslist)
    rawofrules = fileread(fullfile(jsonrulesfolder, ruleslist(k).name));
    data = jsondecode(rawofrules);
    signatures{end+1} = upper(data.tlsh);
end
jsonData = fileread('tlshtestfiles.json');
fileHashes = jsondecode(jsonData);
filetlshcontainer = containers.Map();
for i = 1:length(fileHashes)
    filetlshcontainer(fileHashes(i).filename) = upper(fileHashes(i).tlsh);
end
malwarefolder = 'testfiles';
folderfiles = dir(fullfile(malwarefolder, '*.*'));
folderfiles = folderfiles(~[folderfiles.isdir]);
results = struct('Filename', {}, 'TLSH', {}, 'MatchedSignatures', {}, 'HexMatches', {}, 'HexMatchedSignatures', {}, 'HexMatchCount', {});
parfor i = 1:length(folderfiles)
    filename = folderfiles(i).name;
    filepath = fullfile(malwarefolder, filename);
    tempresult = struct(...
        'Filename', filename, ...
        'TLSH', 'UNKNOWN', ...
        'MatchedSignatures', {{}}, ...
        'HexMatches', false(1, length(signatures)), ...
        'HexMatchedSignatures', {{}}, ...
        'HexMatchCount', 0 ...
    );    
    if isKey(filetlshcontainer, filename)
        tempresult.TLSH = filetlshcontainer(filename);
    end    
    matchedSignatures = {};
    for j = 1:length(signatures)
        if strcmp(tempresult.TLSH, signatures{j})
            matchedSignatures{end+1} = signatures{j};
        end
    end
    tempresult.MatchedSignatures = matchedSignatures;    
    fid = fopen(filepath, 'rb');
    if fid == -1
        warning('Error opening: %s', filepath);
        hexstring = '';
    else
        bytes = fread(fid, inf, '*uint8');
        fclose(fid);
        hexstring = upper(join(arrayfun(@(b) dec2hex(b,2), bytes, 'UniformOutput', false), ''));
    end    
    hexmatchedSignatures = {};
    hexmatches = false(1, length(signatures));
    for j = 1:length(signatures)
        if contains(hexstring, signatures{j})
            hexmatches(j) = true;
            hexmatchedSignatures{end+1} = signatures{j};
        end
    end
    tempresult.HexMatches = hexmatches;
    tempresult.HexMatchedSignatures = hexmatchedSignatures;
    tempresult.HexMatchCount = sum(hexmatches);
    results(i) = tempresult;
end

T = struct2table(results);
for i = 1:height(T)
    if isempty(T.MatchedSignatures{i})
        T.MatchedSignatures{i} = 'No TLSH match';
    else
        T.MatchedSignatures{i} = strjoin(T.MatchedSignatures{i}, ', ');
    end    
    if isempty(T.HexMatchedSignatures{i})
        T.HexMatchedSignatures{i} = 'No hex match';
    else
        T.HexMatchedSignatures{i} = strjoin(T.HexMatchedSignatures{i}, ', ');
    end
end
disp(T(:, {'Filename', 'TLSH', 'MatchedSignatures', 'HexMatchCount', 'HexMatchedSignatures'}));
