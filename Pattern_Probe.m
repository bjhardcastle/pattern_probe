function varargout = Pattern_Probe(varargin)
% This is a gui for probing receptive fields of cells. BJH June 2017
% Based on Pattern_Player by M Reiser
% Requires Pattern_Probe on SD card as pattern #1 and Pattern_Probe.fig
% in the same folder as this .m file 


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Pattern_Probe_OpeningFcn, ...
                   'gui_OutputFcn',  @Pattern_Probe_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before Pattern_Probe is made visible.
function Pattern_Probe_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Pattern_Player (see VARARGIN)
Panel_com('stop');

try
    [I, map] = imread('loading.bmp', 'BMP');
catch
   [I, map] = imread('Please_load.bmp', 'BMP'); % iorodeo version
end
axes(handles.axes1); 
colormap(map);
image(I);
axis off; axis image; 

axes(handles.axes1); 
axis off; axis image; 

handles.output = hObject;
handles.x_rate = 0;
handles.y_rate = 0;
handles.x_pos = 1;
handles.y_pos = 1;
handles.pattern_x_size = 1;
handles.pattern_y_size = 1;
handles.pattern_obj_size = 1;
handles.Playing = 0;
handles.x_fig_pos = 1;
handles.y_fig_pos = 1;
handles.hold_ON = 0;
handles.Pointer = 0;

%for smooth graphics
set(gcf,'DoubleBuffer','on');

% Update handles structure
guidata(hObject, handles);
PControl
pause(5)
Panel_com('set_pattern_id',1);
pause(0.1)
menu_load_pattern(hObject, eventdata, handles)

% --- Outputs from this function are returned to the command line.
function varargout = Pattern_Probe_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

% --- Executes during object creation, after setting all properties.
function jigglebutton_CreateFcn(hObject, eventdata, handles)
guidata(hObject, handles);

% --- Executes on button press in togglebutton1 (flips x/y scroll).
function togglebutton1_Callback(hObject, eventdata, handles)
switch get(handles.togglebutton1,'Value')
    case 1
        set(handles.togglebutton1,'Value', 1);
        set(handles.togglebutton1,'String','Press to scroll X');
        guidata(hObject, handles);
    case 0
        set(handles.togglebutton1,'Value', 0);
        set(handles.togglebutton1,'String','Press to scroll Y');
        guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function x_pos_val_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on data entry in x_pos_val.
function x_pos_val_Callback(hObject, eventdata, handles)
user_entry = str2double(get(hObject,'string'));
if isnan(user_entry)
    errordlg('You must enter a numeric value','Bad Input','modal')
    set(handles.x_pos_val, 'string', num2str(handles.x_pos));
elseif (user_entry ~= round(user_entry) )
    errordlg('You must enter an integer','Bad Input','modal')
    set(handles.x_pos_val, 'string', num2str(handles.x_pos));
elseif ( (user_entry < 0)|(user_entry > handles.pattern_x_size) )
    errordlg('Number is out of the range for this pattern','Bad Input','modal')
    set(handles.x_pos_val, 'string', num2str(handles.x_pos));
else  % once you get here this is actually good input
    handles.x_pos = user_entry;
    guidata(hObject, handles);
end
update_panelsFcn(hObject, eventdata, handles)

% --- Executes on button press in x_pos_plus.
function x_pos_plus_Callback(hObject, eventdata, handles)
% increment the x_pos, wrap around if too big
temp_pos = handles.x_pos + 1;
if (temp_pos > handles.pattern_x_size)
    temp_pos = 1;
end
handles.x_pos = temp_pos;
set(handles.x_pos_val, 'string', num2str(temp_pos));
guidata(hObject, handles);
update_panelsFcn(hObject, eventdata, handles)


% --- Executes on button press in x_pos_minus.
function x_pos_minus_Callback(hObject, eventdata, handles)
% decrement the x_pos, wrap around if hits zero
temp_pos = handles.x_pos - 1;
if (temp_pos <= 0) 
    temp_pos = handles.pattern_x_size;
end
handles.x_pos = temp_pos;
set(handles.x_pos_val, 'string', num2str(temp_pos));
guidata(hObject, handles);
update_panelsFcn(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function y_pos_val_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on data entry in y_pos_val.
function y_pos_val_Callback(hObject, eventdata, handles)
user_entry = str2double(get(hObject,'string'));
if isnan(user_entry)
    errordlg('You must enter a numeric value','Bad Input','modal')
    set(handles.y_pos_val, 'string', num2str(handles.y_pos));
elseif (user_entry ~= round(user_entry) )
    errordlg('You must enter an integer','Bad Input','modal')
    set(handles.y_pos_val, 'string', num2str(handles.y_pos));
elseif ( (user_entry < 0)|(user_entry > handles.pattern_y_size) )
    errordlg('Number is out of the range for this pattern','Bad Input','modal')
    set(handles.y_pos_val, 'string', num2str(handles.y_pos));
else  % once you get here this is actually good input
    handles.y_pos = user_entry;
    guidata(hObject, handles);
end
update_panelsFcn(hObject, eventdata, handles)

% --- Executes on button press in y_pos_plus.
function y_pos_plus_Callback(hObject, eventdata, handles)
% increment the y_pos, wrap around if too big
temp_pos = handles.y_pos + 1;
if (temp_pos > handles.pattern_y_size)
    temp_pos = 1;
end
handles.y_pos = temp_pos;
set(handles.y_pos_val, 'string', num2str(temp_pos));
guidata(hObject, handles);
update_panelsFcn(hObject, eventdata, handles)

% --- Executes on button press in y_pos_minus.
function y_pos_minus_Callback(hObject, eventdata, handles)
% decrement the y_pos, wrap around if hits zero
temp_pos = handles.y_pos - 1;
if (temp_pos <= 0) 
    temp_pos = handles.pattern_y_size;
end
handles.y_pos = temp_pos;
set(handles.y_pos_val, 'string', num2str(temp_pos));
guidata(hObject, handles);
update_panelsFcn(hObject, eventdata, handles)

% --- Executes on button press in Panel_check.
function Panel_check_Callback(hObject, eventdata, handles)
display_curr_frame(handles);

% --- Executes on button press in Pixel_check.
function Pixel_check_Callback(hObject, eventdata, handles)
display_curr_frame(handles);

% --- Executes on button press in Address_Check.
function Address_check_Callback(hObject, eventdata, handles)
display_curr_frame(handles);

% Get mouse position, change cursor, conver position in GUI display to position on Panels 
function get_panel_position(hObject, eventdata, handles)

figurePos = get(hObject,'Position');

% get the current position of the mouse
mousePos = get(hObject,'CurrentPoint');
mouseX   = mousePos(1);
mouseY   = mousePos(2);

uiControlPos = get(handles.axes1,'Position');

% create the x and y lower (L) and upper (U) bounds (we assume that the
% GUI is resizeable so the child position array contains proportions
% relative to the parent GUI)
uiControlXL  = uiControlPos(1)*figurePos(3);
uiControlXU  = (uiControlPos(1)+uiControlPos(3))*figurePos(3);
uiControlYL = uiControlPos(2)*figurePos(4);
uiControlYU = (uiControlPos(2)+uiControlPos(4))*figurePos(4);

% check to see if the mouse is over the control
if mouseX>uiControlXL && mouseX<uiControlXU && ...
        mouseY>uiControlYL && mouseY<uiControlYU
    
    % change mouse cursor
    set(handles.output, 'Pointer', 'crosshair');
    handles.Pointer = 1;
    
    % and get mouse position in terms of LEDs in Panels
    temp_x_fig_pos = mod(ceil((handles.pattern_x_size*(mouseX-uiControlXL)/(uiControlXU - uiControlXL))  - 0.5*handles.pattern_obj_size),handles.pattern_x_size);
    if temp_x_fig_pos == 0
        temp_x_fig_pos = 1;
    end
    handles.x_fig_pos = temp_x_fig_pos;
    handles.y_fig_pos = ceil((handles.pattern_y_size*(mouseY-uiControlYL)/(uiControlYU - uiControlYL))   );
    guidata(hObject, handles);
    
else
    % change the mouse cursor to the default arrow
    set(handles.output, 'Pointer', 'arrow');
    handles.Pointer = 0;
end

guidata(hObject, handles);

 % Load pattern and initialise some variables
function menu_load_pattern(hObject, eventdata, handles)

load([mfilename '.mat']);

handles.pattern = pattern;

handles.pattern_x_size = pattern.x_num;
handles.pattern_y_size = pattern.y_num;
handles.pattern_obj_size = pattern.x_obj_size;
handles.x_pos = floor(0.5*(handles.pattern_x_size - handles.pattern_obj_size));
set(handles.x_pos_val, 'string', num2str(handles.x_pos));
set(handles.x_pos_val, 'enable', 'on');
set(handles.x_pos_val, 'string', num2str(handles.x_pos));
set(handles.x_pos_val, 'enable', 'on');
handles.y_pos = 1;
set(handles.y_pos_val, 'string', num2str(handles.y_pos));
set(handles.y_pos_val, 'enable', 'on');
handles.x_fig_pos = handles.x_pos;
handles.y_fig_pos = handles.y_pos;
set(handles.y_pos_plus, 'enable', 'on');
set(handles.y_pos_minus, 'enable', 'on');
set(handles.x_pos_plus, 'enable', 'on');
set(handles.x_pos_minus, 'enable', 'on');
set(handles.togglebutton1,'enable', 'on');
set(handles.togglebutton1,'value', 0);
set(handles.jigglebutton,'enable', 'on');
set(handles.jigglebutton,'value', 0);
set(handles.Pixel_check, 'enable', 'on');
set(handles.Pixel_check, 'value', 0);
set(handles.Address_check, 'enable', 'on');
set(handles.Address_check, 'value', 0);
set(handles.Panel_check, 'enable', 'on');
set(handles.Panel_check, 'value', 0);


guidata(hObject, handles);
cla
update_panelsFcn(hObject, eventdata, handles)

% Update GUI display.
function display_curr_frame(handles)
% the color maps
switch handles.pattern.gs_val
    case 1
        C = [0 0 0; 0 1 0];   % 2 colors - on / off
    case 2
        C = [0 0 0; 0 1/3 0; 0 2/3 0; 0 1 0]; % 4 levels of gscale    
    case 3
        C = [0 0 0; 0 2/8 0; 0 3/8 0; 0 4/8 0; 0 5/8 0; 0 6/8 0; 0 7/8 0; 0 1 0];  % 8 levels of gscale        
    case 4
        C = [0 0 0; 0 2/16 0; 0 3/16 0; 0 4/16 0; 0 5/16 0; 0 6/16 0; 0 7/16 0; 0 8/16 0; ...
            0 9/16 0; 0 10/16 0; 0 11/16 0; 0 12/16 0; 0 13/16 0; 0 14/16 0; 0 15/16 0; 0 1 0];  % 16 levels of gscale        
    otherwise
        error('the graycale value is not appropriately set for this pattern - must be 1, 2, 3, or 4');
end

axes(handles.axes1)
% here we add a one to the image to correctly index into the color map
%imshow(handles.pattern.Pats(:,:,handles.x_pos,handles.y_pos)+1, C, 'notruesize')
cla
% place to adjust displayed image for row_compression - 
row_compression = 0;
if isfield(handles.pattern, 'row_compression') % for backward compatibility
    if (handles.pattern.row_compression)
        row_compression = 1;
    end
end
if row_compression % this is probably incorrect for multi-row row compressed pats.
    image(repmat(handles.pattern.Pats(:,:,handles.x_pos,handles.y_pos)+1, 8, 1));
else
    image(handles.pattern.Pats(:,:,handles.x_pos,handles.y_pos)+1);
end    
axis off; 
axis image; 
colormap(C);
hold on
[numR, numC] = size(handles.pattern.Panel_map);
numRows = numR*8;
numCols = numC*8;
% plot Pixel_lines
if (get(handles.Pixel_check,'Value') == get(handles.Pixel_check,'Max'))
    %make horizontal lines
    for j = 1.5:numRows
            plot([0.5 numCols + 0.5], [j j],'w');
    end
    %make vertical lines
    for j = 1.5:numCols
            plot([j j], [0.5 numRows + 0.5],'w');
    end
        % plot Panel_lines
end
    
if(get(handles.Panel_check,'Value') == get(handles.Panel_check,'Max'))
    for j = 1.5:numRows
        if (mod(j,8) == 0.5) plot([0.5 numCols + 0.5], [j j],'r', 'LineWidth',2);
        end
    end
    %make vertical lines
    for j = 1.5:numCols
        if (mod(j,8) == 0.5) plot([j j], [0.5 numRows + 0.5],'r', 'LineWidth',2);
        end
    end
end

if(get(handles.Address_check,'Value') == get(handles.Address_check,'Max'))
    for i = 1:numR
        for j = 1:numC
            if (handles.pattern.Panel_map(i,j)) >= 10 % 2 digits
                h = text((j-1)*8 + 2,(i-1)*8 + 4,num2str(handles.pattern.Panel_map(i,j)));
            else
                h = text((j-1)*8 + 4,(i-1)*8 + 4,num2str(handles.pattern.Panel_map(i,j)));
            end
            set(h, 'Color', 'm', 'FontSize', 20, 'FontWeight', 'bold');
        end
    end
end

% Update Panels display and then GUI display
function update_panelsFcn(hObject, eventdata, handles)
    
 if handles.hold_ON == 0;
     % Function was called by +- xy buttons, or during startup
         Panel_com('set_position', [handles.x_pos handles.y_pos]);
         pause(0.01)
         guidata(hObject, handles);
          
         % Update GUI display
         display_curr_frame(handles)
 else
    % Function was called by mousebuttonDown in Figure
         handles.x_pos = handles.x_fig_pos;
         handles.y_pos = handles.y_fig_pos;
         
         % Update position displays on GUI
         set(handles.x_pos_val, 'string', num2str(handles.x_pos));
         set(handles.y_pos_val, 'string', num2str(handles.y_pos));

         Panel_com('set_position', [handles.x_pos handles.y_pos]);
         pause(0.01)
         guidata(hObject, handles);
         
         % Update GUI display
         display_curr_frame(handles)

 end   

% Mouse button press - update position, and turn on 'lock' to drag
% (currently not working)
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
    if handles.Pointer == 1
        handles.hold_ON = 1;
        
        guidata(hObject, handles);
        update_panelsFcn(hObject, eventdata, handles)
        
    else
        handles.hold_ON = 0;
        guidata(hObject, handles);
    end

% Mouse button movement - get position and drag if lock is ON 
% (currently not working)
function figure1_WindowButtonMotionFcn(hObject, eventdata, handles)
    get_panel_position(hObject, eventdata, handles);
    
    if handles.hold_ON == 1
        update_panelsFcn(hObject, eventdata, handles)
    end

% Mouse button release - update position         
function figure1_WindowButtonUpFcn(hObject, eventdata, handles)
    if handles.Pointer == 1
        % Mouse is still within figure axes
        get_panel_position(hObject, eventdata, handles);
        handles.hold_ON = 1;
        guidata(hObject, handles);
        update_panelsFcn(hObject, eventdata, handles)
    end
    handles.hold_ON = 0;
    guidata(hObject, handles);

% Jigglebutton function.
function jigglebutton_Callback(hObject, eventdata, handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% For newer version of Panels. Doesn't work on 2p: 
%{
switch get(handles.jigglebutton,'Value')
    case 1 % Just switched ON: start function
        % Make Y position func
        temp_yfunc = circshift( make_sine_wave_function(20, 50, 1), [0,-14]);
        if handles.y_pos < 1.5*handles.pattern_obj_size
            % Current position too close to bottom
            temp_yfunc(temp_yfunc<=0) = 0;
            y_plus = 1; y_minus = floor(handles.y_pos - 0.5*handles.pattern_obj_size);
            if y_minus < 0, y_minus = 0; end
            
        elseif handles.pattern_y_size - handles.y_pos < 1.5*handles.pattern_obj_size
            % Too close to top
            temp_yfunc(temp_yfunc>=0) = 0;
            y_minus = 1; y_plus = floor(handles.pattern_y_size - handles.y_pos - 0.5*handles.pattern_obj_size);
            if y_plus < 0, y_plus = 0; end
            
        else
            y_plus = 1; y_minus = 1;
            
        end
        yfunc = round(2*temp_yfunc);
        
        % Make X position func
        temp_xfunc = make_sine_wave_function(20, 50, 1);
        if handles.x_pos < 1.5*handles.pattern_obj_size
            % Current position too close to left
            temp_func(temp_xfunc<=0) = 0;
            x_plus = 1; x_minus = floor(handles.x_pos - 0.5*handles.pattern_obj_size);
            if x_minus < 0, x_minus = 0; end
        elseif handles.pattern_x_size - handles.x_pos < 1.5*handles.pattern_obj_size
            % Too close to top
            temp_func(temp_xfunc>=0) = 0;
            x_minus = 1; x_plus = floor(handles.pattern_x_size - handles.x_pos - 0.5*handles.pattern_obj_size);
            if x_plus < 0, x_plus = 0; end
        else
            x_plus = 1; x_minus = 1;
        end
        xfunc = round(2*temp_xfunc);
        
        Panel_com('set_posFunc_id',[1 0]);
        pause(0.01)
        Panel_com('set_posFunc_id',[2 0]);
        pause(0.01)
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% For 2p - just move back and forth +/- 1 pixel:
x_plus = 1; x_minus = 1;
y_plus = 1; y_minus = 1;
while  get(handles.jigglebutton,'Value') == 1
    
  switch get(handles.togglebutton1,'Value')
      case 0 % x
          x_start = handles.x_pos;
    for jj = [0:x_plus, x_plus:-1:-x_minus, -x_minus:1:0]        
        % Update position displays on GUI
        handles.x_pos = x_start + jj;
        set(handles.x_pos_val, 'string', num2str(handles.x_pos));
        % Update Panels
        update_panelsFcn(hObject, eventdata, handles)
        pause(0.05)
    end
        
        case 1 % y
          y_start = handles.y_pos;
    for jj = [0:y_plus, y_plus:-1:-y_minus, -y_minus:1:0]        
        % Update position displays on GUI
        handles.y_pos = y_start + jj;
        set(handles.y_pos_val, 'string', num2str(handles.y_pos));
        % Update Panels
        update_panelsFcn(hObject, eventdata, handles)
        pause(0.05)
    end
  end
end

% Executes on scroll wheel motion while the figure is in focus.
function figure1_WindowScrollWheelFcn(hObject, eventdata, handles)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	VerticalScrollCount: signed integer indicating direction and number of clicks
%	VerticalScrollAmount: number of lines scrolled for each click
if handles.Pointer == 1
    switch get(handles.togglebutton1,'Value')
        
        case 0 % Scroll X
            if eventdata.VerticalScrollCount > 0 % Negative X
                temp_pos = handles.x_pos + 1;
                if (temp_pos > handles.pattern_x_size)
                    temp_pos = 1;
                end
                
            elseif eventdata.VerticalScrollCount < 0 % Positive X = scroll up
                temp_pos = handles.x_pos - 1;
                if (temp_pos <= 0)
                    temp_pos = handles.pattern_x_size;
                end
            end
            
            handles.x_pos = temp_pos;
            
            % Update position displays on GUI
            set(handles.x_pos_val, 'string', num2str(handles.x_pos));
            guidata(hObject, handles);
            update_panelsFcn(hObject, eventdata, handles)
            
        case 1 % Scroll Y
            if eventdata.VerticalScrollCount < 0 % Positive Y = scroll up
                temp_pos = handles.y_pos + 1;
                if (temp_pos > handles.pattern_y_size)
                    temp_pos = 1;
                end
                
            elseif eventdata.VerticalScrollCount > 0 % Negative Y
                temp_pos = handles.y_pos - 1;
                if (temp_pos <= 0)
                    temp_pos = handles.pattern_y_size;
                end
            end
            
            handles.y_pos = temp_pos;
            
            % Update position displays on GUI
            set(handles.y_pos_val, 'string', num2str(handles.y_pos));
            guidata(hObject, handles);
            update_panelsFcn(hObject, eventdata, handles)
            
    end
end

% Reload function
function reloadbutton_Callback(hObject, eventdata, handles)
Panel_com('set_pattern_id',1);
pause(0.1)
Panel_com('set_posFunc_id',[1 0]);
pause(0.01)
Panel_com('set_posFunc_id',[2 0]);
pause(0.01)
%  guidata(hObject, handles);
update_panelsFcn(hObject, eventdata, handles)

