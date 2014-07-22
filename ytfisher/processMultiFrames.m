function ims = processMultiFrames(person_name, video_num, numFrames, show)
% function ims = drawForEachFrame(person_name, video_num, numFrames, show)
% person_name: the folder name for the person
% video_num: video number for the given person
% numFrames: (OPTIONAL) the number of frames to use from the video
%                       (default: all)
% show: (OPTIONAL) boolean flag to show (true) or save (false) the images after processing
%                       (default: save/false)

load GMM-Fisher_old.mat
load PCA-SIFT_coeff_old.mat
means = m;
covars = c;
priors = p;
% load gmm4.mat
% load pcaSiftCoeff.mat
% coeff = W;
lmap = randperm(size(means,2));
cmap = rand(512, 3);

% Build the file path to the video directory
video_path = fullfile('/scratch2','cheni','aligned_images_DB',person_name,num2str(video_num));
files = dir(fullfile(video_path,'*.jpg'));

if ~exist('numFrames', 'var') || numFrames > size(files,1)
    disp(['Using all video frames: ',num2str(size(files,1))]);
    numFrames = size(files,1);
end

if ~exist('show', 'var')
    show = 0;
end

if ~show
    processed_path = fullfile('/scratch2','cheni','processed',person_name,num2str(video_num));
    mkdir(processed_path);
end

ims = zeros(150, 150, numFrames);
% ims = cell(0,numFrames);

gmmobj = gmdistribution(means', reshape(covars, [1, size(covars,1), size(covars,2)]), priors');

for f=1:numFrames
    disp(['Frame: ',num2str(f),'/',num2str(numFrames)]);
    img = imread(fullfile(video_path, files(f).name));
    sr = round((size(img,1)-150)/2);
    sc = round((size(img,2)-150)/2);
    img = img(sr:sr+149, sc:sc+149, :);
    % tic;
    % cimg = drawColorRegions(img, m, c, p, coeff, lmap);
    cimg = drawColorRegionsFast(img, gmmobj, coeff, lmap);
    % toc;
    % ims{f} = cimg;
    ims(:,:,f) = cimg;
    if show
        imagesc(cimg);
        drawnow;
    else
	cimg = ind2rgb(cimg, cmap);
        %imwrite(cimg, fullfile(processed_path,files(f).name), 'jpg');
    end
end

save('ims.mat','ims');

