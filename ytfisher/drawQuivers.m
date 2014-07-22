function [] = drawQuivers(img, m, c, p, coeff)

%% Create the Fisher encoding for the input image
    G = single(zeros(128,26261));
    pos = single(zeros(2,26261));
    
    encoding = getFisherEnc(img, G, pos, m, c, p, coeff);
    
%% Create the x, y, u, v quiver vectors from the last two dimensions of the encoding
    dimMeans = size(m,1);
    xyuv = zeros(size(encoding, 1)/dimMeans/2, 4);
    for i=1:size(xyuv,1)
        xyuv(i, 1) = m(dimMeans-1,i);
        xyuv(i, 2) = m(dimMeans,i);
        xyuv(i, 3) = encoding((i-1) * dimMeans + dimMeans - 1);
        xyuv(i, 4) = encoding((i-1) * dimMeans + dimMeans);
    end
    
%% Plot the quiver vectors on top of the image
    img_scaled = imresize(img,[160 125]);
    image(img_scaled); hold on;
    quiver(xyuv(:,1), xyuv(:,2), xyuv(:,3), xyuv(:,4));