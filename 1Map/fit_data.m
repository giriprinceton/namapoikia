function fit_data(directory, location_points)
    close all
    % First, load the shapefile
    info = shapeinfo(fullfile(directory, location_points));
    [data, attributes] = shaperead(fullfile(directory, location_points));
    % Data X and Data Y
    data_x = [data.X];
    data_y = [data.Y];
    % Empty points matrix
    points = zeros(info.NumFeatures, 1);
    fit_fig = figure;
    % I. Begin by looking for any points with ONLY cover ... any place with
    % some rock is not covered
    % Determining where outcrop is should be done by looking for
    % 0s in all attributes except for Comment, Feat_Name, GNSS_Heigh,
    % Latitude, Longitude, trimple_po, trimble__1, trimble __2, garmin_poi,
    % descritptio, C, POINT_X, and POINT_Y - so, in this case, 1:10, 13 and
    % end-1:end are the indicies
    % This is janky, I know.
    attribute_cells = struct2cell(attributes);
    selected_attributes = cell2mat(attribute_cells([11:12, 14:end-2], :)');
    % These are the points that have some sort of outcrop (even if they
    % include cover, see above)
    some_outcrop_pts = find(max(selected_attributes, [], 2));
    % Here are the hardcoded parts, sorry :(
    % Fit an experimental
    [o_g, o_h, o_p] = fit_semi(points, data_x, data_y, some_outcrop_pts);
    % Try an exponential
    [o_r, o_s, o_n, o_fit] = fit_model(o_h, o_g, [.25; .25],...
        {'exponential'; 'spherical'});
    figure(fit_fig);
    subplot(2, 2, 1);
    o_spec = label_fit('Presence of Outcrop', o_fit);
    % 
    % II. Now, all points with any sort of microbial features
    % These include: Tm (Throm Mounding), Strom Encrustions (Se), Columnar
    % Throms (Tc), Columnar (Co), Stroms (So), and Throm (T)
    % We're leaving out Microbial Texture (in all of its forms) and Mounds
    microbial_pts = find(...
        ([attributes.Tm] | [attributes.Se]  | [attributes.Tc] | ...
        [attributes.Co] | [attributes.So] | [attributes.T]));
    % Fit an experimental
    [m_g, m_h, m_p] = fit_semi(points, data_x, data_y, microbial_pts);
    % Try an exponential
    [m_r, m_s, m_n, m_fit] = fit_model(m_h, m_g, [.15; .05],...
        {'exponential'; 'spherical'});
    figure(fit_fig);
    subplot(2, 2, 2);
    m_spec = label_fit('Presence of Microbial Textures', m_fit);
    % III. All Namapoikia. In the field, this was referred by Sinuous Texture (St)
    nama_pts = find([attributes.St]);
    % Fit an experimental
    [n_g, n_h, n_p] = fit_semi(points, data_x, data_y, nama_pts);
    % Try an exponential
    [n_r, n_s, n_n, n_fit] = fit_model(n_h, n_g, [.025; .025],...
        {'exponential'; 'spherical'});
    figure(fit_fig);
    subplot(2, 2, 3);
    n_spec = label_fit('Presence of Namapoikia', n_fit);
    % Output
    % Totally hand done
    vario_specs = {o_spec{1}, m_spec{1}, n_spec{2}};
    out_points = [o_p, m_p, n_p];
    classes = {'Outcrop', 'Microbial', 'Namapoikia'};
    save('vario_specs', 'vario_specs');
    save('out_points', 'out_points');
    save('classes', 'classes');
    % Print the fit_fig
    print -painters -depsc fit_figure.eps
end




