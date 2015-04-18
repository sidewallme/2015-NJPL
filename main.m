function result = main()
    M = abs(rand(1000,1000));
    result = zeros(1000); 
    % x from 17 to 9983
    % y from 17 to 9983
    
  
    for x = 18: 982
        for y = 18: 982
            result(x,y) = check_landing(M,x,y);
        end
        if(mod(x,2) == 0)
                disp('Finishing');
                disp(x/964);
        end
    end
    
end

function result=check_landing(m,x,y)

% tf is 0(false) or 1(true)

% check if touch the bottom
% check if angle smaller than 10

    count = 0;
    center = [x,y];
    angle = 20;
    for i=1:18
        theta = angle/360*pi;
        [a,b,c,d,e,f,g,h] = rotation(x, y, theta);
        ifOk = checkAll(m, center, [int8(round(a)),int8(round(b)),int8(round(c)),int8(round(d)),int8(round(e)),int8(round(f)),int8(round(g)),int8(round(h))]);
        
        if (ifOk == true)
            count = count + 1;
        end
        
        angle = angle + 20;
    end
    result=0;
    if(count>=9)
        result=1;
    end
end

function ok=checkAll(m, center, listxy)
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
    %two tests of the landing condition
    if_sth_touch = checkTouching(m, center, a1, a2, a3);
    if_big_angle = checkAngle(a1,a2,a3);
    
    ok = false;
    if ( if_big_angle == false && if_sth_touch == false && if_big_angle == false)
        ok=true;
    end
    
end

function checkOne = checkTouching(m, center, p1, p2, p3)
    x = center(1);
    y = center(2);
    target = [center(1), center(2), m(x,y)];
    checkOne = checkTouchingBottom(m, target, p1, p2, p3);
end

function checkTwo = checkAngle(p1, p2, p3)
    normal = cross(p1 - p2, p1 - p3);
    %get the plane function parameters
    A1=normal(1);
    B1=normal(2);
    C1=normal(3);
    D1 = -(p1(1)*A1 + p1(2)*B1 + p1(3)*C1);
    
    A2=0;
    B2=0;
    C2=1;
    D2=0;
    COSTHETA = abs(A1*A2+B1*B2+C1*C2)/(sqrt(double(A1^2+B1^2+C1^2))*sqrt(double(A2^2+B2^2+C2^2)));
    
    checkTwo = false;
    if COSTHETA < cos(pi/10)
        checkTwo = true; % angle is bigger than 10
    end

end


function [nx,ny,nz]=getFiveCircleMax(m,x,y)
    % x,y are coordinates in Matrix m 
    % max_in_circle is the max height of the circle C (radius = 5, center =
    % (x,y));
    
    %filter=[0 1 1 1 0; 1 1 1 1 1; 1 1 1 1 1; 1 1 1 1 1; 0 1 1 1 0;];
    land = m(int8(x)-2:int8(x)+2,int8(y)-2:int8(y)+2);
    land(1,1)=0;
    land(1,5)=0;
    land(5,1)=0;
    land(5,5)=0;
    %land_circle = land.*filter;
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
    ifInDistance= r^2 <= (x1-x2)^2+(y1-y2)^2;
end

function if_over_bottom = checkTouchingBottom(m, center,p1,p2,p3)

    cx = center(1);
    cy = center(2);
    cz = center(3);
    
    if_over_bottom=false;
    
    normal = cross(p1 - p2, p1 - p3);
    %get the plane function parameters
    A=normal(1);
    B=normal(2);
    C=normal(3);
    D = -(p1(1)*A + p1(2)*B + p1(3)*C);
    
    
    for i=cx-17:cx+17
        for j=cy-17:cy+17
            within_bottom = distanceInR(17,i,j,cx,cy);
            if (within_bottom == true)
                x = i;
                y = j;
                z = m(i,j);
                dist = abs((A*x+B*y+C*z+D)/(sqrt(double(A^2+B^2+C^2))));
                if (dist > 0.39)
                    if_over_bottom=true;
                end
            end
        end
    end
    
end

function [x,y,z]=getXYZ(m,p)
    x=p(1);
    y=p(2);
    z=m(x,y);
end

function [x,y]=getXY(p)
    x=p(1);
    y=p(2);
end

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
