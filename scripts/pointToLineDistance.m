%% A Function for Calculating the Distance between the Ball and the Pandulumn
function check=pointToLineDistance(point, linePoint1, linePoint2, r,L)
    %% Defining Phase
    x0 = point(1);
    y0 = point(2);
    x1 = linePoint1(1);
    y1 = linePoint1(2);
    x2 = linePoint2(1);
    y2 = linePoint2(2);
    A = y2 - y1;
    B = x1 - x2;
    C = x2 * y1 - x1 * y2;
    distance = abs(A * x0 + B * y0 + C) / sqrt(A^2 + B^2);
    dis1=sqrt((x0-x1)^2+(y0-y1)^2);
    dis2=sqrt((x0-x2)^2+(y0-y2)^2);

    %% Checking Phase
    if distance<=r && dis1<L && dis2<L
        check=true;
    else
        check=false;
    end