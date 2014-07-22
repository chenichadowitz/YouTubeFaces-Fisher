function frames = readVideoFrames(video_path)
%% Returns a cell of frames for the specified video path where each frame has been cropped to [150,150]
%% Uses
    files = dir(fullfile(video_path{1},'*.jpg'));
    frames = cell(size(files,1), 1);
    for f=1:size(files,1)
    	fname = fullfile(video_path, files(f).name);
        img = imread(fname{1});
        sr = round((size(img,1)-150)/2);
        sc = round((size(img,2)-150)/2);
        frames{f} = img(sr:sr+149, sc:sc+149, :);
%         frames{f} = imresize(imread(fullfile(video_path, files(f).name)), [150, 155]);
%         frames(:,:,:,f) = imresize(imread(fullfile(video_path, files(f).name)), [160, 125]);
    end
