function ims = processMultiFrames(person_name, video_num, numFrames, show)
% function ims = drawForEachFrame(person_name, video_num, numFrames, show)
% person_name: the folder name for the person
% video_num: video number for the given person
% numFrames: (OPTIONAL) the number of frames to use from the video
%                       (default: all)
% show: (OPTIONAL) boolean flag to show (true) or save (false) the images after processing
%                       (default: save/false)

load GMM-Fisher.mat
load PCA-SIFT_coeff.mat
cmap = randperm(size(m,2));

% Build the file path to the video directory
video_path = fullfile('..','ytdb','aligned_images_DB',person_name,num2str(video_num));
files = dir(fullfile(video_path,'*.jpg'));

if ~exist('numFrames', 'var') || numFrames > size(files,1)
    disp(['Using all video frames: ',num2str(size(files,1))]);
    numFrames = size(files,1);
end

if ~exist('show', 'var')
    show = 0;
end 

if ~show
    processed_path = fullfile('processed',person_name,num2str(video_num));
    mkdir(processed_path);
end

%ims = zeros(160, 125, 3, numFrames);
ims = cell(0, numFrames);

for f=1:numFrames
    disp(['Frame: ',num2str(f),'/',num2str(numFrames)]);
    img = imread(fullfile(video_path, files(f).name));
    cimg = drawColorRegions(img, m, c, p, coeff, cmap);
    ims{f} = cimg;
    if show
        imagesc(cimg);
        drawnow;
    else
        cimg = label2rgb(cimg);
        imwrite(cimg, fullfile(processed_path,files(f).name), 'jpg');
    end
end

