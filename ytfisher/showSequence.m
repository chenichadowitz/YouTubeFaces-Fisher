function [] = showSequence(ims, person_name, video_num, numFrames, t)
% Input: ims - a cell array where each cell is a 160x125 indexed image
    video_path = fullfile('..','ytdb','aligned_images_DB',person_name,num2str(video_num));
    files = dir(fullfile(video_path,'*.jpg'));
    if ~exist('numFrames', 'var') || numFrames > size(files,1)
        disp(['Using all video frames: ',num2str(size(files,1))]);
        numFrames = size(files,1);
    end
    
    disp('Preloading frames...');
    imgs = cell(size(ims));
    for f=1:numFrames
        imgs{f} = imresize(imread(fullfile(video_path, files(f).name)), [160, 125]);
    end
        
    
    %cmap = rand(512, 3);
    %colormap(cmap);
    % SHOULD GENERATE ALPHA MAP BASED ON A PARTICULAR CLUSTER INDEX
    for f=1:numFrames
        disp(['Frame: ',num2str(f),'/',num2str(numFrames)]);
        img = imgs{f};
        image(img);
        hold on;
        %h = image( ind2rgb(ims{f}, cmap) );
        h = imagesc( ims(f) );
        set(h, 'AlphaData', .2);
        %saveas(h, fullfile('test',strcat(num2str(f), '.png')));
        hold off;
        drawnow;
        pause(t);
    end
end