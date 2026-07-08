function updatedValue = plotWithInput(f, BodyAnimator2,x, y, thetaa, theta1,theta2, L1,L2,~)
    updatedValue = cell(1,7);
    allboxes = cell(1,7);
    done = {false, false, false, false, false, false, false};
    values = {'Lenght of the Pendulum1','Lenght of the Pendulum2','Initial Angle1','Initial Angle2', 'Initial Angluar speed1','Initial Angluar speed2','Coefficient of Restitution (e)'};

    function submitCallback(~, ~)
        for num = 1:7
            %% Using alternative values in case no input is given
            x_str = get(allboxes{num}, 'String');
            if isempty(x_str) || isnan(str2double(x_str))
                if num == 1, updatedValue{num} = 0.3; end
                if num == 2, updatedValue{num} = 0.6; end
                if num == 3, updatedValue{num} = -pi/2; end
                if num == 4, updatedValue{num} = -pi/2; end
                if num == 5, updatedValue{num} = 0; end 
                if num == 6, updatedValue{num} = 0; end
                if num == 7, updatedValue{num} = 0.8; end
            else
                %% Using the variables provided by the user
                x_str = get(allboxes{num}, 'String');
                newValue = str2double(x_str);
                if num == 3, newValue = deg2rad(newValue); end
                if num == 4, newValue = deg2rad(newValue); end
                updatedValue{num} = newValue;
            end
            done{num} = true;
        end
    end
    

    for i=1:7
        yPos = 350:-35:260-35-35*4;
        promptString = sprintf(values{i});
        prompt = uicontrol('Style', 'text', 'String', promptString,'Position', [20+300 yPos(i)+250 120 30], 'Parent', f); %#ok<NASGU>
        inputBox = uicontrol('Style', 'edit', 'String', '','Position', [130+300 yPos(i)+250 50 30], 'Parent', f);
        allboxes{i} = inputBox;
    end
    submitButton = uicontrol('Style', 'pushbutton', 'String', 'Confirm','Position', [190+320 500 100 60], 'Callback', @submitCallback, 'Parent', f); %#ok<NASGU>

    while ~all(cell2mat(done))
        pause(0.1);
        hold off
        hold on;
        BodyAnimator2(x,y,thetaa, theta1,theta2,L1,L2,0,0, 0,0,0,false,0,0,0,false,0,0,0)
        title(gca, 'Input The Necessary Variables','fontsize',25);
        axis equal
        axis([-2.5 1.5 -1.1 1.1])
    end


end

