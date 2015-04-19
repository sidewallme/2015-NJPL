clear all;
close all;
%---------------------------INITIALIZATION---------------------------------
intp_fxDEM = zeros(1000,1000); % 1000*1000 x-gradient using DEM
intp_fyDEM = zeros(1000,1000); % 1000*1000 y-gradient using DEM
outDEM = zeros(1000,1000); % 1000*1000 interpolated DEM
DEM2 = zeros(1000,1000); % 1000*1000 non-interpolated DEM
nz = ones(1000,1000); % z-component of surface normal vector
fit = zeros(1000,1000); % fit matrix
%-----------------------------OPEN FILES-----------------------------------
fid = fopen('input1.raw');
PGM = imread('input1.pgm');
% shade=39; %input1

% fid = fopen('input2.raw');
% PGM = imread('input2.pgm');
% shade=36; %input2

% fid = fopen('input3.raw');
% PGM = imread('input3.pgm');
% shade=38; %input3

%fid = fopen('input4.raw');
%PGM = imread('input4.pgm');
% shade=41; %input4

DEM = fread(fid,[500 500],'float32');
fclose(fid);
DEM = DEM';
%------------------------GET GRADIENT FROM DEM-----------------------------
[fxDEM, fyDEM] = gradient(DEM);

for i=1:1000
    for j=1:1000
        intp_fxDEM(i,j) = fxDEM(ceil(i/2),ceil(j/2))/2/0.1;
        intp_fyDEM(i,j) = fyDEM(ceil(i/2),ceil(j/2))/2/0.1;
        DEM2(i,j) = DEM(ceil(i/2),ceil(j/2));
    end
end

%----------------------------GET SHADE-------------------------------------
mask = imhist(PGM); % get histogram of input PGM
mask = mask(2:61); % select grayscale from 1 to 60
[xxx,shade]=max(mask); % get shade grayscale

%-------------------------GET GRADIENT FROM PGM----------------------------
fitmax=0; % maximum of fitness
threshold=0.3; % threshold error for z-component of normal vector
% xxx is a temporary variable without certain use

% adaptive re-exposure
for shade1 = shade:1:shade+40
    PGM2 = PGM-shade1;
    PGMmax = max(max(PGM2));
    cosPGM = double(PGM2)./double(PGMmax);
    fit = zeros(1000,1000);
    for i=2:999
        for j=2:999
            if(PGM2(i,j)~=0)
                a = 4*(cosPGM(i,j))^2-1;
                b = 2*sqrt(3)*intp_fxDEM(i,j);
                c = (4*(cosPGM(i,j))^2-3)*(intp_fxDEM(i,j))^2 + 4*(cosPGM(i,j))^2*(intp_fyDEM(i,j))^2;
                delta = b^2-4*a*c;
                if(a==0)
                    xxx = 1;
                else
                    if(delta >= 0)
                        z1 = (-b+sqrt(delta))/(2*a);
                        z2 = (-b-sqrt(delta))/(2*a);
                        if(abs(z1-1) > abs(z2-1))
                            xxx = z2;
                        else
                            xxx = z1;
                        end
                    end
                    if(abs(xxx-1)<threshold)
                        fit(i,j) = 1;
                    else xxx = 1;
                    end
                end
            end
        end
    end
    fitness=mean(mean(fit));
    % find the maximum of fitness
    if(fitness>fitmax)
        fitmax=fitness;
        fitshade=shade1;
    end
end

% get gradient from the re-exposed PGM with the best fitness of shade
% correction
PGM2 = PGM-fitshade;
PGMmax = max(max(PGM2));
cosPGM = double(PGM2)./double(PGMmax);
for i=2:999
    for j=2:999
        if(PGM2(i,j)~=0)
            a = 4*(cosPGM(i,j))^2-1;
            b = 2*sqrt(3)*intp_fxDEM(i,j);
            c = (4*(cosPGM(i,j))^2-3)*(intp_fxDEM(i,j))^2 + 4*(cosPGM(i,j))^2*(intp_fyDEM(i,j))^2;
            delta = b^2-4*a*c;
            if(a==0)
                nz(i,j) = 1;
            else
                if(delta >= 0)
                    z1 = (-b+sqrt(delta))/(2*a);
                    z2 = (-b-sqrt(delta))/(2*a);
                    if(abs(z1-1) > abs(z2-1))
                        nz(i,j) = z2;
                    else
                        nz(i,j) = z1;
                    end
                end
                if(abs(nz(i,j)-1)<threshold)
                    fit(i,j) = 1;
                else nz(i,j) = 1;
                end
            end
        end
    end
end
intp_fyDEM2 = intp_fyDEM./nz;
intp_fxDEM2 = intp_fxDEM./nz;

%----------------------INTERPOLATION BY GRADIENT---------------------------
for i=1:500
    for j=1:500
        %upper-left
        outDEM(2*i-1,2*j-1) = DEM(i,j) - 0.1*0.5*intp_fxDEM2(2*i-1,2*j-1) - 0.1*0.5*intp_fyDEM2(2*i-1,2*j-1);
        %upper-right
        outDEM(2*i-1,2*j) = DEM(i,j) + 0.1*0.5*intp_fxDEM2(2*i-1,2*j) - 0.1*0.5*intp_fyDEM2(2*i-1,2*j);
        %lower-left
        outDEM(2*i,2*j-1) = DEM(i,j) - 0.1*0.5*intp_fxDEM2(2*i,2*j-1) + 0.1*0.5*intp_fyDEM2(2*i,2*j-1);
        %lower-right
        outDEM(2*i,2*j) = DEM(i,j) + 0.1*0.5*intp_fxDEM2(2*i,2*j) + 0.1*0.5*intp_fyDEM2(2*i,2*j);
    end
end
%-----------------------------PRINT FIGURES--------------------------------
figure;
imagesc(gradient(outDEM));
colormap(gray(256));
colorbar;
axis equal;

% figure;
% imagesc(gradient(DEM2));
% colormap(gray(256));
% colorbar;
% axis equal;


figure;
imagesc(PGM2);
colormap(gray(256));
colorbar;
axis equal;

% eff = zeros(1000,1000);
% for i=1:1000
%     for j=1:1000
%         eff(i,j) = dot([-intp_fyDEM2(i,j) -intp_fxDEM2(i,j) 1],[0 sqrt(3) 1]);
%     end
% end
% 
% figure;
% imagesc(eff);
% colormap(gray(256));
% colorbar;
% axis equal;

figure;
imagesc(fit);
colormap(gray(2));
colorbar;
axis equal;