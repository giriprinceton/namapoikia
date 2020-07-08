# Fig. 3

Fig. 3 contains:
1. A comparison plot of voids and skeletal thicknesses for several sponges described in Mehra et. al. 2020.  
2. Plots illustrating the thicknesses of partitions and voids in two Namapoikia samples.
3. A comparison of partition and void thicknesses for selected subvolumes of both reconstructions. 
4. Plots showing the change in median thickness with respect to stratigraphic up/growth direction. 

Here, we provide code to recreate Fig. 3 in its entirety. 

## Prerequisites

To run this code, you will need the thickness maps produced for Mehra et. al. 2020, which can be found at: (link here). 

## Code 

### Comparison plot (A)
1. Run the function `comparison_figure`:
    ```Matlab
    % comparison_figure() produces an .eps file. 
    % Complete is just a placeholder variable.
    complete = comparison_figure();
    ```
    Note that the output of `comparison_figure`, while accurate, is not graphically pleasing. 

### Histograms and box plots (B, C, D)
Note that the term "septa" was used in the place of "partitions" when first studying *Namapoikia*.
1. Load in `thickness_workspace`:
    ```Matlab
    load('thickness_workspace.mat');
    ```
2. Having loaded the workspace, run `full_volume_analysis`:
    ```Matlab
    % For full volumes
    all_processed_data = full_volume_analysis(thickness_maps, titles, data_dims,...
    min_distance, bin_spacing, remove_large_elements, large_threshold, output_location);
    ```
3. Now, run `subvolume_analysis`:
   ```Matlab
    % For subvolumes
    all_sub_processed_data = subvolume_analysis(subvolume_thickness_maps, ...
    subvolume_data_dims, subvolume_titles, output_location)
   ```

### Plot change in thickness (E)
1. Load in `change_workspace`:
   ```Matlab
   load('change_workspace.mat');
   ```
2. Run `process_thickness_change`:
   ```Matlab
    [A_thickness_collector, B_thickness_collector] = process_thickness_change(sample_A,...
    sample_A_dims, sample_A_step, sample_A_binary, sample_A_binary_dims, ...
    sample_B, sample_B_dims, sample_B_step)
   ```
   Note that this function may take a while to run. Additionally, note that the box plot outputs are rotated in the final Fig. 3E.