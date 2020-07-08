function determine_nama_b_extents
    % Pixel dimensions, assumes square pixels, in microns
    pixel_dim = 42.33;
    close all
    % We pull up a nama_b image
    nama_b = imread('001.jpg');
    figure
    hold on
    % We plot it
    imshow(nama_b)
    % We the draw a line between two points for the vertical measure
    vert_x = [210; 210];
    vert_y = [287; 2477];
    line(vert_x, vert_y, 'Color', 'red');
    % We also draw a line between two points for the vertical measure
    horz_x = [161; 2555];
    horz_y = [295; 295];
    line(horz_x, horz_y, 'Color', 'blue');
    % Distances
    vert_dist = pdist([vert_x, vert_y]);
    horz_dist = pdist([horz_x, horz_y]);
    % Field of view calc
    vert_dist_microns = vert_dist * pixel_dim;
    horz_dist_microns = horz_dist * pixel_dim;
    % Report
    disp(['Vertical field of view is: ', num2str(vert_dist), ' pixels and ', ...
        num2str(vert_dist_microns), ' microns']);
    disp(['Horizontal field of view is: ', num2str(horz_dist), ' pixels and ', ...
        num2str(horz_dist_microns), ' microns']);
end