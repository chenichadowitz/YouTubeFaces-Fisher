function [ xyuv ] = createXYUV( encoding, means )
%extractFisherDxDy
%   Extract the dx, dy components from each individual fisher vector
%   from a strung-out fisher vector
%   So the dx,dy components for the Nth Gaussian cluster is at location
%   (N-1)*130+129 and (N-1)*130+130
    dimMeans = size(means,1);
    xyuv = zeros(size(encoding, 1)/dimMeans/2, 4);
    for i=1:size(xyuv,1)
        xyuv(i, 1) = means(dimMeans-1,i);
        xyuv(i, 2) = means(dimMeans,i);
        xyuv(i, 3) = encoding((i-1) * dimMeans + dimMeans - 1);
        xyuv(i, 4) = encoding((i-1) * dimMeans + dimMeans);
    end

end


