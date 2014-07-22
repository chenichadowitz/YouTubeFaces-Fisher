% gauss.m
%   Generates a gaussian vector of specified components
% Written by: M.E.
% Date: June 4th, 2013
% Rev.: 1
%   Normalize values
% Parameters:
%   DIMROW = number of rows
%   DIMCOL = number of cols
% Limitations:
%   DIMROW and DIMCOL must be either both odd or both even
 
function GAUSSFILTER = gauss(SIGMA,DIMROW,DIMCOL)
    if DIMROW == 1
        GAUSSFILTER = zeros(1,DIMCOL);
        for i=1:idiv(DIMCOL,2)
            GAUSSFILTER(i+idiv(DIMCOL,2)+1)=exp(-i^2/(2*SIGMA^2));
            GAUSSFILTER(-i+idiv(DIMCOL,2)+1)=GAUSSFILTER(i+idiv(DIMCOL,2)+1);
        end
        GAUSSFILTER(idiv(DIMCOL,2)+1)=1;
    GAUSSFILTER=GAUSSFILTER/sum(GAUSSFILTER);
    else
        GAUSSFILTER = zeros(DIMROW,DIMCOL);
        if mod(DIMROW,2)==1 & mod(DIMCOL,2)==1  %% Both DIMROW and DIMCOL are odd
           for i=0:idiv(DIMCOL,2)
               for j=0:idiv(DIMROW,2)
                   GAUSSFILTER(i+idiv(DIMCOL,2)+1,j+idiv(DIMROW,2)+1)=exp(-(i^2+j^2)/(2*SIGMA^2));
                   GAUSSFILTER(-i+idiv(DIMCOL,2)+1,-j+idiv(DIMROW,2)+1)=GAUSSFILTER(i+idiv(DIMCOL,2)+1,j+idiv(DIMROW,2)+1);
                   GAUSSFILTER(i+idiv(DIMCOL,2)+1,-j+idiv(DIMROW,2)+1)=GAUSSFILTER(i+idiv(DIMCOL,2)+1,j+idiv(DIMROW,2)+1);
                   GAUSSFILTER(-i+idiv(DIMCOL,2)+1,j+idiv(DIMROW,2)+1)=GAUSSFILTER(i+idiv(DIMCOL,2)+1,j+idiv(DIMROW,2)+1);
               end
            end
        GAUSSFILTER=GAUSSFILTER/sum(sum(GAUSSFILTER));
        elseif mod(DIMROW,2)==0 & mod(DIMCOL,2)==0 %% Both DIMROW and DIMCOL are even
            for i=1:idiv(DIMCOL,2)
               for j=1:idiv(DIMROW,2)
                   GAUSSFILTER(i+idiv(DIMCOL,2),j+idiv(DIMROW,2))=exp(-(i^2+j^2)/(2*SIGMA^2));
                   GAUSSFILTER(-i+idiv(DIMCOL,2)+1,-j+idiv(DIMROW,2)+1)=GAUSSFILTER(i+idiv(DIMCOL,2),j+idiv(DIMROW,2));
                   GAUSSFILTER(i+idiv(DIMCOL,2),-j+idiv(DIMROW,2)+1)=GAUSSFILTER(i+idiv(DIMCOL,2),j+idiv(DIMROW,2));
                   GAUSSFILTER(-i+idiv(DIMCOL,2)+1,j+idiv(DIMROW,2))=GAUSSFILTER(i+idiv(DIMCOL,2),j+idiv(DIMROW,2));
               end
            end
        GAUSSFILTER=GAUSSFILTER/sum(sum(GAUSSFILTER));      
        else
            GAUSSFILTER=-1;
        end
         
    end