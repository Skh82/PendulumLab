%% A Function for Animating Every Main Part of the Chariot and Pendulumn
function BodyAnimator2(x, y, thetaa, theta1,theta2, L1,L2,theta1_dot,theta2_dot, x_dot,oo,jj,cl,delta1,delta2,delta3,cll,x1,y1,final_color)
    %% Drawing The Pendulum

    C1 = cos(-pi/3-theta1+pi/2);  C2 = cos(theta1);  C3 = cos(3*pi/2-pi/6-theta1+pi/2);
    S1 = sin(-pi/3-theta1+pi/2);  S2 = sin(theta1);  S3 = sin(3*pi/2-pi/6-theta1+pi/2);
    Owx = [x+ 0.06*C1,x+0.06*C1+L1*C2,x+0.06*C3+L1*C2,x+0.06*C3];
    Owy = [y+.1-0.06*S1,y+.1-0.06*S1+L1*S2,y+.1-0.06*S3+L1*S2,y+.1-0.06*S3];

    bettta = -pi/3-theta1+pi/2:.2:3*pi/2-pi/6-theta1+pi/2; bettta = bettta(end:-1:1);
    x_arc = x + 0.06 * cos(bettta);
    y_arc = y+.1 - 0.06 * sin(bettta);
    insert_index = 1; % Index where the arc will be inserted
    Owx = [Owx(1:insert_index-1), x_arc, Owx(insert_index:end)];
    Owy = [Owy(1:insert_index-1), y_arc, Owy(insert_index:end)];

    C11 = cos(-pi/3-theta2+pi/2);  C22 = cos(theta2);  C33 = cos(3*pi/2-pi/6-theta2+pi/2);
    S11 = sin(-pi/3-theta2+pi/2);  S22 = sin(theta2);  S33 = sin(3*pi/2-pi/6-theta2+pi/2);
    Owx2 = [x+ 0.06*C11+L1*cos(theta1),x+0.06*C11+L2*C22+L1*cos(theta1),x+0.06*C33+L2*C22+L1*cos(theta1),x+0.06*C33+L1*cos(theta1)];
    Owy2 = [y+.1-0.06*S11+L1*sin(theta1),y+.1-0.06*S11+L2*S22+L1*sin(theta1),y+.1-0.06*S33+L2*S22+L1*sin(theta1),y+.1-0.06*S33+L1*sin(theta1)];

    bettta = -pi/3-theta2+pi/2:.2:3*pi/2-pi/6-theta2+pi/2; bettta = bettta(end:-1:1);
    x_arc = x + 0.06 * cos(bettta)+L1*cos(theta1);
    y_arc = y+.1 - 0.06 * sin(bettta)+L1*sin(theta1);
    insert_index = 1; % Index where the arc will be inserted
    Owx2 = [Owx2(1:insert_index-1), x_arc, Owx2(insert_index:end)];
    Owy2 = [Owy2(1:insert_index-1), y_arc, Owy2(insert_index:end)];

    bettta = -pi/3-theta2+pi/2+pi:.2:3*pi/2-pi/6-theta2+pi/2+pi; bettta = bettta(end:-1:1);
    x_arc = L1*cos(theta1)+x +(L2+.128)*cos(theta2)+ 2 * 0.04*cos(bettta);
    y_arc = L1*sin(theta1)+y+.1+(L2+.128)*sin(theta2) - 2 * 0.04 * sin(bettta);
    insert_index = 30; % Index where the arc will be inserted
    Owx2 = [Owx2(1:insert_index-1), x_arc, Owx2(insert_index:end)];
    Owy2 = [Owy2(1:insert_index-1), y_arc, Owy2(insert_index:end)];

    %% Space For Right Wheel
    betta = 0:.2:pi+0.2;
    xh = x - 0.5;
    yh = y;
    Pwx=[xh, xh, xh+0.25/3,xh+0.25/1.5, xh+1.25/2, xh+1.5/2, xh+2/2, xh+2/2, xh+2/2+0.03 , xh+2/2+0.03    ,xh+2/2, xh-0.012];
    Pwy=[yh, yh+0.5/2,yh+0.5/2, yh+1/2, yh+1/2, yh+0.5/2, yh+0.5/2, yh+0.5/6, yh+0.5/6 , yh    ,yh,yh+0.007];
    x_arc = xh+0.80 + 0.128 * cos(betta);
    y_arc = yh + 0.128 * sin(betta);
    insert_index = 12; % Index where the arc will be inserted
    Pwx = [Pwx(1:insert_index-1), x_arc, Pwx(insert_index:end)];
    Pwy = [Pwy(1:insert_index-1), y_arc, Pwy(insert_index:end)];

    %% Space For Left Wheel
    betta = -0.1:.2:pi+.1;
    x_arc = xh+0.20 + 0.128 * cos(betta);
    y_arc = yh + 0.128 * sin(betta);
    insert_index =29; % Index where the arc will be inserted
    Pwx = [Pwx(1:insert_index-1), x_arc, Pwx(insert_index:end)];
    Pwy = [Pwy(1:insert_index-1), y_arc, Pwy(insert_index:end)];

    %% Animating The Ground (Idea form Flappy Bird Game)
    % This consumes most of the resources, comment this part for better
    % performance and cause less lag
    Pwwx=[x-4, x+2.1,x+2.1,x-4];
    Pwwy=[y-.105, y-.105,y-.105-.17,y-.105-.17];
    Pwwxx=[x-4, x+2.1,x+2.1,x-4,];
    Pwwyy=[y-.105-0.17, y-.105-0.17,y-.105-3,y-.105-3];
    Pswwx=[x-4, x+2.1,x+2.1,x-4,];
    Pswwy=[y-.105, y-.105,y-.105+6,y-.105+6];
    fill(Pwwx, Pwwy, [0, 200, 0] / 255)
    for j=floor((x-3) / .33)+1.5:floor((x+3) / .33)-2
        Ppwwx=[j/3, j/3+0.165,j/3,j/3-0.165,j/3];
        Ppwwy=[0-.11, 0-.11,0-.11-0.3,0-.11-0.3,0-.11];
        plot(Pwx, Pwy, 'Color',[0, 255, 0] / 255);
        fill(Ppwwx, Ppwwy, [0, 255, 0] / 255)
    end  % Note that the Lines will only appear when they are in range
    plot(Pwwx, Pwwy, 'Color',[165, 42, 42]/255,LineWidth=5);
    fill(Pwwxx, Pwwyy, [255, 228, 196] / 255)
    fill(Pswwx, Pswwy, [173, 216, 230] / 255)
    
    %% Animating Wheels and the Body
    plot(Pwx, Pwy, 'k-',LineWidth=5);
    fill(Pwx, Pwy, [0, 0, 139] / 255);
    Phwx=[xh+0.25/3,xh+0.25/1.5, xh+1.25/2, xh+1.5/2+0.05,xh+0.25/3];
    Phwy=[yh+0.5/2+0.012, yh+1/2, yh+1/2, yh+0.5/2+0.012,yh+0.5/2+0.012];
    Pzxx=[xh+1.5/2+0.15,xh+1.5/2+0.25,xh+1.5/2+0.25,xh+1.5/2+0.15,xh+1.5/2+0.15];
    Pzyy=[yh+0.5/2+0.008,yh+0.5/2+0.008,yh+0.5/2-0.05,yh+0.5/2-0.05,yh+0.5/2+0.008];
    plot(Phwx, Phwy, 'k-',LineWidth=5);
    fill(Phwx, Phwy, [135, 206, 250] / 255);
    P2zxx=[xh+1.5/2+0.15-1+0.1,xh+1.5/2+0.25-1+0.1,xh+1.5/2+0.25-1+0.1,xh+1.5/2+0.15-1+0.1,xh+1.5/2+0.15-1+0.1];
    P2zyy=[yh+0.5/2+0.008,yh+0.5/2+0.008,yh+0.5/2-0.05,yh+0.5/2-0.05,yh+0.5/2+0.008];
    if x_dot < 0
        fill(P2zxx, P2zyy, 'yellow');
        fill(Pzxx, Pzyy, [255, 0, 0] / 255);
    else
        fill(P2zxx, P2zyy, [255, 0, 0] / 255);
        fill(Pzxx, Pzyy, 'yellow');
    end
    plot(P2zxx, P2zyy, 'k-',LineWidth=2);
    plot(Pzxx, Pzyy, 'k-',LineWidth=2);

    plot([xh+2/6,xh+2/6],[yh+0.5/2, yh+0.5],'color', 'black', 'LineWidth', 3)
    beta=0:.1:2*pi+0.1;   xc=0.04*cos(beta);   yc=0.04*sin(beta);
    C1 = cos(thetaa);  C2 = cos(thetaa+pi/3);  C3 = cos(thetaa+2*pi/3);
    S1 = sin(thetaa);  S2 = sin(thetaa+pi/3);  S3 = sin(thetaa+2*pi/3);
    x_arc = x-.3 + 0.095*cos(beta);
    y_arc = y + 0.095 * sin(beta);
    plot(x_arc, y_arc, 'k-',LineWidth=5)
    plot([x-.3-.1*C1,x-.3+.1*C1],[y-.1*S1,y+.1*S1],'k', 'linewidth',2);
    plot([x-.3-.1*C2,x-.3+.1*C2],[y-.1*S2,y+.1*S2],'k', 'linewidth',2);
    plot([x-.3-.1*C3,x-.3+.1*C3],[y-.1*S3,y+.1*S3],'k', 'linewidth',2);
    
    x_arc = x+.3 + 0.095*cos(beta);
    y_arc = y + 0.095 * sin(beta);
    plot(x_arc, y_arc, 'k-',LineWidth=5)
    plot([x+.3-.1*C1,x+.3+.1*C1],[y-.1*S1,y+.1*S1],'k', 'linewidth',2);
    plot([x+.3-.1*C2,x+.3+.1*C2],[y-.1*S2,y+.1*S2],'k', 'linewidth',2);
    plot([x+.3-.1*C3,x+.3+.1*C3],[y-.1*S3,y+.1*S3],'k', 'linewidth',2);
    plot(Owx, Owy, 'k-',LineWidth=5);
    fill(Owx, Owy, 'white');
    fill(x+xc,y+.1+yc,'black','linewidth',2);
    if cll
        beta=0:.1:2*pi+0.1;   xc2=0.05*cos(beta);   yc2=0.05*sin(beta);
        fill(x1+xc2,y1+yc2,final_color,'linewidth',2); % Animating the Ball
    end
    plot(Owx2, Owy2, 'k-',LineWidth=5);
    fill(Owx2, Owy2, 'white');
    fill(x+xc+L1*cos(theta1),y+.1+yc+L1*sin(theta1),'black','linewidth',2)
    box on

    %% Setting Labels and Texts
    % ylabel('Y-Position','fontsize',20,'fontweight','bold', 'FontName', 'Times New Roman');
    % xlabel('X-Position','fontsize',20,'fontweight','bold', 'FontName', 'Times New Roman');
    formatted_string = sprintf('%.2f', x_dot);
    formatteds_string = sprintf('%.2f', theta1_dot);
    formatteds2_string = sprintf('%.2f', theta2_dot);
    ff1 = sprintf('%.2f', delta1);
    ff2 = sprintf('%.2f', delta2);
    ff3 = sprintf('%.2f', delta3);
    if cl
        text(x+1+.5*min(oo,1)+0.15-jj/100,y+1.40-0.5,['+(' ff1 ')'],'fontsize',10+jj,'fontweight','bold','Color','red');
        text(x+1+.5*min(oo,1)+0.25-jj/100,y+1.31-0.5,['+(' ff2 ')'],'fontsize',10+jj,'fontweight','bold','Color','red');
        text(x+1+.5*min(oo,1)+0.25-jj/100,y+1.21-0.5,['+(' ff3 ')'],'fontsize',10+jj,'fontweight','bold','Color','red');
    end
    text(x+0.8+.5*min(oo,1),y+1.40-0.5,['V:' formatted_string ' (m/s)'],'fontsize',10,'fontweight','bold');
    text(x+0.8+.5*min(oo,1),y+1.3-0.5,['\omega_1: ' formatteds_string ' (rad/s)'],'fontsize',10,'fontweight','bold');
    text(x+0.8+.5*min(oo,1),y+1.2-0.5,['\omega_2: ' formatteds2_string ' (rad/s)'],'fontsize',10,'fontweight','bold');

end

