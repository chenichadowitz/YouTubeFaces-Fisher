function [z] = tempfunc(x,y, gmmobj)
    xd = zeros(1,66);
    xd(65:66) = 1;
    z = pdf(gmmobj, xd);