function data = load_raw_data(file_location, data_dims, specs)
    % Here, we load raw data output by Avizo.
    % data_dims refers to the size of the volume
    % specs refers to the type (i.e., float32, uint8, etc)
    f_id = fopen(file_location, 'r');
    data = fread(f_id, prod(data_dims), specs);
    fclose(f_id);
    data = reshape(data, data_dims);
end