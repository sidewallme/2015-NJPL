clear;
%fid = fopen('terrainS0C0R10_100_dem.raw');%figure1
%fid = fopen('terrainS4C4R20_100-500by500_dem.raw');%figure4
fid = fopen('output.raw');
DEM = fread(fid,[500 500],'float32');
fclose(fid);
DEM = DEM';

n=256;



EDGE = edge(DEM,'roberts');
%a=edge(DEM,'roberts',0.5);
%b=edge(DEM,'roberts',1);
%EDGE2 = a-b;
%EDGE = edge(DEM,'sobel');
%EDGE2 = edge(terrainS4C4R20_100,'roberts');

figure;
imagesc(DEM);
axis equal;
colormap(gray(n));
colorbar;



figure;
imagesc(EDGE);
axis equal;
colormap(gray(2));
colorbar;

%{
figure;
image(x,y,EDGE2);
axis equal;
colormap(gray(2));
colorbar;
%}