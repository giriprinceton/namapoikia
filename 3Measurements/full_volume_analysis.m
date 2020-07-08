function all_processed_data = full_volume_analysis(thickness_maps, titles,...
    data_dims, min_distance, bin_spacing, remove_large_elements, large_threshold,...
    output_location)
    % Here, we load in thickness maps and then produce histograms from
    % them. 
    % thickness_maps is a 1xm cell array that contains a list of raw data
    % files for processing.
    % titles is a 1xm cell array that tells us the title of each thickness
    % map. Note that titles are also used for output file names. 
    % data_dims is a 1xm cell array that tells us the dimensions of the raw
    % data
    % min_distance is a 1xm matrix that provides scalar values to threshold
    % the thickness maps by. Here, we're using a convention of 2x the voxel
    % resolution as a threshold.
    % remove_large_elements is a 1xm boolean matrix that tells us whether
    % to threshold the thickness maps to recalculate the thickness values.
    % large_threshold is a 1xm matrix that contains the value to threshold by for
    % remove_large_elements. 
    % output_location is the location where to store the final figures
    % Note that, for Mehra et al 2020, you can just load in the
    % thickness_workspace and then run this command as written
    % i.e.,
    % clear all
    % load('thickness_workspace');
    % Fig3ThicknessHistograms(thickness_maps, titles, data_dims,...
    % min_distance, bin_spacing, remove_large_elements, large_threshold, output_location);
    % Great, for each thickness map
    close all
    % Create a cell collector for all processed data
    all_processed_data = {};
    % Check to see if output directory exists
    if ~isfolder(output_location)
        mkdir(output_location);
    end
    for x = 1:length(thickness_maps)
        % Create a new figure
        figure;
        % Load up the data
        data = load_raw_data(thickness_maps{x}, data_dims{x}, 'float32');
        % Okay, now let's process the thickness map
        processed_data = process_thickness_map(data, min_distance(x), ...
            max(data(:)), titles{x});
        % Let's plot up a histogram
        % First, set up the centers
        centers = bin_spacing/2:bin_spacing:ceil(max(processed_data) / bin_spacing) * bin_spacing;
        % Convert to edges
        edges = centers_to_edges(centers);
        % Plot
        histogram(processed_data, edges, 'Normalization', 'Probability');
        % Set the plot aspects
        set_plot_aspects([titles{x}, '_histogram'], output_location);
        % Add processed_data to all_processed_data
        all_processed_data{x} = processed_data;
        % Now, should we remove large elements?
        if remove_large_elements(x)
            % New figure
            figure;
            % Modified title
            modified_title = [titles{x}, '_large_elements_removed'];
            % Processed v2!
            large_elements_removed = process_thickness_map(data,...
                min_distance(x), large_threshold(x),...
                modified_title);
            % Plot it up
            centers = 0:bin_spacing:ceil(max(large_elements_removed) / bin_spacing) * bin_spacing;
            % Convert to edges
            edges = centers_to_edges(centers);
            histogram(processed_data, edges, 'Normalization', 'Probability');
            set_plot_aspects(modified_title, output_location);
        end
    end
end

function set_plot_aspects(this_plot_title, output_location)
    % Set pbaspect ratio
    pbaspect([3.5,2.5,1]);
    % Set grid
    grid on
    % Title
    title(this_plot_title, 'Interpreter', 'none');
    xlabel('Thickness, microns');
    ylabel('Proportion');
    xlim([0, 8000]);
    ylim([0, 0.10]);
    % Brobro, it is time to print!
    print(fullfile(output_location, this_plot_title), '-depsc', '-painters');
end

