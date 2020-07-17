function all_sub_processed_data = subVolume_analysis(subvolume_thickness_maps, subvolume_data_dims, ...
    subvolume_titles, output_location)
    % Here, we process subvolumes to see if median void spacing differences
    % hold in "ideal" subvolumes of each model
    close all
    if ~isfolder(output_location)
        mkdir(output_location);
    end
    % How many?
    to_study = length(subvolume_thickness_maps);
    % Make a little processed subvolume data collector
    all_sub_processed_data = {};
    % Alright, let's go through each subvolume
    tic;
    data_collector = cell(to_study, 1);
    grouping = cell(to_study, 1);
    for idx = 1:to_study
        % Load up the data
        data = load_raw_data(subvolume_thickness_maps{idx}, subvolume_data_dims{idx}, 'float32');
        keyboard
        % Okay, now let's process the thickness map
        processed = process_thickness_map(data, 1, ...
            max(data(:)), subvolume_titles{idx});
        data_collector{idx} = processed;
        grouping{idx} = idx * ones(length(processed), 1);
        all_sub_processed_data{idx} = processed;
    end
    % Now, collapse the collector
    collapsed_collector = cell2mat(data_collector);
    collapsed_grouping = cell2mat(grouping);
    figure;
    boxplot(collapsed_collector, collapsed_grouping);
    xticklabels(subvolume_titles);
    ylabel('Thickness, microns');
    xlabel('Specimen');
    existing_y_lim = ylim;
    ylim([0, existing_y_lim(2)]);
    pbaspect([3,2,1]);
    line([2.5,2.5], ylim, 'Color', 'black');
    toc;
    grid on;
    print(fullfile(output_location, 'subvolume_analysis.eps'), '-painters', '-depsc');
end