function y=printpgm(filename)
imagesc(filename);%使用gray生成64阶灰度图
colormap(gray(256));colorbar;
axis equal