% Pattern by BJH May 2017
% For Pattern_Probe function: moves a grating patch around the arena for
% probing receptive field of cells in 2p
% Binary pattern
% x-frames:  x-position of grating
% y-frames:  y-postion of grating
%

grating_pixels_ONOFF = 3; % number of pixels on/off (half-wavelength)
patch_size = 2; % square patch with height and width equal to patch_size pixels

% Save location
directory_name = pwd;

spatial_freq = roundn(1/(grating_pixels_ONOFF*2*2.2), -3); %cyc/deg.  2.2 deg per pixel in 2p arena
file_name ='\Pattern_Probe';


% MAKE GRATING PATCH

% Initialise the pattern object
% 48 panel pattern
pattern.y_num = 32+1-patch_size;  % y positions of patch (doesn't wrap around)
pattern.x_num = 96;   % x positions of patch (wraps around)
pattern.num_panels = 48;
pattern.gs_val = 1;
pattern.x_obj_size = patch_size;
pattern.y_obj_size = patch_size;

% for 12x4 unique panels in a cylindar
Pats = zeros(32, 96, pattern.x_num, pattern.y_num);

% Prepare entire screen filled with grating
grating = zeros(32, 96, pattern.x_num, pattern.y_num);
grating_full_h = repmat(0.5*(square((2/grating_pixels_ONOFF*47*pi/95)*[1:96])+1), 32, 1);
grating_full_v = repmat(0.5*(square((2/grating_pixels_ONOFF*47*pi/95)*[1:32])+1),96, 1);

% Checkerboard stimulus
% checkerb = grating_full_v'.*grating_full_h;
% grating(1:patch_size,1:patch_size,1,1) = checkerb(1:patch_size,1:patch_size);

% Bright stimulus
checkerb = grating_full_v'.*grating_full_h;
grating(1:patch_size,1:patch_size,1,1) = ones(patch_size,patch_size,1,1);


% Shift grating x_num of steps
for i = 2:pattern.x_num
    
    grating(:,:,i,1) = ShiftMatrix(grating(:,:,i-1,1),1,'r','y');
end

% Shift every grating y_num of steps
for i = 1:pattern.x_num
    for j = 2:pattern.y_num
        %     fprintf(['',num2str(j),'\n'])
        grating(:,:,i,j) = ShiftMatrix(grating(:,:,i,j-1),1,'d','y');
    end
end

% Flip y axis (first y-frame shows object at bottom)
gratingflip = flipdim(grating,1);
% Put into 'pattern'
pattern.Pats = gratingflip;

% Arrange pattern for LED panel addresses

% For old behaviour panel arrangement:
%{
            A = 1:48;
            pattern.Panel_map = flipud(reshape(A, 4, 12));
%}

% For 2p panels:
for i = 1:12
    for j = 1:4
        Panel_mat(j,i) = mod((i-1)*4,12) + ceil(i/3) + (j-1)*12;
    end
end
mat = flipud(Panel_mat);
pattern.Panel_map = fliplr(mat);

% Convert
pattern.BitMapIndex = process_panel_map(pattern);
pattern.data = Make_pattern_vector(pattern);

% Save
str = strcat([directory_name file_name '.mat']); % Grating position
save(str, 'pattern');

