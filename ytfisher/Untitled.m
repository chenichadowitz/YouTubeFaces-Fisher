 load ims_Aaron_Eckhart_150x150
person_name = 'Aaron_Eckhart'; video_num = 0;

    video_path = fullfile('..','ytdb','aligned_images_DB',person_name,num2str(video_num));
    files = dir(fullfile(video_path,'*.jpg'));
    if ~exist('numFrames', 'var') || numFrames > size(files,1)
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
    
    new_image=rgb2gray(imgs(:,:,:,1)); 

    H = 150; % img dimension
    L = 30446; % for 150x150 centered crops on LFW-df

        % convert to single precision
        single_image=im2single(new_image);
        
%         sift_data = single(zeros(128,L)); 
%     pos_data = single(zeros(2,L));
%         
%     G = sift_data;
%     pos = pos_data;
%         for j = 1:5
              [f, d] = vl_dsift(single_image, 'step', 1, 'size', 6) ;
%               G(:, (j-1)*size(d,2)+1 : j*size(d,2) ) = d;
%               pos(:, (j-1)*size(f,2)+1 : j*size(f,2) ) = f;           
%               single_image = imresize(single_image, 1/sqrt(2));
%         end
        
        %normalize x,y values
%         pos = pos./H - 0.5;
        f2 = f./H - 0.5;

%         load gmm4;
%         load pcaSiftCoeff;
%         coeff = W;
load GMM-Fisher_old.mat
load PCA-SIFT_coeff_old.mat
    d_64 = coeff' * single(d);
    D = cat(1,d_64,f2);
%     d_64 = coeff' * single(G);
%     D = cat(1,d_64,pos);
    % vl_fisher -  remove 'fast' for accuracy, 'verbose' for debugging
    % enc = vl_fisher(D, single(means), single(covars), single(priors), 'improved','fast'); 
    
    
    gmmobj = gmdistribution(means', reshape(covars, [1, size(covars,1), size(covars,2)]), priors');
    
    color_img = zeros(size(new_image));
    clusts = cluster(gmmobj, D');
    for i=1:size(D,2)
        color_img(f(1,i), f(2,i)) = clusts(i);%lmap(clusts(i));
    end