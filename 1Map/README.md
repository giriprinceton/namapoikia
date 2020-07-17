# Fig. 1

Fig. 1 contains: 
1. A national-scale map.
2. A locality-scale satellite image.
3. An interpolated map of *Namapoikia* occurrences, alpmg wotj three pie charts showing the relative amount of outcrop, microbial facies, and *Namapoikia* observed.
4. Two field photographs of in situ *Namapoikia*.

Here, we include the code and data required to build the interpolated map, plus the full-size field photographs. 

## Building an interpolated map of Driedoornvlakte Farm using survey data

### **Dependencies**

You will not be able to build the interpolated map seen in Fig. 1 without the following packages:

1. [mGstat](http://mgstat.sourceforge.net/) Download and unzip the latest stable version of mGstat into this directory. In Matlab, make sure that the mGstat directory is added to your path (in the file explorer, right-click on the mGstat folder and select "Add To Path -> Selected Folder and Subfolders). 
2. [fminsearchbnd](https://www.mathworks.com/matlabcentral/fileexchange/8277-fminsearchbnd-fminsearchcon) Like mGstat, download and unzip fminsearchbnd into this directory. Once again, add the directory to the path.
3. [variogramfit](https://www.mathworks.com/matlabcentral/fileexchange/25948-variogramfit) Download and place in the 1Map directory. 

### Running this code

If you want, you can play around with the empirical and modelled fits to the data by running/adjusting `fit_data`:
```Matlab
fit_data('arc_files', 'dried_survey_joined.shp');
```

To recreate Fig. 1C exactly, run `process_dried_data`:
```Matlab
process_dried_data('arc_files', 'dried_survey_joined.shp', 'dried_contours_5.shp', 'dried_trimble_mound_traces_polylines.shp', 'dried_reef_trace.shp');
```

## Field photographs

Photographs that were included in Mehra et. al. 2020:

Fig 2D:
![Field photograph of Namapoikia.](Fig2D.jpg)

Fig 2E:
![Field photograph of Namapoikia.](Fig2E.jpg)
