person_name= 'Aaron_Eckhart'; video_num= 0; numFrames= 50;

video_path = fullfile('..','ytdb','aligned_images_DB',person_name,num2str(video_num));
    files = dir(fullfile(video_path,'*.jpg'));
imgs = zeros([size(ims,1), size(ims,2), 3, numFrames]);
for f=1:numFrames
%         imgs{f} = imresize(imread(fullfile(video_path, files(f).name)), [160, 125]);
%         imgs(:,:,:,f) = imresize(imread(fullfile(video_path, files(f).name)), [160, 125]);
        temp_img = im2double(imread(fullfile(video_path, files(f).name)));
        sr = round((size(temp_img,1)-150)/2);
        sc = round((size(temp_img,2)-150)/2);
        imgs(:,:,:,f) = temp_img(sr:sr+149, sc:sc+149, :);
    end
imagesc(imgs(:,:,:,1))

m = round(150*(0.5+means(65:66,:)'));
c = round(150*(0.5+covars(65:66,:)'));

colors = varycolor(512);
for i=1:512
    vl_plotframe([m(i,:), c(i,1), 0, c(i,2)], 'Color', colors(i,:));
end

%% Aruni's GMM:
for i=1:512
    vl_plotframe([m(65:66,i)', c(65,i), 0, c(66,i)], 'Color', colors(i,:));
end