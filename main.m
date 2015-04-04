function main()
    M = rand(1000,1000);
    result = ones(1000); 
    % x from 17 to 9983
    % y from 17 to 9983
    
    for x = 17: 983
        for y = 17: 983
            result(x,y) = check_landing(x,y)
        end
    end
    
end

function tf=check_landing(m,x,y)

% tf is 0(false) or 1(true)

% check if touch the bottom
% check if angle smaller than 10
    
end

function max_in_circle=getMax(m,x,y)
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
    max_in_circle=max(land_circle(:));
    
end

