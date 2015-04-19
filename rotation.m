function [x1, y1, x2, y2, x3, y3, x4, y4] = rotation(x, y, theta)

%{
0,0...      x2,y2
.
.   x3,y3    x,y    x1,y1
.
            x4,y4
%}
    x_1 = 15;
    x_2 = 0;
    x_3 = -15;
    x_4 = 0;

    y_1 = 0;
    y_2 = -15;
    y_3 = 0;
    y_4 = 15;


    v1 = [cos(theta) sin(theta); sin(theta) -cos(theta)]*[x_1; y_1];
    v2 = [cos(theta) sin(theta); sin(theta) -cos(theta)]*[x_2; y_2];
    v3 = [cos(theta) sin(theta); sin(theta) -cos(theta)]*[x_3; y_3];
    v4 = [cos(theta) sin(theta); sin(theta) -cos(theta)]*[x_4; y_4];

    x1 = v1(1,1) + x;
    x2 = v2(1,1) + x;
    x3 = v3(1,1) + x;
    x4 = v4(1,1) + x;

    y1 = v1(2,1) + y;
    y2 = v2(2,1) + y;
    y3 = v3(2,1) + y;
    y4 = v4(2,1) + y;

end
