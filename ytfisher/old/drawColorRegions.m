function color_img = drawColorRegions(img, m, c, p, coeff, cmap)

%% Create the Fisher encoding for the input image
    %G = single(zeros(128,0));%single(zeros(128,26261));
    %pos = single(zeros(2,0));%single(zeros(2,26261));
    
    %encoding = getFisherEnc(img, G, pos, m, c, p, coeff);
    
    new_image=rgb2gray(img); 
        
    %resize to 160x125
    new_image = imresize(new_image,[160 125]);

    %convert to single precision
    single_image=im2single(new_image);

    % the [f, d] matrices represent the frames 
    % and descriptor matrices
    % d is 128xn

    % Over 5 scales
    %for j = 1:5
          [f, d] = vl_dsift(single_image, 'step', 1, 'size', 6) ;
          d = single(d);
          % f(1,:) goes from 10 - 116 (instead of 1 - 125)
          % f(2,:) goes from 10 - 151 (instead of 1 - 160)
    %      pos(:, (j-1)*size(f,2)+1 : j*size(f,2) ) = f;
    %      single_image = imresize(single_image, 1/sqrt(2));
    %end

    %% Dimension reduction of SIFT using PCA
    d_64 = coeff' * d;
    D = cat(1,d_64,f);
    
    %% Calculate the probabilities and use the max to indicate what cluster label should apply
    color_img = zeros(size(new_image));
    
    weight = -33 * log(2*pi);
    for i=1:size(D,2)
        P = zeros(size(m,2),1);
        for j=1:size(m,2)
            xu = D(:,i) - m(:,j);
            %weight - 
            P(j) = 0.5*log(sum(c(:,j))) - 0.5 * (xu .* 1./c(:,j))' * xu;
        end
        %disp([num2str(i),'/',num2str(size(D,2))]);
        [Y I] = max(P);
        color_img(D(66,i), D(65,i)) = cmap(I);
    end
    