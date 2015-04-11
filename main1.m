%---------------------------INITIALIZATION---------------------------------
intp_fxDEM = zeros(1000,1000);
intp_fyDEM = zeros(1000,1000);
fxPGM = zeros(1000,1000);
fyPGM = zeros(1000,1000);
outDEM = zeros(1000,1000);
DEM2 = zeros(1000,1000);
%-----------------------------OPEN FILES-----------------------------------
clear;
%fid = fopen('input1.raw');
%fid = fopen('input2.raw');
%fid = fopen('input3.raw');
fid = fopen('input4.raw');
DEM = fread(fid,[500 500],'float32');
fclose(fid);
DEM = DEM';

%PGM = imread('input1.pgm');
%PGM = imread('input2.pgm');
%PGM = imread('input3.pgm');
PGM = imread('input4.pgm');
%----------------------------GET GRADIENT----------------------------------
[fxDEM, fyDEM] = gradient(DEM);
%--------------------------------------------------------------------------
for i=1:1000
    for j=1:1000
        intp_fxDEM(i,j) = fxDEM(ceil(i/2),ceil(j/2))/2;
        intp_fyDEM(i,j) = fyDEM(ceil(i/2),ceil(j/2))/2;
        DEM2(i,j) = DEM(ceil(i/2),ceil(j/2));
    end
end
for i=1:500
    for j=1:500
        %upper-left
        outDEM(2*i-1,2*j-1) = DEM(i,j) - 0.5*intp_fxDEM(2*i-1,2*j-1) - 0.5*intp_fyDEM(2*i-1,2*j-1);
        %upper-right
        outDEM(2*i-1,2*j) = DEM(i,j) + 0.5*intp_fxDEM(2*i-1,2*j) - 0.5*intp_fyDEM(2*i-1,2*j);
        %lower-left
        outDEM(2*i,2*j-1) = DEM(i,j) - 0.5*intp_fxDEM(2*i,2*j-1) + 0.5*intp_fyDEM(2*i,2*j-1);
        %lower-right
        outDEM(2*i,2*j) = DEM(i,j) + 0.5*intp_fxDEM(2*i,2*j) + 0.5*intp_fyDEM(2*i,2*j);
    end
end

figure;
imagesc(gradient(outDEM));
colormap(gray(256));
colorbar;
axis equal;

figure;
imagesc(gradient(DEM2));
colormap(gray(256));
colorbar;
axis equal;