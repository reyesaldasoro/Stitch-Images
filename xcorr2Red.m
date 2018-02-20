function [c,rMax,cMax,lMax] = xcorr2Red(a,b)
%function [c,rMax,cMax] = xcorr2Red(a,b)

%----- XCORR2RED a Fourier version of a  Two-dimensional cross-correlation.
%----- a,b              are matrices to correlate
%----- c,               is the correlated results and 
%----- rMax, cMax       are the coordinates of the maximum value 
%----- Author: C.C. Reyes-Aldasoro
%----- 7 March 2005

if nargin == 1; 	b = a;    end %c=xcorr2(a,b);    end
%if nargin == 2 	maxDist=b; b = a;           end

[rowsA,colsA,levsA]=size(a);
[rowsB,colsB,levsB]=size(b);

if isa(a,'uint8'); a=double(a); end
if isa(b,'uint8'); b=double(b); end
%%
% meanA = mean(a(:));
% meanB = mean(b(:));
% 
% if meanA>1; a=a-meanA; end
% if meanB>1; b=b-meanB; end


%%
if ((rowsA==rowsB)&(colsA==colsB)&(levsA==levsB))
    b2=b(rowsB:-1:1,colsB:-1:1,levsB:-1:1);
    af=fftshift(fftn(a));
    bf=fftshift(fftn(b2));
    c=fftshift(ifftn(af.*bf));
    [max1,indmax1]=max(abs(c));
    [max2,indmax2]=max(max1);
    if levsA==1
        cMax=indmax2-colsA/2;
        rMax=indmax1(indmax2)-rowsA/2;
    else
        [max3,indmax3]=max(max2);
        lMax=indmax3;
        cMax=indmax2(:,:,indmax3);%-colsA/2;
        rMax=indmax1(:,cMax,indmax3);%-rowsA/2;
        cMax=cMax-colsA/2; rMax=rMax-rowsA/2;
    end
    
    
end

    % tic
% for cRows=-maxDist:maxDist
%     for cCols=-maxDist:maxDist
%         %c(maxDist+1+cRows,maxDist+1+cCols)=sum(sum(a.*circshift(b,[cRows cCols]))) ;
%         
%         indaCI=max(1   , cCols+1   );
%         indaCS=min(colsA, colsA+cCols   );
%         indaRI=max(1   , cRows+1   );
%         indaRS=min(rowsA, rowsA+cRows   );
% 
%         indbCI=max(1   , -cCols+1   );
%         indbCS=min(colsB, colsB-cCols   );
%         indbRI=max(1   , -cRows+1   );
%         indbRS=min(rowsB, rowsB-cRows   );
%         
%         aRed=a(indaRI:indaRS,indaCI:indaCS);
%         bRed=b(indbRI:indbRS,indbCI:indbCS);
%        % [cRows cCols]
%         c(maxDist+1+cRows,maxDist+1+cCols)=sum(sum(aRed.*bRed))/((indaCS-indaCI)*(indaRS-indaRI));
%         
%     end
% end
%     [max1,indmax1]=max(c);
%     [max2,indmax2]=max(max1);
%     xMax=indmax2-1-maxDist; yMax=indmax1(indmax2)-1-maxDist;
%     [xMax yMax]
% 
%     t1=toc
%     
%  tic;   

    
    %    [xMax yMax]
%    t2=toc
    