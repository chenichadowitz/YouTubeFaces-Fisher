
% Load and parse the splits text file
fid = fopen('splits.txt');
C = textscan(fid, '%d %d %s %s %d', 'Delimiter', ',', 'HeaderLines', 1);
fclose(fid);

% Path to data
data_path = fullfile('/scratch2','cheni','aligned_images_DB');

split_same = cell(10,2);
split_diff = cell(10,2);

for splitNum=1:10
    disp(['Split #', num2str(splitNum)]);
    same1 = cell(250, 1);
    same2 = cell(250, 1);
    for sameNum=1:250
        lineNum = (splitNum-1)*500 + sameNum;
        same1{sameNum} = readVideoFrames(fullfile(data_path, C{3}(lineNum)));
        same2{sameNum} = readVideoFrames(fullfile(data_path, C{4}(lineNum)));
    end
    split_same{splitNum, 1} = same1;
    split_same{splitNum, 2} = same2;

    diff1 = cell(250, 1);
    diff2 = cell(250, 1);
    for diffNum=1:250
        lineNum = (splitNum-1)*500 + diffNum + 250;
        diff1{diffNum} = readVideoFrames(fullfile(data_path, C{3}(lineNum)));
        diff2{diffNum} = readVideoFrames(fullfile(data_path, C{4}(lineNum)));
    end
    split_diff{splitNum, 1} = diff1;
    split_diff{splitNum, 2} = diff2;
end
