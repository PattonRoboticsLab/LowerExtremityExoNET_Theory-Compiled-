function S = GUI(S)
%This is to set up the GUI for creating the leg paramters
% Create UIFigure and hide until all components are created
UIFigure = uifigure('Visible', 'off');
UIFigure.Position = [100 100 466 638];
UIFigure.Name = 'Leg Parameters';

%Create FileMenu
FileMenu = uimenu(UIFigure);
FileMenu.Text = 'File';

% Create Save
Save = uimenu(FileMenu, "MenuSelectedFcn", @SaveMenuSelected, "Enable", "on");
Save.Text = 'Save Configuration';

% Create Load
Load = uimenu(FileMenu, "MenuSelectedFcn", @LoadMenuSelected, "Enable", "on");
Load.Text = 'Load Configuration';

% Create ToolsMenu
ToolsMenu = uimenu(UIFigure);
ToolsMenu.Text = 'Tools';

% Create UnitsMenu
UnitsMenu = uimenu(ToolsMenu);
UnitsMenu.Text = 'Units';

% Create MetricMenu
MetricMenu = uimenu(UnitsMenu, "MenuSelectedFcn", @MetricMenuSelected, "Enable", "on");
MetricMenu.Text = 'Metric (Default)';

% Create EnglishMenu
EnglishMenu = uimenu(UnitsMenu, "MenuSelectedFcn", @EnglishMenuSelected, "Enable", "on");
EnglishMenu.Text = 'English';

%Create HelpMenu
HelpMenu = uimenu(UIFigure);
HelpMenu.Text = 'Help';

% Create TabGroup
TabGroup = uitabgroup(UIFigure);
TabGroup.Position = [1 -1 467 640];

%========================== MainTab ======================================%
MainTab = uitab(TabGroup);
MainTab.Title = 'Main';

%Create labels and buttons
uilabel(MainTab, "FontSize", 16, "Position", [125 480 225 22], "Text", "Choose a field to approximate:");%Label
KneeAnkleGaitTorqueButton = uibutton(MainTab, 'push', "Position",[161 398 143 22], "Text", "Knee-Ankle Gait Torque");
KneeAnkleGaitTorqueButton.ButtonPushedFcn = @KneeTorque;

HipKneeGaitTorqueButton = uibutton(MainTab, 'push', "Position", [161 356 143 22], "Text", "Hip-Knee Gait Torque");
HipKneeGaitTorqueButton.ButtonPushedFcn = @HipTorque;

GaitStabilizationButton = uibutton(MainTab, 'push', "Position", [161 311 143 22], "Text", 'Gait Stabilization');
GaitStabilizationButton.ButtonPushedFcn = @GaitStable;

LegDesignOptimizationButton = uibutton(MainTab, 'push', "Position",[161 266 143 22], "Text", 'Leg Design Optimization');
LegDesignOptimizationButton.ButtonPushedFcn = @DesignOpto;

if S.switch == false %Initial setup
    KneeAnkleGaitTorqueButton.Enable = 'on';
    HipKneeGaitTorqueButton.Enable = 'on';
    GaitStabilizationButton.Enable = 'off';
    LegDesignOptimizationButton.Enable = 'off';
else %Run further analysis
    KneeAnkleGaitTorqueButton.Enable = 'off';
    HipKneeGaitTorqueButton.Enable = 'off';
    GaitStabilizationButton.Enable = 'on';
    LegDesignOptimizationButton.Enable = 'on';
end
%========================== MainTab ======================================%
ExoNETTab = uitab(TabGroup);
ExoNETTab.Title = 'ExoNET';

% Create TypeofSpringButtonGroup
springGroup = uibuttongroup(ExoNETTab, "SelectionChangedFcn",...
    @springButtonChange, "Position",  [34 522 123 69]);
springGroup.Title = 'Type of Spring';

uiradiobutton(springGroup, "Text", "hold", "Position", [11 23 45 22],"Visible", "off", "Value", true); %placeholder until something is selected
CompressionButton = uiradiobutton(springGroup, "Text", "Compression", "Position", [11 22 93 22]);
TensionButton = uiradiobutton(springGroup, "Text", "Tension", "Position", [11 1 65 22]);

% Create TypeofJointButtonGroup
jointGroup = uibuttongroup(ExoNETTab, "SelectionChangedFcn", @jointButtonChange,"Position", [243 499 196 92]);
jointGroup.Title = 'Type of Joint';
jointGroup.Visible = 'off';

uiradiobutton(jointGroup, "Text", "hold", "Position", [11 46 45 22], "Value", true,"Visible", "off"); %placeholder until something is selected
KneeToe = uiradiobutton(jointGroup, "Text", "Only knee-toe", "Position",[11 46 97 22]);
AnkleToe = uiradiobutton(jointGroup, "Text", "Only ankle-toe", "Position", [11 24 99 22]);
Both = uiradiobutton(jointGroup, "Text", "Both ankle-toe and knee-toe", "Position", [11 2 173 22]);
HipKnee = uiradiobutton(jointGroup, "Text", "Hip-Knee", "Position", [11 -20 106 22]);

ofstackedelementsperjointDropDownLabel = uilabel(ExoNETTab, "HorizontalAlignment", "right", "Position", [117 281 171 22],"Text", "# of stacked elements per joint:", "Visible", "off");
ofstackedelementsperjointDropDown = uidropdown(ExoNETTab, "Items", {'1', '2', '3', '4', '5', '6'}, "ItemsData", {'1', '2', '3', '4', '5', '6'}, "Visible", "off", "Position", [303 281 46 22], "Value", '1');

SpringStiffnessPanel = uipanel(ExoNETTab, "Position", [135 80 197 129], "Title", 'Spring Stiffness [N/m]', "Visible", "off");

K1jEditFieldLabel  = uilabel(ExoNETTab, "HorizontalAlignment", "right", "Visible", "off", "Position", [168 145 25 22],"Text", "K1j");
K1jEditField = uieditfield(ExoNETTab, 'numeric', "Limits", [0 Inf], "Visible", "off", "Tooltip", {'spring stiffness in [N/m] for a 1-joint compression spring'}, "Position", [208 145 100 22]);

K2jEditFieldLabel  = uilabel(ExoNETTab, "HorizontalAlignment", "right", "Visible", "off", "Position", [169 111 25 22],"Text", "K2j");
K2jEditField = uieditfield(ExoNETTab, 'numeric', "Limits", [0 Inf], "Visible", "off", "Tooltip", {'spring stiffness in [N/m] for a 2-joint compression spring'}, "Position", [209 111 100 22]);

KEditFieldLabel = uilabel(ExoNETTab, "HorizontalAlignment", "right", "Visible", "off", "Position", [168 145 25 22],"Text", "K");
KEditField = uieditfield(ExoNETTab, 'numeric', "Limits", [0 Inf], "Visible", "off", "Position", [208 145 100 22]);

TriesEditFieldLabel = uilabel(ExoNETTab, "HorizontalAlignment", "right", "Visible", "off", "Position", [184 409 42 22],"Text", "# Tries");
TriesEditField =  uieditfield(ExoNETTab, 'numeric', "Limits", [0 Inf], "Visible", "off", "Position", [241 409 41 22],"Value", 50);

AntiAssistanceCheckBox = uicheckbox(ExoNETTab, "Visible", "off", "Text", "Anti-Assistance", "Position", [180 343 105 22]);

% Create RunButton
RunButton = uibutton(ExoNETTab, 'push', 'Text', 'RUN', 'Position', [325 7 135 22], "Visible", "off");
RunButton.BackgroundColor = [0 1 0];
RunButton.ButtonPushedFcn = @saveAndClose;
%=========================================================================%
%==================== Parameter Contstraints =============================%
ParameterConstraintsTab = uitab(TabGroup);
ParameterConstraintsTab.Title = 'Parameter Constraints';

%Create Grid Layout
GridLayout = uigridlayout(ParameterConstraintsTab);
GridLayout.ColumnWidth = {'2.07x', 87, 87, '1.99x'};
GridLayout.RowHeight = {'1x', 22, '2.34x', 22, 22, 22, 22, 22, 22, 22, 22, 22, '10.61x'};

%RLoHimSpinnerLabel = uilabel(UIFigure, "HorizontalAlignment", "right", "Visible", "off", "Position", [68 252 59 22],"Text", "RLoHi [m]");
RLo = uispinner(GridLayout, "Step", 0.1, "Limits", [0 Inf]);
RLo.Layout.Row = 5; RLo.Layout.Column = 2;
RHi = uispinner(GridLayout, "Step", 0.1, "Limits", [0 Inf]);
RHi.Layout.Row = 5; RHi.Layout.Column = 3;

%thetaLoHidegLabel = uilabel(UIFigure, "HorizontalAlignment", "right", "Visible", "off", "Position", [55 180 87 22],"Text", "thetaLoHi [deg]");
thetaLo = uispinner(GridLayout, "Limits", [-360 360]);
thetaLo.Layout.Row = 9; thetaLo.Layout.Column = 2;
thetaHi = uispinner(GridLayout, "Limits", [0 360]);
thetaHi.Layout.Row = 9; thetaHi.Layout.Column = 3;

%L0LoHimSpinnerLabel = uilabel(UIFigure, "HorizontalAlignment", "right", "Visible", "off", "Position", [67 108 63 22],"Text", "L0LoHi [m]");
L0Lo = uispinner(GridLayout, "Step", 0.1, "Limits", [0 Inf]);
L0Lo.Layout.Row = 7; L0Lo.Layout.Column = 2;
L0Hi = uispinner(GridLayout, "Step", 0.1, "Limits", [0 Inf]);
L0Hi.Layout.Row = 7; L0Hi.Layout.Column = 3;

%LL0LoHimLabel = uilabel(UIFigure, "HorizontalAlignment", "right", "Visible", "off", "Position", [60 41 70 22],"Text", "LL0LoHi [m]");
LL0Lo = uispinner(GridLayout, "Limits", [0 Inf], "Step", 0.1);
LL0Lo.Layout.Row = 11; LL0Lo.Layout.Column = 2;
LL0Hi = uispinner(GridLayout, "Limits", [0 Inf], "Step", 0.1);
LL0Hi.Layout.Row = 11; LL0Hi.Layout.Column = 3;

ParametersEditFieldLabel = uilabel(GridLayout, "HorizontalAlignment", "right", "Text", "Parameters");
ParametersEditFieldLabel.Layout.Row = 2; ParametersEditFieldLabel.Layout.Column = 1;
ParametersEditField = uieditfield(GridLayout, 'numeric', "Limits", [0 Inf], "Tooltip", {'number of parameters for each spring'}, "Value", 3);
ParametersEditField.Layout.Row = 2; ParametersEditField.Layout.Column = 2;


%Create Labels
MinmumLabel = uilabel(GridLayout, "HorizontalAlignment", "center", "Text", "Minimum");
MinmumLabel.Layout.Row = 4; MinmumLabel.Layout.Column = 2;

MaximumLabel = uilabel(GridLayout, "HorizontalAlignment", "center", "Text", "Maximum");
MaximumLabel.Layout.Row = 4; MaximumLabel.Layout.Column = 3;

RadiusLabel = uilabel(GridLayout, "HorizontalAlignment", "right", "Tooltip", {'Radius of the rod component'}, "Text", "Radius");
RadiusLabel.Layout.Row = 5; RadiusLabel.Layout.Column = 1;

Length1springLabel = uilabel(GridLayout, "HorizontalAlignment", "right", "Tooltip", {'Resting length for 1-spring component'},"Text", "Length (1-spring)");
Length1springLabel.Layout.Row = 7; Length1springLabel.Layout.Column = 1;

ThetadegLabel = uilabel(GridLayout, "HorizontalAlignment", "right", "Tooltip", {'Angle of rod in degrees'}, "Text","Theta [deg]");
ThetadegLabel.Layout.Row = 9; ThetadegLabel.Layout.Column = 1;

Length2springLabel = uilabel(GridLayout, "HorizontalAlignment","right","Tooltip", {'Resting length of 2-spring component'}, "Text", "Length (2-spring)");
Length2springLabel.Layout.Row = 11; Length2springLabel.Layout.Column = 1;

UnitsEditField_2 = uieditfield(GridLayout, 'text', "Editable", "off", "HorizontalAlignment", "right", "Value", "Metric");
UnitsEditField_2.Layout.Row = 1; UnitsEditField_2.Layout.Column = 2;

UnitsLabel_2 = uilabel(GridLayout, "HorizontalAlignment", "right", "Text", "Units in:");
UnitsLabel_2.Layout.Row = 1; UnitsLabel_2.Layout.Column = 1;

% Create ParmDoneButton
ParmDoneButton = uibutton(ParameterConstraintsTab, 'push', 'Text', 'Done', 'Position', [325 7 137 22]);
ParmDoneButton.ButtonPushedFcn = @ParmDoneButtonPushed;
ParmDoneButton.BackgroundColor = [1 1 0];
%=========================================================================%
%======================== Body Measurements ==============================%
BodyMeasurementsTab = uitab(TabGroup);
BodyMeasurementsTab.Title = 'Body Measurements';

% Create Image and labels
uiimage(BodyMeasurementsTab, "Position", [1 7 464 603], "ImageSource", "LegPicture.png");
uilabel(BodyMeasurementsTab, "HorizontalAlignment", "right", "Position", [93 444 38 22],"Text", "Thigh", "FontWeight", "bold", "FontColor",  [0.851 0.3255 0.098]); %ThighEditFieldLabel
ThighLength = uieditfield(BodyMeasurementsTab, 'numeric', "Limits", [0 Inf], "Position", [141 444 51 22], "Value", 0.46, "FontWeight", "bold", "FontColor",  [0.851 0.3255 0.098]);
uilabel(BodyMeasurementsTab, "HorizontalAlignment", "right","Position", [294 245 45 22],"Text", "Shank","FontWeight", "bold", "FontColor",  [0 0.4471 0.7412]); %ShankEditFieldLabel
ShankLength = uieditfield(BodyMeasurementsTab, 'numeric', "Limits", [0 Inf], "Position", [342 245 53 22], "Value", 0.42,"FontWeight", "bold", "FontColor",  [0 0.4471 0.7412]);
uilabel(BodyMeasurementsTab, "HorizontalAlignment", "right", "Position", [204 27 35 22],"Text", "Foot","FontWeight", "bold", "FontColor",  [0.4941 0.1843 0.5569]); %FootEditFieldLabel
FootLength =  uieditfield(BodyMeasurementsTab, 'numeric', "Limits", [0 Inf], "Position", [246 27 53 22], "Value", 0.26,"FontWeight", "bold", "FontColor",  [0.4941 0.1843 0.5569]);

uilabel(BodyMeasurementsTab, "HorizontalAlignment", "right", "Position", [346 586 65 22],"Text", "Body Mass"); %BodyMassEditFieldLabel
BodyMassEditField = uieditfield(BodyMeasurementsTab, 'numeric', "Limits", [0 Inf], "Position", [426 586 34 22], "Value", 70, "Tooltip", {'Body mass for a body height of 1.7 m'});

% Create AngledegPanel
AngledegPanel = uipanel(BodyMeasurementsTab, "TitlePosition", "centertop", "Title", "Angle [deg]", "Position", [357 451 100 122]);
uilabel(AngledegPanel, "Position", [16 72 35 22],"Text", "Thigh"); %ThighLabel
ThighAngle = uieditfield(AngledegPanel, 'numeric', "Limits", [0 Inf],"Position", [59 72 31 22], "Value", 10);
uilabel(AngledegPanel, "Position", [16 41 39 22],"Text", "Shank"); %ShankLabel
ShankAngle = uieditfield(AngledegPanel, 'numeric', "Limits", [0 Inf], "Position", [59 41 31 22], "Value", 20);
uilabel(AngledegPanel, "Position", [17 8 30 22],"Text", "Foot"); %FootLabel
FootAngle = uieditfield(AngledegPanel, 'numeric', "Limits", [0 Inf], "Position", [60 8 31 22], "Value", 90);

% Create HipEditFieldLabel
%uilabel(BodyMeasurementsTab, "HorizontalAlignment", "right", "FontWeight", "bold", "FontColor", [0.6353 0.0784 0.1843], "Position", [201 419 28 22], "Text", "Hip"); %HipEditFieldLabel
%HipLength = uieditfield(BodyMeasurementsTab, 'numeric', "Limits",  [0 Inf], "FontWeight", "bold", "FontColor", [0.6353 0.0784 0.1843], "Position", [235 419 53 22], "Value", 0.25);

UnitsEditField = uieditfield(BodyMeasurementsTab, 'text', "Editable", "off", "Position", [65 580 62 22], "Value", "Metric");
uilabel(BodyMeasurementsTab, "Position", [17 580 49 22], "Text", "Units in:"); %Units label
BodyDoneButton = uibutton(BodyMeasurementsTab, 'push', "BackgroundColor", [1 1 0], "Position", [325 7 137 22], "Text", "Done");
BodyDoneButton.ButtonPushedFcn = @BodyDoneButtonPushed;


% Show the figure after all components are created
UIFigure.Visible = 'on';

uiwait(UIFigure);
    function springButtonChange(~,~)
        if S.case ~= 1.2
            jointGroup.Visible = 'on';
        else %if it is hip
            S.EXONET.nJoints = 3;
            KEditField.Value = 2000;
            RLo.Value = 0.001;
            RHi.Value = 0.16;
            thetaLo.Value = -360;
            thetaHi.Value = 360;
            L0Lo.Value = 0.05;
            L0Hi.Value = 0.30;
            LL0Lo.Value = 0.10;
            LL0Hi.Value = 0.80;
            S.flag = 2;
            KEditField.Visible = 'on';
            KEditFieldLabel.Visible = 'on';
            visible();
        end
    end
    function jointButtonChange(~, event)
        if S.case == 1.1
            RLo.Value = 0.1;
            RHi.Value = 0.3;
            thetaLo.Value = 200;
            thetaHi.Value = 360;
        elseif S.case == 2 %Gait Stabilizaiton
            KEditField.Value = 400;
            RLo.Value = 0.001;
            RHi.Value = 0.3;
            thetaLo.Value = -360;
            thetaHi.Value = 360;
            L0Lo.Value = 0.05;
            L0Hi.Value = 0.30;
            LL0Lo.Value = 0.05;
            LL0Hi.Value = 0.70;
        elseif S.case == 3 %Leg optomization
            RLo.Value = 0;
            RHi.Value = .3;
            thetaLo.Value = -360;
            thetaHi.Value = 360;
            L0Lo.Value = .4;
            L0Hi.Value = .70;
            KEditField.Value = 1000;
        end
        
        %========================================================%
        if TensionButton.Value == true
            LL0Lo.Value = 0.05;
            LL0Hi.Value = 0.2;
            K1jEditField.Value = 2000;
            K2jEditField.Value = 800;
            L0Lo.Value = 0.05;
            L0Hi.Value = 0.20;
        elseif CompressionButton.Value == true
            LL0Lo.Value = 0.80;
            LL0Hi.Value = 1;
            K1jEditField.Value = 600;
            K2jEditField.Value = 600;
            L0Lo.Value = 0.10;
            L0Hi.Value = 0.20;
        end
        %========================================================%
        
        if event.NewValue == Both
            S.EXONET.nJoints = 2;
            K1jEditFieldLabel.Visible = 'on';
            K1jEditField.Visible = 'on';
            K2jEditFieldLabel.Visible = 'on';
            K2jEditField.Visible = 'on';
            KEditField.Visible = 'off';
            KEditFieldLabel.Visible = 'off';
            S.flag = [0,1];
        elseif event.NewValue == KneeToe
            S.EXONET.nJoints = 22;
            K2jEditField.Value = 1000;
            RLo.Value = 0.03;
            thetaLo.Value = 0;
            L0Lo.Value = 0.40;
            L0Hi.Value = 0.50;
            
            KEditField.Visible = 'off';
            KEditFieldLabel.Visible = 'off';
            K1jEditFieldLabel.Visible = 'on';
            K1jEditField.Visible = 'on';
            K2jEditFieldLabel.Visible = 'on';
            K2jEditField.Visible = 'on';
            S.flag = 1;
        elseif event.NewValue == AnkleToe
            S.EXONET.nJoints = 11;
            K1jEditFieldLabel.Visible = 'on';
            K1jEditField.Visible = 'on';
            K2jEditFieldLabel.Visible = 'on';
            K2jEditField.Visible = 'on';
            
            KEditField.Visible = 'off';
            KEditFieldLabel.Visible = 'off';
            S.flag = 0;
        end
        visible();
    end
% Callback function for the "Run" button
    function saveAndClose(~, ~)
        % Get the updated values from UI components
        % Lengths, pose, Mass, RLoHi, thetaLoHi, L0LoHi, LL0LoHi, nParameters, K2j, K1j, K, nElements, springType, nJoints, nTries, AA
        S.BODY.Lengths = [ThighLength.Value, ShankLength.Value, FootLength.Value];
        S.BODY.pose = [ThighAngle.Value, ShankAngle.Value, FootAngle.Value];
        S.BODY.Mass = BodyMassEditField.Value;
        
        S.RLoHi = [RLo.Value RHi.Value];
        S.thetaLoHi = [thetaLo.Value thetaHi.Value];
        S.L0LoHi = [L0Lo.Value L0Hi.Value];
        S.LL0LoHi = [LL0Lo.Value LL0Hi.Value]; %for 2-joint
        
        S.AA = AntiAssistanceCheckBox.Value;
        S.nTries = TriesEditField.Value;
        
        S.EXONET.nParameters = ParametersEditField.Value;
        S.EXONET.nElements = str2double(ofstackedelementsperjointDropDown.Value);
        
        if S.EXONET.nJoints ~= 3
            S.EXONET.K2j = K2jEditField.Value;
            S.EXONET.K1j = K1jEditField.Value;
        else
            S.EXONET.K = KEditField.Value; %spring stiffness for hip
        end
        
        if CompressionButton.Value == true
            S.Spring = 1;
        elseif TensionButton.Value == true
            S.Spring = 2;
        end
        % Close the UI figure
        close(UIFigure);
    end
% Callback function for the "Load Configuration"
    function LoadMenuSelected(~, ~)
        folderName = 'Configurations'; % Define the folder name
        %Check if the folder exists
        if ~exist(folderName, 'dir')
            disp('The "Configurations" folder does not exist.');
            return; % Exit without loading
        end
        
        %Let the user select a file from the folder
        [filename, folderPath] = uigetfile(fullfile(folderName, '*.txt'), 'Select Configuration File');
        
        % Check if the user canceled the dialog
        if filename == 0
            disp('User canceled the operation.');
            return; % Exit without loading
        end
        
        fullFilePath = fullfile(folderPath, filename); %Construct the full file path
        fileID = fopen(fullFilePath, 'r'); %Open the file for reading
        
        %Read the data from the file
        C = textscan(fileID,'%s %s %f %f %f', 'Delimiter', ':[]', 'MultipleDelimsAsOne', true);
        
        % Preprocess the first 6 variables to split the values by space
        for i = 1:6
            C{2}{i} = strsplit(C{2}{i});
        end
        
        fclose(fileID); %Close the file
        
        %Assign the values to app properties
        ThighLength.Value = str2double(C{1,2}{1,1}{1,1});
        ShankLength.Value = str2double(C{1,2}{1,1}{1,2});
        FootLength.Value = str2double(C{1,2}{1,1}{1,3});
        ThighAngle.Value = str2double(C{1,2}{2,1}{1,1});
        ShankAngle.Value = str2double(C{1,2}{2,1}{1,2});
        FootAngle.Value = str2double(C{1,2}{2,1}{1,3});
        RLo.Value = str2double(C{1,2}{3,1}{1,1});
        RHi.Value = str2double(C{1,2}{3,1}{1,2});
        thetaLo.Value = str2double(C{1,2}{4,1}{1,1});
        thetaHi.Value = str2double(C{1,2}{4,1}{1,2});
        L0Lo.Value = str2double(C{1,2}{5,1}{1,1});
        L0Hi.Value = str2double(C{1,2}{5,1}{1,2});
        LL0Lo.Value = str2double(C{1,2}{6,1}{1,1});
        LL0Hi.Value = str2double(C{1,2}{6,1}{1,2});
        BodyMassEditField.Value = str2double(C{2}(7));
        ParametersEditField.Value = str2double(C{2}(8));
        K1jEditField.Value = str2double(C{2}(9));
        K2jEditField.Value = str2double(C{2}(10));
        KEditField.Value = str2double(C{2}(11));
        ofstackedelementsperjointDropDown.Value = (C{2}(12));
        TriesEditField.Value = str2double(C{2}(13));
        UnitsEditField.Value = char(C{2}(14));
        
        if str2double(C{2}(15)) == 0
            AntiAssistanceCheckBox.Value = false;
        else
            AntiAssistanceCheckBox.Value = true;
        end
        
        if str2double(C{2}(16)) == 1
            springGroup.SelectedObject = CompressionButton;
        elseif str2double(C{2}(16)) == 2
            springGroup.SelectedObject = TensionButton;
        end
        
        jointGroup.Visible = "on";
        
        if str2double(C{2}(17)) == 2
            jointGroup.SelectedObject = Both;
            S.EXONET.nJoints = 2;
            K1jEditFieldLabel.Visible = 'on';
            K1jEditField.Visible = 'on';
            K2jEditFieldLabel.Visible = 'on';
            K2jEditField.Visible = 'on';
            KEditField.Visible = 'off';
            KEditFieldLabel.Visible = 'off';
            S.flag = [0,1];
        elseif str2double(C{2}(17)) == 22
            S.EXONET.nJoints = 22;
            jointGroup.SelectedObject = KneeToe;
            KEditField.Visible = 'off';
            KEditFieldLabel.Visible = 'off';
            K1jEditFieldLabel.Visible = 'on';
            K1jEditField.Visible = 'on';
            K2jEditFieldLabel.Visible = 'on';
            K2jEditField.Visible = 'on';
            S.flag = 1;
        elseif str2double(C{2}(17)) == 11
            jointGroup.SelectedObject = AnkleToe;
            S.EXONET.nJoints = 11;
            K1jEditFieldLabel.Visible = 'on';
            K1jEditField.Visible = 'on';
            K2jEditFieldLabel.Visible = 'on';
            K2jEditField.Visible = 'on';
            
            KEditField.Visible = 'off';
            KEditFieldLabel.Visible = 'off';
            S.flag = 0;
        elseif str2double(C{2}(17)) == 3
            jointGroup.SelectedObject = HipKnee;
        end
        visible();
    end
% Menu selected function: Save
    function SaveMenuSelected(~,~)
        Lengths = [ThighLength.Value, ShankLength.Value, FootLength.Value];
        pose = [ThighAngle.Value, ShankAngle.Value, FootAngle.Value];
        RLoHi = [RLo.Value RHi.Value];
        thetaLoHi = [thetaLo.Value thetaHi.Value];
        L0LoHi = [L0Lo.Value L0Hi.Value];
        LL0LoHi = [LL0Lo.Value LL0Hi.Value];
        Mass = BodyMassEditField.Value;
        nParameters = ParametersEditField.Value;
        K2j = K2jEditField.Value;
        K1j = K1jEditField.Value;
        K = KEditField.Value;
        nElements = ofstackedelementsperjointDropDown.Value;
        TRIES = TriesEditField.Value;
        Units = UnitsEditField.Value;
        ANTI = AntiAssistanceCheckBox.Value;
        
        SpringButton = springGroup.SelectedObject;
        
        if SpringButton.Text == "Compression"
            spring = 1;
        elseif SpringButton.Text == "Tension"
            spring = 2;
        end
        
        JointButton = jointGroup.SelectedObject;
        
        if JointButton.Text == "Both ankle-toe and knee-toe"
            nJoints = 2;
        elseif JointButton.Text == "Only knee-toe"
            nJoints = 22;
        elseif JointButton.Text == "Only ankle-toe"
            nJoints = 11;
        elseif JointButton.Text == "Hip-Knee-Ankle"
            nJoints = 3;
        end
        
        %========================================================%
        %Create a pop-up window to get the filename
        prompt = {'Enter filename:'};
        dlgtitle = 'Filename Input';
        dims = [1 35];
        definput = {'output.txt'};
        filename = inputdlg(prompt, dlgtitle, dims, definput);
        
        % Check if the user canceled the input dialog
        if isempty(filename)
            disp('User canceled the operation.')
            return; % Exit without saving
        end
        
        filename = filename{1}; % Extract filename from cell array
        
        % Append '.txt' extension if not provided
        if ~endsWith(filename, '.txt', 'IgnoreCase', true)
            filename = [filename '.txt'];
        end
        
        % Check if the folder exists, if not, create it
        folderName = "Configurations";
        if ~exist(folderName, 'dir')
            mkdir(folderName);
        end
        
        %Construct the full file path
        fullFilePath = fullfile(pwd, folderName, filename);
        
        %Open the file for writing
        fileID = fopen(fullFilePath, 'w');
        
        % Write the data into the file
        fprintf(fileID, 'Lengths: %s\n', mat2str(Lengths));
        fprintf(fileID, 'Pose: %s\n', mat2str(pose));
        fprintf(fileID, 'RLoHi: %s\n', mat2str(RLoHi));
        fprintf(fileID, 'thetaLoHi: %s\n', mat2str(thetaLoHi));
        fprintf(fileID, 'L0LoHi: %s\n', mat2str(L0LoHi));
        fprintf(fileID, 'LL0LoHi: %s\n', mat2str(LL0LoHi));
        fprintf(fileID, 'Mass: %f\n', Mass);
        fprintf(fileID, 'nParameters: %d\n', nParameters);
        fprintf(fileID, 'K2j: %f\n', K2j);
        fprintf(fileID, 'K1j: %f\n', K1j);
        fprintf(fileID, 'K: %f\n', K);
        fprintf(fileID, 'nElements: %d\n', str2double(nElements));
        fprintf(fileID, 'TRIES: %d\n', TRIES);
        fprintf(fileID, 'Units: %s\n', Units);
        fprintf(fileID, 'ANTI: %d\n', ANTI);
        fprintf(fileID, 'Spring: %d\n', spring);
        fprintf(fileID, 'nJoints: %d\n', nJoints);
        
        fclose(fileID); % Close the file
    end

% Button pushed function: BodyDoneButton
    function BodyDoneButtonPushed(~,~)
        TabGroup.SelectedTab = ExoNETTab;
    end
% Button pushed function: ParmDoneButton
    function ParmDoneButtonPushed(~,~)
        TabGroup.SelectedTab = ExoNETTab;
    end
% Menu selected function: MetricMenu
    function MetricMenuSelected(~,~)
        UnitsEditField.Value = 'Metric';
        UnitsEditField_2.Value = "Metric";
        %convert values to metric
        
        %convVar = 39.37; %convert from m to in by multiplying by this variable
        %convVarB = 2.205; %conversion variable for kg to lbs
        
        %                 app.RLo.Value = 0.1;
        %                 app.RHi.Value = 0.3;
        %                 app.L0Lo.Value = 0.1;
        %                 app.L0Hi.Value = 0.2;
        %                 app.LL0Lo.Value = 0.8;
        %                 app.LL0Hi.Value = 1.0;
        %
        %                 app.ThighLength.Value = 0.46;
        %                 app.ShankLength.Value = 0.42;
        %                 app.FootLength.Value = 0.26;
        %
        %                 app.BodyMassEditField.Value = 70;
    end
% Menu selected function: EnglishMenu
    function EnglishMenuSelected(~,~)
        UnitsEditField.Value = "English";
        UnitsEditField_2.Value = "English";
        %convert values to english
        %                 convVar = 39.37; %convert from m to in by multiplying by this variable
        %                 convVarB = 2.205; %conversion variable for kg to lbs
        %
        %                 app.RLo.Value = app.RLo.Value * convVar;
        %                 app.RHi.Value = app.RHi.Value * convVar;
        %                 app.L0Lo.Value = app.L0Lo.Value * convVar;
        %                 app.L0Hi.Value = app.L0Hi.Value * convVar;
        %                 app.LL0Lo.Value = app.LL0Lo.Value * convVar;
        %                 app.LL0Hi.Value = app.LL0Hi.Value * convVar;
        %
        %                 app.ThighLength.Value = app.ThighLength.Value * convVar;
        %                 app.ShankLength.Value = app.ShankLength.Value * convVar;
        %                 app.FootLength.Value = app.FootLength.Value * convVar;
        %
        %                 app.BodyMassEditField.Value = app.BodyMassEditField.Value * convVarB;
    end
% Show the rest of the variables
    function visible()
         AntiAssistanceCheckBox.Visible = 'on';
         TriesEditFieldLabel.Visible = 'on';
         TriesEditField.Visible = 'on';
         ofstackedelementsperjointDropDownLabel.Visible = 'on';
         ofstackedelementsperjointDropDown.Visible = 'on';
         SpringStiffnessPanel.Visible = "on";
         RunButton.Visible = "on";         
    end
%If the Knee Torque button is pushed
    function KneeTorque(~,~)
        S.case = 1.1; % Knee-Ankle
        TabGroup.SelectedTab = ExoNETTab;
        uiwait(UIFigure);
        S = setUpLeg(S); % set variables and plots
        S = robustOptoLeg(S);
        S.e = S.TAUsDESIRED - S.TAUs;
    end
%If the Hip knee torque button is pushed
    function HipTorque(~,~)
        S.case = 1.2; %Hip-Ankle
        TabGroup.SelectedTab = ExoNETTab;
        uiwait(UIFigure);
        S = setUpLeg(S); % set variables and plots
        S = robustOptoLeg(S);
        S.e = S.TAUsDESIRED - S.TAUs;
        S.AvgPercentError = 100*(1-(norm(e)/norm(S.TAUsDESIRED)));
        %showGraphTorquesLeg(S)
    end
%If the gait stablization button is pushed
    function GaitStable(~,~)
        S.case = 2; 
        %Gait stabilization uses information obtained from eith hip or knee
        %buttons
        S = setUpLeg(S);
        
        % ***************************************************************************
        % Draw new Torque Arrows on top of the Gait Torque Field in the Angles Plane
        % ***************************************************************************
        a = 10;
        b = 45;
        c = 77;
        d = 101;
        
        outer = zeros(length(S.PHIs),2);
        inner = zeros(length(S.PHIs),2);
        
        
        % Draw outer path
        xDist = linspace(-3,0,a)';
        outer(1:a,1) = S.PHIs(1:a,1) + xDist;
        outer(1:a,2) = S.PHIs(1:a,2) - 2;
        
        xDist = [linspace(0,2,15)'; 2*ones(b-a-25,1); linspace(2,0,10)'];
        outer(a+1:b,1) = S.PHIs(a+1:b,1) + xDist;
        outer(a+1:b,2) = S.PHIs(a+1:b,2) - 2;
        
        xDist = [linspace(0,-4,15)'; -4*ones(c-b-25,1); linspace(-4,0,10)'];
        outer(b+1:c,1) = S.PHIs(b+1:c,1) + xDist;
        yDist = linspace(-2,2,c-b)';
        outer(b+1:c,2) = S.PHIs(b+1:c,2) + yDist;
        
        xDist = linspace(0,4,d-c)';
        outer(c+1:d,1) = S.PHIs(c+1:d,1) + xDist;
        yDist = linspace(2,-2,d-c)';
        outer(c+1:d,2) = S.PHIs(c+1:d,2) + yDist;
        
        
        % Draw inner path
        xDist = linspace(1,0,a)';
        inner(1:a,1) = S.PHIs(1:a,1) + xDist;
        inner(1:a,2) = S.PHIs(1:a,2) + 2;
        
        xDist = [linspace(0,-2,10)'; -2*ones(b-a-20,1); linspace(-2,0,10)'];
        inner(a+1:b,1) = S.PHIs(a+1:b,1) + xDist;
        inner(a+1:b,2) = S.PHIs(a+1:b,2) + 2;
        
        xDist = [linspace(0,4,15)'; 4*ones(c-b-25,1); linspace(4,0,10)'];
        inner(b+1:c,1) = S.PHIs(b+1:c,1) + xDist;
        yDist = linspace(2,-2,c-b)';
        inner(b+1:c,2) = S.PHIs(b+1:c,2) + yDist;
        
        xDist = linspace(0,-4,d-c)';
        inner(c+1:d,1) = S.PHIs(c+1:d,1) + xDist;
        yDist = linspace(-2,2,d-c)';
        inner(c+1:d,2) = S.PHIs(c+1:d,2) + yDist;
        
        
        % Angle position of the Arrow Torques
        S.ArrowPHIs = [outer; inner];
        
        scaleTau = 0.2;
        
        % Arrow Torques
        S.ArrowTAUsDESIRED = [S.PHIs - S.ArrowPHIs(1:length(S.PHIs),:);
        S.PHIs - S.ArrowPHIs(length(S.PHIs)+1:end,:)]/scaleTau;
        
        S.AllPHIs = [S.PHIs; S.ArrowPHIs];
        S.AllTAUsDESIRED = [S.TAUsDESIRED; S.ArrowTAUsDESIRED];
        
        %=============================================
        %drawArrows
        S = robustOptoLeg(S);
        S.e = S.ALLTAUsDESIRED - S.TAUs;
    end
%If the leg design optomization button is pushed
    function DesignOpto(~,~)
        S.case = 3;  %Leg Opto
        S = designOpto(S);
    end

end