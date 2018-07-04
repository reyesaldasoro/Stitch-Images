function  finalRes4 = stitch4Images(Q1,Q2,Q3,Q4)
%function  finalRes4 = stitch4Images(Q1,Q2,Q3,Q4)
%---------------------------------------------------------------------------------
% A function to stitch automatically four quadrants into a single image. The
% quadrants are located as follows 1-NW, 2-NE, 3-SE, 4-SW. The top two quadrants are
% stitched first, then the bottom two are stitched, and the resulting top and bottom
% are stitched together.
%  A longer description of the algorithm including intermediate steps can be found in the book:
% 
% Biomedical image analysis recipes in MATLAB: for life scientists and engineers,
% CC Reyes-Aldasoro
% John Wiley & Sons. 
%---------------------------------------------------------------------------------

if nargin ==0
    Q1=double(imread('Q1.bmp'));Q2=double(imread('Q2.bmp'));Q3=double(imread('Q3.bmp'));Q4=double(imread('Q4.bmp'));
end


[rows,cols,levs]        = size(Q1); %#ok<NASGU>
%% Pre process the spurious lines at top / bottom and edges

Q1(1:3,:,:)             = repmat(Q1 (4,:,:),[3 1 1]);
Q1(end-1:end,:,:)       = repmat(Q1 (end-2,:,:),[2 1 1]);
Q1(:,1,:)               = Q1 (:,2,:);
Q1(:,end-1:end,:)       = repmat(Q1 (:,end-2,:),[1 2 1]);

Q2(1:3,:,:)             = repmat(Q2 (4,:,:),[3 1 1]);
Q2(end-1:end,:,:)       = repmat(Q2 (end-2,:,:),[2 1 1]);
Q2(:,1,:)               = Q2 (:,2,:);
Q2(:,end-1:end,:)       = repmat(Q2 (:,end-2,:),[1 2 1]);

Q3(1:3,:,:)             = repmat(Q3 (4,:,:),[3 1 1]);
Q3(end-1:end,:,:)       = repmat(Q3 (end-2,:,:),[2 1 1]);
Q3(:,1,:)               = Q3 (:,2,:);
Q3(:,end-1:end,:)       = repmat(Q3 (:,end-2,:),[1 2 1]);

Q4(1:3,:,:)             = repmat(Q4 (4,:,:),[3 1 1]);
Q4(end-1:end,:,:)       = repmat(Q4 (end-2,:,:),[2 1 1]);
Q4(:,1,:)               = Q4 (:,2,:);
Q4(:,end-1:end,:)       = repmat(Q4 (:,end-2,:),[1 2 1]);





%% Get features from the images as the edges detected by canny

[Q1BW]=edge(Q1(:,:,1),'canny',[],3);
[Q2BW]=edge(Q2(:,:,1),'canny',[],3);
[Q3BW]=edge(Q3(:,:,1),'canny',[],3);
[Q4BW]=edge(Q4(:,:,1),'canny',[],3);

%%
% extend the sizes and place the edges at the centre
QR1                                 = zeros(3*rows,3*cols,levs);
QR2                                 = zeros(3*rows,3*cols,levs);
QR3                                 = zeros(3*rows,3*cols,levs);
QR4                                 = zeros(3*rows,3*cols,levs);

QR1 (rows+1:2*rows,cols+1:2*cols,:) = Q1;
QR2 (rows+1:2*rows,cols+1:2*cols,:) = Q2;
QR3 (rows+1:2*rows,cols+1:2*cols,:) = Q3;
QR4 (rows+1:2*rows,cols+1:2*cols,:) = Q4;

QR1BW                               = zeros(3*rows,3*cols);
%QR2BW                               = zeros(3*rows,3*cols);
QR3BW                               = zeros(3*rows,3*cols);
%QR4BW                               = zeros(3*rows,3*cols);

QR1BW (rows+1:2*rows,cols+1:2*cols) = Q1BW(:,:,1);
%QR2BW (rows+1:2*rows,cols+1:2*cols) = Q2BW(:,:,1);
QR3BW (rows+1:2*rows,cols+1:2*cols) = Q3BW(:,:,1);
%QR4BW (rows+1:2*rows,cols+1:2*cols) = Q4BW(:,:,1);




%% Process the horizontal matches first
QR12BW= zeros(3*rows,3*cols);
QR34BW= zeros(3*rows,3*cols);

[q12,xM12,yM12]=xcorr2Red(Q1BW(:,:,1),Q2BW(:,:,1));
[q34,xM34,yM34]=xcorr2Red(Q3BW(:,:,1),Q4BW(:,:,1));

xM12 = round(xM12);
yM12 = round(yM12); 
xM34 = round(xM34); 
yM34 = round(yM34); 

%% Shift the horizontal matches
%surfdat(QR1BW+circshift(QR2BW*2,[xM12 yM12]));
%surfdat(QR3BW+circshift(QR4BW*2,[xM34 yM34]));

QR2 = circshift(QR2,[xM12 yM12]);
QR4 = circshift(QR4,[xM34 yM34]);


%%
QR12BW (rows+1+xM12:2*rows+xM12,  cols+1+yM12:2*cols+yM12)= Q2BW(:,:,1);
QR34BW (rows+1+xM34:2*rows+xM34,  cols+1+yM34:2*cols+yM34)= Q4BW(:,:,1);

%QR12 (rows+1+xM12:2*rows+xM12,  cols+1+yM12:2*cols+yM12,:)= Q2;
%QR34 (rows+1+xM34:2*rows+xM34,  cols+1+yM34:2*cols+yM34,:)= Q4;


QR_topBW                = QR1BW|QR12BW;
QR_bottomBW             = QR3BW|QR34BW;


%figure(11);  surfdat(QR1BW+2*QR12BW);
%figure(13);  surfdat(QR3BW+2*QR34BW);
%


%% now match the previous results vertically


[q23,xM23,yM23]         = xcorr2Red(QR_topBW,QR_bottomBW);

xM23 = round (xM23);
yM23 = round (yM23);

%QR_bottomBW             = circshift(QR_bottomBW*2,[xM23 yM23]);
%%
QR3 = circshift(QR3,[xM23 yM23]);
QR4 = circshift(QR4,[xM23 yM23]);


%% all quadrants are in place, now mix them!

% indexQ1 = find(QR1);
% indexQ2 = find(QR2);
% indexQ3 = find(QR3);
% indexQ4 = find(QR4);
clear channel*

channel1(:,:,1)     = QR1(:,:,1);
channel1(:,:,2)     = QR2(:,:,1);
channel1(:,:,3)     = QR3(:,:,1);
channel1(:,:,4)     = QR4(:,:,1);

channel2(:,:,1)     = QR1(:,:,2);
channel2(:,:,2)     = QR2(:,:,2);
channel2(:,:,3)     = QR3(:,:,2);
channel2(:,:,4)     = QR4(:,:,2);

channel3(:,:,1)     = QR1(:,:,3);
channel3(:,:,2)     = QR2(:,:,3);
channel3(:,:,3)     = QR3(:,:,3);
channel3(:,:,4)     = QR4(:,:,3);
%% Reduce the dimensions to the edges of the combination

clear finalR*
finalResTot         = sum(channel1>0,3);

[ifR,ifC]           = find(finalResTot>0);
finalResTot         = finalResTot(min(ifR):max(ifR),min(ifC):max(ifC),:);

channel1            = channel1(min(ifR):max(ifR),min(ifC):max(ifC),:);
channel2            = channel2(min(ifR):max(ifR),min(ifC):max(ifC),:);
channel3            = channel3(min(ifR):max(ifR),min(ifC):max(ifC),:);

%%

finalResEdges       = imdilate(edge(finalResTot,'canny'),ones(5));
finalResEdges2       = repmat(imfilter(double(finalResEdges),gaussF(7,7,1)),[1 1 3]);
%%
finalRes(:,:,1)     = (sum(channel1,3)./finalResTot);
finalRes(:,:,2)     = (sum(channel2,3)./finalResTot);
finalRes(:,:,3)     = (sum(channel3,3)./finalResTot);


finalRes2(:,:,1)    = (max(channel1,[],3));
finalRes2(:,:,2)    = (max(channel2,[],3));
finalRes2(:,:,3)    = (max(channel3,[],3));
%%
finalRes3           = round(finalRes.*(1-finalResEdges2) + finalRes2.*(finalResEdges2));



finalRes4(:,:,1)     = imfilter(finalRes3(:,:,1),gaussF(3,3,1));
finalRes4(:,:,2)     = imfilter(finalRes3(:,:,2),gaussF(3,3,1));
finalRes4(:,:,3)     = imfilter(finalRes3(:,:,3),gaussF(3,3,1));


%%
























%stitched4Images =max(QR1,QR12);