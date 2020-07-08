function data = process_thickness_map(data,...
    min_distance, max_distance, this_data_name)
    % Here, we take a data volume, extract all valid data (i.e., that which
    % is above some minimum and below some maximum), return the data, and
    % display the percentiles of the dataset.
    % Begin...
    % Let's cull the data
    data = data(data > min_distance & data <= max_distance);
    % Get the 25th, 50th, 75th percentiles
    prct = prctile(data, [25, 50, 75]);
    % Report it
    disp([this_data_name, ' 25, 50, 75 percentiles are: ', num2str(prct)]);
end