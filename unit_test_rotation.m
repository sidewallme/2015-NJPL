function table = unit_test_rotation()
    table = RotationLookupTable();

end

function [x1, y1, x2, y2, x3, y3, x4, y4] = rotation(x, y, theta)

%{
............x2,y2.........
..........................
....x3,y3....x,y.....x1,y1
..........................
............x4,y4.........
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


function table = RotationLookupTable()
    table = zeros(8,16);
    for i = 1:7
        [x1, y1, x2, y2, x3, y3, x4, y4] = rotation(0, 0, i*pi/12);
        table(:,i) = [x1, y1, x2, y2, x3, y3, x4, y4]';
    end
end


function [x1, y1, x2, y2, x3, y3, x4, y4] = get_real(tmp, x, y)
    x1 = tmp(1) + x;
    y1 = tmp(2) + y;
    x2 = tmp(3) + x;
    y2 = tmp(4) + y;
    x3 = tmp(5) + x;
    y3 = tmp(6) + y;
    x4 = tmp(7) + x;
    y4 = tmp(8) + y;
end