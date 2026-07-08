%{
 _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
|                                                                         |
|  Simulation Program: Ball-Pendulum-Chariot Interaction                  | 
|  This program models a ball hitting a pendulum, affecting               |
|  the pendulum's swing and subsequently modifying the chariot's          |
|  movement. Functions simulate the impact on the pendulum                |
|  and update the chariot's motion accordingly, demonstrating the         |
|  interconnectedness between the ball, pendulum, and chariot             |
|  in the simulation loop.                                                |
|                                                                         |
|  Notes:                                                                 |
|  >> The Program runs slow at first try, but itll be smooth afterwards.  |
|     so it is suggested to test the program at the second run.           |                                                            
|  >> The Program is interactive, receiving real-time mouse input.        |
|  >> The Program receives input to define some of the variables.         |
|  >> If you press confirm without inputting the main variables, a set of |
|     pre defined varibles will be automatically inputted instead.        |
|  >> Make sure to read the plot titles in each phase as guides.          |
|  >> The Program stops automatically after a certain period of time.     |
|  >> A few subplots appear in the end for more in-depth analysis.        |
|  >> Feel free to make any changes to the System variables for trials.   |
|  >> The folder contains a few additional files as separate functions.   |
|  >> All files have been organized for improved accessibility.           |
|  >> Read the comments for a better understanding of the code Structure. |
|  >> For troubleshooting or further assistance, refer to the 'README'    |
|     file included in the folder, which contains additional information. |
|  >> It is suggested not to waste time while inputting the varibles in   |
|     the program, it gets a bit laggy for some wierd reason.             |
|  >> Through trials and errors, it was decided to use ode23 instead of   |
|     ode45 in order to reduce the error and increase the accuracy.       |
|                                                                         |
|  Date: 1402/10/20                                                       |
|  Programmer: Soheil Khalesy                                            |
|                           |
|_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _|


%}
function PendulumMovemnetSimulation()
    %% Setting Main figure With Modified Functionalities
    fig = figure;
    set(fig,'WindowState', 'maximized');
    ax = gca(fig);
    set(ax, 'xticklabel', [], 'yticklabel', []);
    box on
    ax = gca;
    ax.LineWidth = 10;
    cll = false;

    %% Setting Up Main Variables needed for Aiming the Ball
    ballPos = [0, 0];
    distance = 0;
    direction = 0;
    aiming = false;
    final_color = 're';
    move1 = false;   move2 = false;
    check3 = false;
    j=0;

    %% Definition of System Elements
    x1(1) = 0; % Initial X Position of the Ball (m)
    y1(1) = 0; % Initial Y Position of the Ball (m)
    Vx1(1) = 0; % Initial X Velocity of the Ball (m/s)
    Vy1(1) = 0; % Initial Y Velocity of the Ball (m/s)
    e = 0; % Coefficient of Restitution The Ball And Pendulum 
    g=9.81; % Gravitational Acceleration (m/s^2)
    M=4; % Mass of Chariot (kg)
    m=1; % Weight of the Extra Mass (kg)
    mA=2; % Mass of Ball (kg)
    L1=0.5;   L2=0.5;   cl = false;
    delta1=0;   delta2=0;   delta3=0;

    %% Defining The rest of The variables
    i = 2;  ii = 1;  oo = 0;  k = 2; % Variables for animating
    thetaa(1)=0;
    % Circle Defintion Used For Plotting the Wheels
    beta=0:.1:2*pi+0.1;xc=0.05*cos(beta);yc=0.05*sin(beta);
    w = 0;
    flag2 = true;  flag = false;
    y(1) = 0; x(1) = 0;
    
    %% Defining some of the varibles in the program based on the user prefernce
    outputt=plotWithInput(fig, @BodyAnimator2,0, 0, 0, -pi/2,-pi/2, L1,0.4,m);
    L1 = min(outputt{1},.5);   L2 = min(outputt{2},.5);   e = min(outputt{7},1);
    ini_theta1 = outputt{3};   ini_theta2 = outputt{4};
    ini_thetadot1 = outputt{5};   ini_thetadot2 = outputt{6};
    set(fig, 'WindowButtonMotionFcn', @mouseMove);
    set(fig, 'WindowButtonDownFcn', @mouseDown);
    set(fig, 'WindowButtonUpFcn', @mouseUp);

    %% Using ode23 for Initial Movement
    g=9.81; m1=5; m2=3; M=10; m=5;
    mp1=0; lp1=0; mp2=0; lp2=0;
    
    dt = 10^-2; % Note that the time step is given a fixed value for a more stable and fluid animation
    tspan= 0:dt:10; % Change the ending time based on your desire
    X0=[0 0 ini_theta1 ini_thetadot1 ini_theta2 ini_thetadot2];
    odefun = @(t, X) mov2(t,X,M, m, g, m1, m2, L1, L2, mp1, lp1, mp2, lp2);
    [~,X] = ode23(odefun,tspan,X0);
    x=X(:,1);
    x_dot=X(:,2);
    theta1=X(:,3);
    theta1_dot=X(:,4);
    theta2=X(:,5);
    theta2_dot=X(:,6);
    w = -x_dot/0.11;

    %% Aiming Algorithm
    function mouseDown(~, ~)
        aiming = true; % Start Aiming
    end
    
    %% Handling Events After Releasing The Ball
    function mouseUp(~, ~)
        if aiming
            %% Turning the fig Back to Normal
            clf(fig);
            set(fig, 'WindowButtonMotionFcn', '');
            set(fig, 'WindowButtonDownFcn', '');
            set(fig, 'WindowButtonUpFcn', '');

            %% Updating the Speed And position Based on The User Direction
            x1(1)=ballPos(1); % Initial X Position of Ball
            y1(1)=ballPos(2); % Initial Y Position of Ball
            Vx1(1)=-distance*cos(direction)*10; % Initial X Velocity of Ball
            Vy1(1)=-distance*sin(direction)*10; % Initial Y Velocity of Ball
            k = 2; % Setting Time Step to Simulate The Ball Movement

            %% Setting Up Main While-Loop
            while i<500
                %% Updating Ball Position And Wheels Based on Speed And Accelartion
                clf(fig);
                y(i) = 0;
                thetaa(i) = thetaa(i-1)+w(i-1)*dt;
                if flag2
                    x1(k) = x1(k-1)+Vx1(k-1)*dt;
                    y1(k) = y1(k-1)+Vy1(k-1)*dt - 1/2*g*dt^2;
                    Vx1(k) = Vx1(k-1);
                    Vy1(k) = Vy1(k-1) -g*dt;
                else
                    if check3, LB = L2+0.125; end

                    if (check1 || check2 || check3)
                        x1(k) = x(i)+L1*cos(theta1(i))+LB*cos(theta2(i));
                        y1(k) = y(i)+.1+L1*sin(theta1(i))+LB*sin(theta2(i));
                    elseif (check11 || check22)
                        x1(k) = x(i)+LA*cos(theta1(i));
                        y1(k) = y(i)+.1+LA*sin(theta1(i));
                    end
                end

                %% Defining Collision Logic
                if ~flag
                    point = [x1(k) y1(k)];
                    linePoint1 = [x(i)+L1*cos(theta1(i)), 0.1+y(i)+L1*sin(theta1(i))];
                    linePoint2 = [x(i)+L1*cos(theta1(i))+(L2+0.04)*cos(theta2(i)), 0.1+y(i)+L1*sin(theta1(i))+(L2+0.04)*sin(theta2(i))];
                    check1=pointToLineDistance(point,linePoint1,linePoint2,.1,L2);
    
                    %% A New Logic for Collision Check (Less Accurate)
                    % refer to README file for more information
                    v1 = [x1(k)-x(i)-L1*cos(theta1(i)), y1(k)-y(i)-0.1-L1*sin(theta1(i))];
                    v2 = [L1*cos(theta1(i))+L2*cos(theta2(i)), L1*sin(theta1(i))+0.1+L2*sin(theta2(i))];
                    cp(i)=v1(1) * v2(2) - v1(2) * v2(1);  
                    check2=(cp(i)*cp(i-1) < 0 && (y(i)+0.1+L1*sin(theta1(i))+L2*sin(theta2(i))<=y1(k)) && (y1(k)<=y(i)+0.1+L1*sin(theta1(i))));

                    point = [x1(k) y1(k)];
                    linePoint1 = [x(i), 0.1+y(i)];
                    linePoint2 = [x(i)+L1*cos(theta1(i)), 0.1+y(i)+L1*sin(theta1(i))];
                    check11=pointToLineDistance(point,linePoint1,linePoint2,.1,L1);

                    %% A New Logic for Collision Check (Less Accurate)
                    % refer to README file for more information
                    v1 = [x1(k)-x(i), y1(k)-y(i)-0.1];
                    v2 = [L1*cos(theta1(i)), L1*sin(theta1(i))+0.1];
                    cp2(i)=v1(1) * v2(2) - v1(2) * v2(1);  
                    check22=(cp2(i)*cp2(i-1) < 0 && (y(i)+0.1+L1*sin(theta1(i))<y1(k)) && (y1(k)<y(i)+0.1));
                     
                    dis = sqrt((x1(k)-x(i)-L1*cos(theta1(i))-(L2+0.12)*cos(theta2(i)))^2+(y1(k)-y(i)-0.1-L1*sin(theta1(i))-(L2+0.12)*sin(theta2(i)))^2);
                    if dis <= 0.15
                        check3 = true;
                    end

                end
              
                %% Using ode45 To define Movement After The Collison    
                if (check1 || check2 || check3 || check11 || check22) && ~flag
                    flag = true;
                    if e == 0
                        flag2 = false;
                        if (check11 || check22)
                            cll = true;
                        end
                    end
                    Rx1 = cos(theta1(i))*(m1*L1/2+mp1*lp1)/(m1+mp1);
                    Ry1 = sin(theta1(i))*(m1*L1/2+mp1*lp1)/(m1+mp1);
                    Rx2 = cos(theta2(i))*(m2*L2/2+mp2*lp2+m*L2)/(m2+m+mp2);
                    Ry2 = sin(theta2(i))*(m2*L2/2+mp2*lp2+m*L2)/(m2+m+mp2);
                    mT1 = m1+mp1;   mT2 = m2+mp2+m;
                    LB = sqrt((x1(k)-x(i)-L1*cos(theta1(i)))^2+(y1(k)-0.1-y(i)-L1*sin(theta1(i)))^2);
                    LBx = LB*cos(theta2(i));   LBy = LB*sin(theta2(i));

                    if check3
                        direction = atan2(y1(k)-y(i)-0.1-L1*sin(theta1(i))-(L2+0.12)*sin(theta2(i)), x1(k)-x(i)-L1*cos(theta1(i))-(L2+0.12)*cos(theta2(i)));
                        nd=([cos(direction) sin(direction)]);
                        td=([sin(direction) -cos(direction)]);
                    elseif (check22 || check11)
                        td=([cos(theta1(i)) sin(theta1(i))]);
                        nd=([sin(theta1(i)) -cos(theta1(i))]);
                    else
                        td=([cos(theta2(i)) sin(theta2(i))]);
                        nd=([sin(theta2(i)) -cos(theta2(i))]);
                    end
                    Ig1 = m1*L1^2/12;   Ig2 = m2*L2^2/12+m2*(sqrt(Rx2^2+Ry2^2)-L2/2)^2 + 2*m*0.05^2/5+m*(sqrt(Rx2^2+Ry2^2)-L2)^2;
                    I = L1*cos(theta1(i))+Rx2;   J = L1*sin(theta1(i))+Ry2;
                    II = L1*cos(theta1(i))+LBx;   JJ = L1*sin(theta1(i))+LBy;
                    %% Solving a 6 equation-6 Unknowns System After impact
                    if ~check22 && ~check11
                    A=[-LBy*mA LBx*mA -Ry2*mT2 Rx2*mT2*L1*cos(theta1(i))+Ry2*mT2*L1*sin(theta1(i)) Rx2^2*mT2+Ry2^2*mT2+Ig2 0;
                        -JJ*mA II*mA -Ry1*mT1-J*mT2 mT1*Rx1^2+mT1*Ry1^2+Ig1+mT2*I*L1*cos(theta1(i))+J*mT2*L1*sin(theta1(i)) Ig2+I*mT2*Rx2+J*mT2*Ry2 0;
                        mA*nd(1) mA*nd(2) M*nd(1)+mT1*nd(1)+mT2*nd(1) -mT1*nd(1)*Ry1+mT1*nd(2)*Rx1-mT2*nd(1)*L1*sin(theta1(i))+mT2*nd(2)*L1*cos(theta1(i)) -mT2*nd(1)*Ry2+mT2*nd(2)*Rx2 -nd(2);
                        mA*td(1) mA*td(2) 0 0 0 0;
                        0 0 M*td(1)+mT1*td(1)+mT2*td(1) -mT1*td(1)*Ry1+mT1*td(2)*Rx1-mT2*td(1)*L1*sin(theta1(i))+mT2*td(2)*L1*cos(theta1(i)) -mT2*td(1)*Ry2+mT2*td(2)*Rx2 -td(2);
                        -nd(1) -nd(2) nd(1) -nd(1)*L1*sin(theta1(i))+nd(2)*L1*cos(theta1(i)) LBx*nd(2)-nd(1)*LBy 0];
                   
                    B=[(-LBy*mA)*Vx1(k)+(LBx*mA)*Vy1(k)+(-Ry2*mT2)*x_dot(i)+(Rx2*mT2*L1*cos(theta1(i))+Ry2*mT2*L1*sin(theta1(i)))*theta1_dot(i)+(Rx2^2*mT2+Ry2^2*mT2+Ig2)*theta2_dot(i);
                        (-JJ*mA)*Vx1(k)+(II*mA)*Vy1(k)+(-Ry1-J*mT2)*x_dot(i)+(mT1*Rx1^2+mT1*Ry1^2+Ig1+mT2*I*L1*cos(theta1(i))+J*mT2*L1*sin(theta1(i)))*theta1_dot(i)+(Ig2+I*mT2*Rx2+J*mT2*Ry2)*theta2_dot(i);
                        (mA*nd(1))*Vx1(k)+(mA*nd(2))*Vy1(k)+(M*nd(1)+mT1*nd(1)+mT2*nd(1))*x_dot(i)+(-mT1*nd(1)*Ry1+mT1*nd(2)*Rx1-mT2*nd(1)*L1*sin(theta1(i))+mT2*nd(2)*L1*cos(theta1(i)))*theta1_dot(i)+(-mT2*nd(1)*Ry2+mT2*nd(2)*Rx2)*theta2_dot(i);
                        mA*td(1)*Vx1(k)+mA*td(2)*Vy1(k);
                        (M*td(1)+mT1*td(1)+mT2*td(1))*x_dot(i)+(-mT1*td(1)*Ry1+mT1*td(2)*Rx1-mT2*td(1)*L1*sin(theta1(i))+mT2*td(2)*L1*cos(theta1(i)))*theta1_dot(i)+(-mT2*td(1)*Ry2+mT2*td(2)*Rx2)*theta2_dot(i)
                        e*(Vx1(k)*nd(1)+Vy1(k)*nd(2))-e*nd(1)*(x_dot(i)-theta1_dot(i)*L1*sin(theta1(i))-theta2_dot(i)*LBy)-e*nd(2)*(theta1_dot(i)*L1*cos(theta1(i))+theta2_dot(i)*LBx)];
                    move1 = true;
                    else
                    LA = sqrt((x1(k)-x(i))^2+(y1(k)-0.1-y(i))^2);
                    LAx = LA*cos(theta1(i));   LAy = LA*sin(theta1(i));
                    A=[0 0 -Ry2*mT2 Rx2*mT2*L1*cos(theta1(i))+Ry2*mT2*L1*sin(theta1(i)) Rx2^2*mT2+Ry2^2*mT2+Ig2 0;
                        -LAy*mA LAx*mA -Ry1*mT1-J*mT2 mT1*Rx1^2+mT1*Ry1^2+Ig1+mT2*I*L1*cos(theta1(i))+J*mT2*L1*sin(theta1(i)) Ig2+I*mT2*Rx2+J*mT2*Ry2 0;
                        mA*nd(1) mA*nd(2) M*nd(1)+mT1*nd(1)+mT2*nd(1) -mT1*nd(1)*Ry1+mT1*nd(2)*Rx1-mT2*nd(1)*L1*sin(theta1(i))+mT2*nd(2)*L1*cos(theta1(i)) -mT2*nd(1)*Ry2+mT2*nd(2)*Rx2 -nd(2);
                        mA*td(1) mA*td(2) 0 0 0 0;
                        0 0 M*td(1)+mT1*td(1)+mT2*td(1) -mT1*td(1)*Ry1+mT1*td(2)*Rx1-mT2*td(1)*L1*sin(theta1(i))+mT2*td(2)*L1*cos(theta1(i)) -mT2*td(1)*Ry2+mT2*td(2)*Rx2 -td(2);
                        -nd(1) -nd(2) nd(1) -nd(1)*LAy+nd(2)*LAx 0 0];
                   
                    B=[(-Ry2*mT2)*x_dot(i)+(Rx2*mT2*L1*cos(theta1(i))+Ry2*mT2*L1*sin(theta1(i)))*theta1_dot(i)+(Rx2^2*mT2+Ry2^2*mT2+Ig2)*theta2_dot(i);
                        (-LAy*mA)*Vx1(k)+(LAx*mA)*Vy1(k)+(-Ry1-J*mT2)*x_dot(i)+(mT1*Rx1^2+mT1*Ry1^2+Ig1+mT2*I*L1*cos(theta1(i))+J*mT2*L1*sin(theta1(i)))*theta1_dot(i)+(Ig2+I*mT2*Rx2+J*mT2*Ry2)*theta2_dot(i);
                        (mA*nd(1))*Vx1(k)+(mA*nd(2))*Vy1(k)+(M*nd(1)+mT1*nd(1)+mT2*nd(1))*x_dot(i)+(-mT1*nd(1)*Ry1+mT1*nd(2)*Rx1-mT2*nd(1)*L1*sin(theta1(i))+mT2*nd(2)*L1*cos(theta1(i)))*theta1_dot(i)+(-mT2*nd(1)*Ry2+mT2*nd(2)*Rx2)*theta2_dot(i);
                        mA*td(1)*Vx1(k)+mA*td(2)*Vy1(k);
                        (M*td(1)+mT1*td(1)+mT2*td(1))*x_dot(i)+(-mT1*td(1)*Ry1+mT1*td(2)*Rx1-mT2*td(1)*L1*sin(theta1(i))+mT2*td(2)*L1*cos(theta1(i)))*theta1_dot(i)+(-mT2*td(1)*Ry2+mT2*td(2)*Rx2)*theta2_dot(i)
                        e*(Vx1(k)*nd(1)+Vy1(k)*nd(2))-e*nd(1)*(x_dot(i)-theta1_dot(i)*LAy)-e*nd(2)*(theta1_dot(i)*LAx)];

                    move2 = true;
                    end
                    Vel=A\B;
                    delta1=Vel(3)-x_dot(i);   delta2=Vel(4)-theta1_dot(i);   delta3=Vel(5)-theta2_dot(i);
                    Vx1(k)=Vel(1);   Vy1(k)=Vel(2);   xdot=Vel(3);   theta1dot=Vel(4);   theta2dot=Vel(5);   %N=Vel(6)   
                    % Making sure the added mass of the ball is calculated
                    % in ode23 if it gets stuck in the Pandulum
                    if e == 0
                        if ~check11 && ~check22
                            lp2=LB;  mp2=mA;
                        else
                            lp1=LA;  mp1=mA;
                        end
                    else
                         lp2=0;  mp2=0;
                         lp1=0;  mp1=0;
                    end
                    %% Using the gathered data as initial Conditions for Ode23
                    dt = 10^-2; % Note that the time step is given a fixed value for a more stable and fluid animation
                    tspan= 0:dt:10; % Change the ending time based on your desire
                    X0=[x(i) xdot theta1(i) theta1dot theta2(i) theta2dot];
                    odefun = @(t, X) mov2(t,X,M, m, g, m1, m2, L1, L2, mp1, lp1, mp2, lp2);
                    [tt,X] = ode23(odefun,tspan,X0);
                    x=X(:,1);
                    x_dot=X(:,2);
                    theta1=X(:,3);
                    theta1_dot=X(:,4);
                    theta2=X(:,5);
                    theta2_dot=X(:,6);
                    w = -x_dot/0.11;   i = 2;
                    if e ~= 0 && ~check3
                        if ~check11 && ~check22
                            v1 = [x1(k-1)-x(i-1)-L1*cos(theta1(i-1)), y1(k-1)-y(i-1)-0.1-L1*sin(theta1(i-1))];
                            v2 = [L1*cos(theta1(i-1))+L2*cos(theta2(i-1)), L1*sin(theta1(i-1))+0.1+L2*sin(theta2(i-1))];
                            cp=v1(1) * v2(2) - v1(2) * v2(1);  if cp~=0, cp=cp/abs(cp); else, cp=1; end
                            x1(k) = x(i)+L1*cos(theta1(i))+LB*cos(theta2(i))+cp*0.10*sin(theta2(i)); y1(k) = 0.1+y(i)+L1*sin(theta1(i))+LB*sin(theta2(i))-cp*0.10*cos(theta2(i));
                        else
                            v1 = [x1(k-1)-x(i-1), y1(k-1)-y(i-1)-0.1];
                            v2 = [L1*cos(theta1(i-1)), L1*sin(theta1(i-1))+0.1];
                            cp=v1(1) * v2(2) - v1(2) * v2(1);  if cp~=0, cp=cp/abs(cp); else, cp=1; end
                            x1(k) = x(i)+LA*cos(theta1(i))+cp*0.10*sin(theta1(i)); y1(k) = 0.1+y(i)+LA*sin(theta1(i))-cp*0.10*cos(theta1(i));
                        end
                    end
                    cl = true;
                    
                end

                %% Animating The Chariot and Pendulum
                hold off
                hold on
                axis equal
                axis([-2.5+x(i)+.5*min(oo,1) 1.5+x(i)+.5*min(oo,1) -1.1 1.1])
                if j == 6, f=-1; elseif j==0, f=1; end;   j=j+f*1; % Adding info about the collision effect 

                % Calling BodyAnimator Funcion to Animate Main Body And Wheels
                BodyAnimator2(x(i),y(i),thetaa(i), theta1(i),theta2(i),L1,L2,theta1_dot(i),theta2_dot(i), x_dot(i),oo,j,cl,delta1,delta2,delta3,cll,x1(k),y1(k),final_color)
                
                if move1
                    plot(x(i)+L1*cos(theta1(i))+LB*cos(theta2(i)),y(i)+0.1+L1*sin(theta1(i))+LB*sin(theta2(i)),'x','Color', 'r', 'MarkerSize', 10);
                    % plot([x(i)+L1*cos(theta1(i)) x(i)+L1*cos(theta1(i))+L2*cos(theta2(i))],[y(i)+0.1+L1*sin(theta1(i)) y(i)+0.1+L1*sin(theta1(i))+L2*sin(theta2(i))],'c:','LineWidth',2)
                elseif move2
                    % plot(x(i)+LA*cos(theta1(i)),y(i)+0.1+LA*sin(theta1(i)),'x','Color', 'r', 'MarkerSize', 10);
                end
                
                if ~cll,  fill(x1(k)+xc,y1(k)+yc,final_color,'linewidth',2); end % Animating the Ball
                title(gca, 'Pendulum Movement Simulation','fontsize',25);
                ax = gca(fig);   set(ax, 'xticklabel', [], 'yticklabel', []);
                box on;   ax = gca;   ax.LineWidth = 10;
                drawnow;  % drawnow limitrate (Replace in Case of Lag to Limit the Frame Rate)
                i = i+1;   k = k+1;   oo = oo + 0.015; % Adjusting Camera Angle

            end
            fig2 = figure;
            % Maximize the figure window
            set(fig2, 'WindowState', 'maximized');

            %% Creating subplots When The Simulation Finishes
            % First subplot
            subplot(3, 2, 1);
            plot(tt(1:i), x(1:i),'LineWidth', 1.1,'Color', 'green');
            grid on;   box on;
            set(gca, 'LineWidth', 1.3);
            set(gca, 'GridLineWidth', .8);
            ylabel('x(m)','Interpreter', 'latex','fontsize',20,'fontweight','bold', 'FontName', 'Times New Roman');
            xlabel('t(s)','Interpreter', 'latex','fontsize',20,'fontweight','bold', 'FontName', 'Times New Roman');
            title('x-t','Interpreter', 'latex','fontsize',25);
            
            %% Second subplot
            subplot(3, 2, 2);
            plot(tt(1:i), x_dot(1:i),'LineWidth', 1.1,'Color', 'green');
            grid on;   box on;
            set(gca, 'LineWidth', 1.3);
            set(gca, 'GridLineWidth', .8);
            ylabel('$\dot{x}$(m/s)','Interpreter', 'latex','fontsize',20,'fontweight','bold', 'FontName', 'Times New Roman');
            xlabel('t(s)','Interpreter', 'latex','fontsize',20,'fontweight','bold', 'FontName', 'Times New Roman');
            title('$\dot{x}$-t', 'Interpreter', 'latex','fontsize',25,'fontweight','bold');

            %% Third subplot
            subplot(3, 2, 3);
            plot(tt(1:i), theta1(1:i),'LineWidth', 1.1,'Color', 'red');
            grid on;   box on;
            set(gca, 'LineWidth', 1.3);
            set(gca, 'GridLineWidth', .8);
            ylabel('$\theta_1$(rad)','Interpreter', 'latex','fontsize',20,'fontweight','bold', 'FontName', 'Times New Roman');
            xlabel('t(s)','Interpreter', 'latex','fontsize',20,'fontweight','bold', 'FontName', 'Times New Roman');
            title('$\theta_1$-t', 'Interpreter', 'latex','fontsize',25);

            %% Fourth subplot
            subplot(3, 2, 4);
            plot(tt(1:i), theta1_dot(1:i),'LineWidth', 1.1,'Color', 'red');
            grid on;   box on;
            set(gca, 'LineWidth', 1.3);
            set(gca, 'GridLineWidth', .8);
            ylabel('$\dot{\theta}_1$(rad/s)','Interpreter', 'latex','fontsize',20,'fontweight','bold', 'FontName', 'Times New Roman');
            xlabel('t(s)','Interpreter', 'latex','fontsize',20,'fontweight','bold', 'FontName', 'Times New Roman');
            title('$\dot{\theta}_1$-t', 'Interpreter', 'latex','fontsize',25);

            %% Fifth subplot
            subplot(3, 2, 5);
            plot(tt(1:i), theta2(1:i),'LineWidth', 1.1,'Color', 'yellow');
            grid on;   box on;
            set(gca, 'LineWidth', 1.3);
            set(gca, 'GridLineWidth', .8);
            ylabel('$\theta_2$(rad)','Interpreter', 'latex','fontsize',20,'fontweight','bold', 'FontName', 'Times New Roman');
            xlabel('t(s)','Interpreter', 'latex','fontsize',20,'fontweight','bold', 'FontName', 'Times New Roman');
            title('$\theta_2$-t', 'Interpreter', 'latex','fontsize',25);

            %% Sixth subplot
            subplot(3, 2, 6);
            plot(tt(1:i), theta2_dot(1:i),'LineWidth', 1.1,'Color', 'yellow');
            grid on;   box on;
            set(gca, 'LineWidth', 1.3);
            set(gca, 'GridLineWidth', .8);
            ylabel('$\dot{\theta}_2$(rad/s)','Interpreter', 'latex','fontsize',20,'fontweight','bold', 'FontName', 'Times New Roman');
            xlabel('t(s)','Interpreter', 'latex','fontsize',20,'fontweight','bold', 'FontName', 'Times New Roman');
            title('$\dot{\theta}_2$-t', 'Interpreter', 'latex','fontsize',25);
        end

    end
    
    %% Calculating Mouse Position Real-Time
    function mouseMove(~, ~)
        
        mousePos = get(gca, 'CurrentPoint'); % Getting MousePos Real-Time
        xx = mousePos(1, 1);
        yy = mousePos(1, 2);
        clf(fig); % Clear previous plot

        %% Aiming And Releasing Logic
        if aiming
            ii = 1;
            hold off;
            hold on;
            axis equal
            axis([-2.5 1.5 -1.1 1.1])
            %Calling BodyAnimator Func to Animate Main Body And Wheels
            BodyAnimator2(x(ii),y(ii),thetaa(ii), theta1(ii),theta2(ii),L1,L2,theta1_dot(ii),theta2_dot(ii), x_dot(ii),0,0,false,0,0,0,false,0,0,0)
            
            distance = norm([xx - ballPos(1), yy - ballPos(2)]);
            direction = atan2(yy - ballPos(2), xx - ballPos(1));
            redness = min(distance/1.2, 1); % Adjust redness based on distance
            final_color = [redness, 0, 0]; % Saving the color for the ball after the release
            plot([ballPos(1)-0.05*sin(direction), xx-0.03*sin(direction)], [ballPos(2)+0.05*cos(direction), yy+0.03*cos(direction)], 'Color', [redness, 0, 0], 'LineWidth', 2);
            plot([ballPos(1)+0.05*sin(direction), xx+0.03*sin(direction)], [ballPos(2)-0.05*cos(direction), yy-0.03*cos(direction)], 'Color', [redness, 0, 0], 'LineWidth', 2);
            plot([xx-0.03*sin(direction), xx+0.03*sin(direction)], [yy+0.03*cos(direction), yy-0.03*cos(direction)], 'Color', [redness, 0, 0], 'LineWidth', 2);
            bb10=ballPos(1); % Initial X Position of Ball
            bb20=ballPos(2); % Initial Y Position of Ball
            Vxb1=-min(distance, 1.2)*cos(direction)*10; % Initial X Velocity of Ball
            Vyb1=-min(distance, 1.2)*sin(direction)*10; % Initial Y Velocity of Ball
            tt = 0:.01:1.5;
            bb1 = Vxb1.*tt + bb10;
            bb2 = -1/2*9.81*tt.^2+ Vyb1.*tt + bb20;

            % Showing A Prediction of The Ball Movement
            fill(ballPos(1)+xc,ballPos(2)+yc,[redness, 0, 0],'linewidth',2);
            plot(bb1(1:150),bb2(1:150),'c:','LineWidth',2);
            title(gca, 'While Holding, Move the Cursor to Aim And Release to Shoot','fontsize',25);
            formatteds_string = sprintf('%.2f',sqrt(Vxb1^2+Vyb1^2));
            text(bb10-0.2, bb20+0.2,['V:' formatteds_string '(m/s)'],'fontsize',10,'fontweight','bold');
            ax = gca(fig);
            set(ax, 'xticklabel', [], 'yticklabel', []);
            box on
            ax = gca;
            ax.LineWidth = 10;
            drawnow;

        else % Updating Frame When The User is Deploying The Ball
            ii = 1;
            hold off
            hold on;
            % Calling BodyAnimator Func to Animate Main Body And Wheels
            BodyAnimator2(x(ii),y(ii),thetaa(ii), theta1(ii),theta2(ii),L1,L2,theta1_dot(ii),theta2_dot(ii), x_dot(ii),0,0,false,0,0,0,false,0,0,0)
            axis equal
            axis([-2.5 1.5 -1.1 1.1])
            fill(xx+xc,yy+yc,'k-','linewidth',2);
            ballPos(1) = xx;    ballPos(2) = yy;
            title(gca, 'Left click and Hold to Deploy the Ball','fontsize',25);
            % Showing Extra Information About the Throw
            hy = abs(yy - L1*sin(theta1(ii))-L2*sin(theta2(i)));
            formatteds_string = sprintf('%.2f',hy );
            text(xx-.4,yy/2+L1*sin(theta1(i))/2+L2*sin(theta2(i)/2),['Hy:' formatteds_string '(m)'],'fontsize',10,'fontweight','bold');
            hx = abs(xx-x(i)-L1*cos(theta1(i))-L2*cos(theta2(i)));
            plot([x(i)+L1*cos(theta1(i))+L2*cos(theta2(i)) xx], [L1*sin(theta1(i))+L2*sin(theta2(i)) L1*sin(theta1(i))+L2*sin(theta2(i))], 'c:','LineWidth',2);
            formatteds_string = sprintf('%.2f',hx );
            text(xx/2-x(i)+L1*cos(theta1(i))/2-L2*cos(theta2(i)),L1*sin(theta1(i))+L2*sin(theta2(i))-0.2,['Hx:' formatteds_string '(m)'],'fontsize',10,'fontweight','bold');
            plot([xx xx], [yy +L1*sin(theta1(i))+L2*sin(theta2(i))], 'c:','LineWidth',2);
            ax = gca(fig);
            set(ax, 'xticklabel', [], 'yticklabel', []);
            box on
            ax = gca;
            ax.LineWidth = 10;
            drawnow;

        end
    end
end

