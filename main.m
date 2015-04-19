function result = main(M)
    %M = abs(rand(1000,1000));
    result = zeros(1000); 
    
    % x from 18 to 982
    % y from 18 to 982
    table = RotationLookupTable();
    
    for x = 18:982
        disp('Currently process Row:');
        disp(x)
        
        for y = 18:982
            result(x,y) = check_landing(M, x, y, table);
        end
    end
end


function result=check_landing(m,x,y,table)

	% check if touch the bottom	
	% check if angle smaller than 10
    center = [x,y];
    ifOk = true;
    
    for i = 1:16
        tmp = table(:,i);
        tmp = tmp';
    
        [a, b, c, d, e, f, g, h] = get_real(tmp, x, y);
        ifOk = checkAll(m, center, [ round(a), round(b), round(c), round(d), round(e), round(f), round(g), round(h)]);
        
        if (ifOk == false)
            break;
        end
    end

    if(ifOk == true)
    	result = 1;
    else
    	result = 0;
    end
end

function ok=checkAll(m, center, listxy)
    %get center point
    x = center(1);
    y = center(2);
    target = [center(1), center(2), m(x,y)];
    
    %get the highest four points that decide the feet
    [p1x,p1y,p1z] = getFiveCircleMax(m,listxy(1),listxy(2));
    [p2x,p2y,p2z] = getFiveCircleMax(m,listxy(3),listxy(4));
    [p3x,p3y,p3z] = getFiveCircleMax(m,listxy(5),listxy(6));
    [p4x,p4y,p4z] = getFiveCircleMax(m,listxy(7),listxy(8));
    
    p1 = [p1x,p1y,p1z];
    p2 = [p2x,p2y,p2z];
    p3 = [p3x,p3y,p3z];
    p4 = [p4x,p4y,p4z];
    
    %get the highest three points that decide the plane
    %these three points are arguments along the center point
    [a1,a2,a3]=getMaxThree(p1,p2,p3,p4);
    
    
    %get the function parameters
    [A, B, C, D] = plane_function(a1, a2, a3);
    plane_parameters = [A, B, C, D];
    
    
    %two tests of the landing condition
    if_big_angle = checkAngle(plane_parameters);
    
    if (if_big_angle == false)
        if_sth_touch = checkTouchingBottom(m, target, p1, p2, p3, plane_parameters);
        if (if_sth_touch == true)
            ok = false;
            return;
        else
            ok = true;
            return;
        end 
    else
        ok = false;
        return;
    end
    
end


function [A, B, C, D] = plane_function(p1, p2, p3)
    normal = cross(p1 - p2, p1 - p3);
    %get the plane function parameters
    A=normal(1);
    B=normal(2);
    C=normal(3);
    D = -(p1(1)*A + p1(2)*B + p1(3)*C);
end


function checkTwo = checkAngle(plane_parameters)
    A = plane_parameters(1);
    B = plane_parameters(2);
    C = plane_parameters(3);
    D = plane_parameters(4);
    
    COSTHETA = abs(C*1)/(sqrt(double(A^2+B^2+C^2)));
    
    checkTwo = false;
    if COSTHETA < cos(pi/10)
        checkTwo = true; % angle is bigger than 10
    end
end


function [nx,ny,nz]=getFiveCircleMax(m,x,y)
    % x,y are coordinates in Matrix m 
    % max_in_circle is the max height of the circle C (radius = 5, center =
    % (x,y));
    
    land = m(x-2:x+2,y-2:y+2);
    land(1,1) = 0;
    land(1,5) = 0;
    land(5,1) = 0;
    land(5,5) = 0;

    nx=0;
    ny=0;
    nz=max(max(land));
    
    for i=1:5
        for j=1:5
            if(land(i,j)==nz)
                nx=x-(3-i);
                ny=y-(3-j);
            end
        end
    end
end

%CHECK(correct, JX)
function [a1,a2,a3]=getMaxThree(p1,p2,p3,p4)
    if((p1(3)+p3(3))>(p2(3)+p4(3)))
        a1 = p1;
        a2 = p3;
        a3 = p2;
        if (p4(3)>p2(3))
            a3 = p4;
        end
    else
        a1 = p2;
        a2 = p4;
        a3 = p1;
        if (p3(3)>p1(3))
            a3 = p3;
        end
    end
end


function ifInDistance=distanceInR(r,x1,y1,x2,y2)
    ifInDistance = r^2 >= (x1-x2)^2+(y1-y2)^2;
end


function if_over_bottom = checkTouchingBottom(m, center, p1, p2, p3, plane_parameters)

    cx = center(1);
    cy = center(2);
    cz = center(3);
    
    if_over_bottom=false;
    
    %get the plane function parameters
    A = plane_parameters(1);
    B = plane_parameters(2);
    C = plane_parameters(3);
    D = plane_parameters(4);
    
    
    for i=cx-17:cx+17
        for j=cy-17:cy+17
            within_bottom = distanceInR(17,i,j,cx,cy);
            if (within_bottom == true)
                dist = abs((A*i+B*j+C*m(i,j)+D)/(sqrt(double(A^2+B^2+C^2))));
                if (dist > 0.39)
                    if_over_bottom=true;
                end
            end
        end
    end
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
    for i = 1:6
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