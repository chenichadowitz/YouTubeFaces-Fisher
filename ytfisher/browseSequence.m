function [] = browseSequence(ims, person_name, video_num, numFrames, useBlur, useAllClusters)
%% Browse a video sequence using the hard-assigned model clusters
%   Input: ims - MAT filename (as a string) containing the processed color 
%                region images
%          person_name - name of the person as used in the path as a string
%                       (e.g. 'Aaron_Eckhart')
%          video_num - the number of the video to use, as used in the path
%          numFrames - the number of frames to use (0: defaults to all)
%          useBlur - flag indicating if we are choosing the clusters using
%                    the average blurred image across all frames (1), or 
%                    the first frame only
%          useAllClusters - show all clusters (as opposed to selecting them
%                           by hand)


    load(ims);

    video_path = fullfile('..','ytdb','aligned_images_DB',person_name,num2str(video_num));
    files = dir(fullfile(video_path,'*.jpg'));
    if numFrames == 0 || ~exist('numFrames', 'var') || numFrames > size(files,1)
        disp(['Using all video frames: ',num2str(size(files,1))]);
        numFrames = size(files,1);
    end
    
    disp('Preloading frames...');
%     imgs = cell(1, numFrames);
    imgs = zeros([size(ims,1), size(ims,2), 3, numFrames]);
    for f=1:numFrames
%         imgs{f} = imresize(imread(fullfile(video_path, files(f).name)), [160, 125]);
%         imgs(:,:,:,f) = imresize(imread(fullfile(video_path, files(f).name)), [160, 125]);
        temp_img = im2double(imread(fullfile(video_path, files(f).name)));
        sr = round((size(temp_img,1)-150)/2);
        sc = round((size(temp_img,2)-150)/2);
        imgs(:,:,:,f) = temp_img(sr:sr+149, sc:sc+149, :);
    end

%     load barbaraWalters_0_imgs.mat;
%     numFrames = size(imgs,4);
    % Compute the average frame for choosing one or more clusters
    avgframe = (sum(imgs,4) / numFrames);% / 255;
    
    if useAllClusters
        % Not selecting clusters - use all of them
        clusterInds = (1:512)';
    else
        fig = figure;
        if useBlur
            imagesc(avgframe);
        else
            imagesc(imgs(:,:,:,1));
        end
        axis on;
        [x, y] = ginput;
        close(fig);
        row = round(y); col = round(x);

        % Compute the most common cluster index at the chosen x,y location
        % if they were chosen on the blur image
        if useBlur
            rows = repmat(row, [size(ims,3),1]);
            cols = repmat(col, [size(ims,3),1]);
            z = repmat(1:size(ims,3), [size(row,1),1]);
            inds = sub2ind(size(ims), rows,cols, z(:));
            vals = ims(inds);
            valsMat = reshape(vals, [size(row,1), size(ims,3)]);
            clusterInds = mode(valsMat, 2);
        else
        % otherwise, just find the cluster index in the first frame at the
        % chosen x,y location
            clusterInds = zeros(size(row,1), 1);
            for i=1:size(row,1)
                clusterInds(i) = ims(row(i), col(i), 1);
            end
        end
    end
    
    %cmap = rand(512, 3);
    %colormap(cmap);
    % SHOULD GENERATE ALPHA MAP BASED ON A PARTICULAR CLUSTER INDEX
    
%     mask = cat(3, ones(size(ims(:,:,1))), zeros(size(ims(:,:,1))), zeros(size(ims(:,:,1))));
    mask = varycolor(size(clusterInds,1));
%     maskRows = 1:size(clusterInds,1);
    fig = figure;
    f = 1;
    
    opacity = 0.25;
    playThrough = 0;
    while 1
%         disp(['Frame: ',num2str(f),'/',num2str(numFrames)]);
        img = imgs(:,:,:,f);
        im = ims(:,:,f);
        [a, b] = ismember(im, clusterInds);
        maskR = zeros(size(im));
        maskG = maskR;
        maskB = maskR;
        maskR(a) = mask(b(a),1);
        maskG(a) = mask(b(a),2);
        maskB(a) = mask(b(a),3);
        clusterIm = cat(3, maskR, maskG, maskB);
        a2 = ~ismember(im, clusterInds);
        im(a2) = 0;
        im(a) = 1;
        h = imagesc(img);
        title(strcat(['Frame: ',num2str(f),' of ', num2str(numFrames)]));
        hold on;
%         im = (ims(:,:,f) == clusterInds);

        h = imagesc( clusterIm );
        if useAllClusters
            im = im * opacity;
        end
        set(h, 'AlphaData', im);
        hold off;
        drawnow;
        figure(fig);
        if playThrough
            f = f+1;
            if f > numFrames
                f = 1;
            end
            pause(0.1);
        else
            w = waitforbuttonpress;
            key = get(fig,'CurrentKey');
            switch lower(key)
                case 'rightarrow'
                    f = min(f+1, numFrames);
                case 'leftarrow'
                    f = max(f-1, 1);
                case 'equal'
                    opacity = min(opacity + 0.05, 1);
                case 'hyphen'
                    opacity = max(opacity - 0.05, 0);
                case 'return'
                    playThrough = 1;
                case 'escape'
                    close(fig);
                    return;
            end
        end
    end
% end