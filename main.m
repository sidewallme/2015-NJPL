function main()
    M = rand(1000,1000);
    result = ones(1000); 
    % x from 17 to 9983
    % y from 17 to 9983
    
    for x = 17: 983
        for y = 17: 983
            result(x,y) = check_landing(M,x,y)
        end
    end
end

function tf=check_landing(m,l,u,r,d)

    left = max_in_circle(m , l(1) , l(2));
    up = max_in_circle(m , u(1) , u(2));
    right = max_in_circle(m , r(1), r(2));
    down = max_in_circle(m , p(1), p(2));
    % tf is 0(false) or 1(true)
    % check if touch the bottom
    % check if angle smaller than 10

    [a1,a2,a3]=
end

function [a1,a2,a3] = get_plane(l,u,r,d)
    if (l+r>u+d)
        a1='l';
        a2='r';
        if u>d
            a3=d;
        end
    else
        a1=u;
        a2=d;
        if l>r
            a3=r;
        end
    end
end

function [x,y]=rotate_next(px,py)

end

function iftouch=check_if_touch(m,x,y,a,b,c,d)

end

function val=max_in_circle(m,x,y)
    % x,y are coordinates in Matrix m 
    % max_in_circle is the max height of the circle C (radius = 5, center =
    % (x,y));
    
    filter=[0 1 1 1 0;
            1 1 1 1 1;
            1 1 1 1 1;
            1 1 1 1 1;
            0 1 1 1 0;];
        
    land=m(x-2:x+2,y-2:y+2);
    land_circle=land.*filter;
    val=max(land_circle(:));
    
end

