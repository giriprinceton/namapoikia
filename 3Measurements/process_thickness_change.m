function [A_thickness_collector, B_thickness_collector] = process_thickness_change(sample_A,...
    sample_A_dims, sample_A_step, sample_A_binary, sample_A_binary_dims, ...
    sample_B, sample_B_dims, sample_B_step)
    % This function can be run by loading in the change_workspace and then
    % calling it:
    % load('change_workspace.mat');
    % process_thickness_change(sample_A,...
    % sample_A_dims, sample_A_step, sample_A_binary, sample_A_binary_dims, ...
    % sample_B, sample_B_dims, sample_B_step)
    close all
    %% SOME DEFINITIONS
    figure_width = 1.4;
    %% LOAD DATA
    % Load up sample A
    sample_A = load_raw_data(sample_A, sample_A_dims, 'float32');
    % Now, permute sample A, such that we can process it down the 3rd
    % dimension
    sample_A = permute(sample_A, [2,3,1]);
    % Let us also load sample_A_binary
    sample_A_binary = load_raw_data(sample_A_binary, sample_A_binary_dims, 'uint8');
    % Let us also permute this volume
    sample_A_binary = permute(sample_A_binary, [2,3,1]);
    A_thickness_collector = process_slices(sample_A, true, sample_A_binary, .80);
    % Next, let's load in sample B
    sample_B = load_raw_data(sample_B, sample_B_dims, 'float32');
    % Flip the 3rd dim so we're going from top to bottom
    sample_B = flip(sample_B, 3);
    B_thickness_collector = process_slices(sample_B, false, [], 0);
    %% PLOTTING
    % Starting with A
    % 50th percentile
    A_to_plot = A_thickness_collector(:,2);
    % Find the first non-nan value in A
    first_non_nan = find(~isnan(A_to_plot), 1);
    % And the last non-nan value in A
    last_non_nan = find(~isnan(A_to_plot), 1, 'last');
    % Edit A_to_plot to remove the NaN values
    A_to_plot = A_to_plot(first_non_nan:last_non_nan);
    % Now, we have cleaned data...!
    % Begin with a box plot of the data
    subplot(2,2,1);
    boxplot(A_to_plot);
    ylim([500, 1200]);
    pbaspect([figure_width, figure_width, 1]);
    subplot(2,2,3);
    % Produce the height values
    % Note that we multiply the slice number by the step size to get true
    % height...
    A_height_values = [(1:length(A_to_plot)) * sample_A_step]';
    % Here, we attempt to detrend the data using two methods (i.e, with and
    % without outliers)
    [fit_A_without, fit_A_with, detrended_A_without, detrended_A_with] =...
        detrend_thickness(A_height_values, A_to_plot);
    % R value of trend A and A_to_plot?
    r_A = corrcoef(A_to_plot, A_to_plot - detrended_A_with);
    % What is the r^2?
    r_2_A = r_A(2) ^ 2
    % Mean of A?
    mean_A = mean(A_to_plot);
    % Now, let's plot A
    % Note the flip of X and Y!
    % subtract the mean!
    plot(A_to_plot - mean_A, A_height_values);
    hold on

    % Let's also plot the two trends
    plot(A_to_plot - detrended_A_with - mean_A, A_height_values);
    plot(A_to_plot - detrended_A_without - mean_A, A_height_values);
    % disp(['Mean A value: ', num2str(mean_A)]);
    % Show mean value
    % line(ones(2,1) * nanmean(A_thickness_collector(:,2)), ylim);
    % Set the X lim...
    xlim([-450, 450]);
    ylim([0, 4.5e4]);
    pbaspect([figure_width, 4.5, 1]);
    grid on
    % Save the ylim
    A_ylim = ylim;
    % Now, sample B
    subplot(2,2,2)
    % What are we plotting? 50th percentile
    B_to_plot = B_thickness_collector(:,2);
    % Box plot
    boxplot(B_to_plot);
    ylim([500, 1200]);
    pbaspect([figure_width, figure_width, 1]);
    B_height_values = ((1:length(B_to_plot)) * sample_B_step)';
    % Let's detrend the data
    [fit_B_without, fit_B_with, detrended_B_without, detrended_B_with] =...
        detrend_thickness(B_height_values, B_to_plot);
    r_B = corrcoef(B_to_plot, B_to_plot - detrended_B_with);
    % What is the r^2?
    r_2_B = r_B(2) ^ 2
    % Now, let's plot B
    mean_B = mean(B_to_plot);
    subplot(2,2,4);
    % subtract the mean!
    plot(B_to_plot - mean_B, B_height_values);
    hold on
    % Let's also plot the trends

    plot(B_to_plot - detrended_B_with - mean_B, B_height_values);
    plot(B_to_plot - detrended_B_without - mean_B, B_height_values);
    xlim([-450, 450]);
    pbaspect([figure_width, 4.5, 1]);
    grid on
    % Show mean value
    % line(ones(2,1) * nanmean(B_thickness_collector(:,2)), ylim);    
    % Set y lim to match A
    ylim(A_ylim);
    %% PRINT
    output_location = 'Thickness_Change_Plots';
    if ~isfolder(output_location)
        mkdir(output_location);
    end
    print(fullfile(output_location, 'thickness_change.eps'), '-painters', '-depsc');
end
function thickness_collector = process_slices(data, use_binary, binary_data, threshold)
    waiting = waitbar(0, 'Processing data');
    % Now, for each slice of data
    num_slices = size(data, 3);
    thickness_collector = zeros(num_slices, 3);
    percent_collector = zeros(num_slices, 1);
    septa_collector = zeros(num_slices, 1);
    for sl = 1:num_slices
        this_slice = data(:, :, sl);
        process_this_slice = true;
        % If use_binary is true
        if use_binary
            this_binary_slice = binary_data(:, :, sl);
            % Now, anything less than 2 is part of the volume
            part_of_volume = this_binary_slice(this_binary_slice < 2);
            % And anything that is 1 is septa
            septa = this_binary_slice(this_binary_slice == 1);
            % Okay, what percent of this slice is true data?
            this_slice_true_data = numel(part_of_volume) / numel(this_binary_slice);
            % How about septa?
            this_slice_septa = numel(septa) / numel(part_of_volume);
            if this_slice_true_data < threshold
                process_this_slice = false;
            end
            percent_collector(sl) = this_slice_true_data;
            septa_collector(sl) = this_slice_septa;
        end
        if process_this_slice
            % Only get data greater than 1
            measurements = this_slice(this_slice > 1);
            % Calculate pcts
            percentiles = prctile(measurements, [25, 50, 75]);
            thickness_collector(sl, :) = percentiles;
        else
            thickness_collector(sl, :) = NaN;
        end
        waitbar(sl/num_slices, waiting);
    end
    close(waiting);
end

function [fit_without, fit_with, data_y_without, data_y_with] = detrend_thickness(data_x, data_y)
    % Begin by finding outliers of data_y
    outlier_idx = isoutlier(data_y);
    % Now, find two fits
    % Without outliers
    fit_without = polyfit(data_x(~outlier_idx), data_y(~outlier_idx), 1);
    % With outliers
    fit_with =  polyfit(data_x, data_y, 1);
    % Let's also detrend the data
    data_y_without = data_y - ((fit_without(1) * data_x) + fit_without(2));
    data_y_with = data_y - ((fit_with(1) * data_x) + fit_with(2));
end