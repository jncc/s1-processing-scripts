# s1-processing-scripts
The Sentinel-1 processing chain for processing raw scenes to ARD using the SNAP Toolbox.

## Prerequisites
- ESA SNAP + Sentinel 1 Toolbox installed
- A Digital Elevation Model (DEM), preferably WGS84
- Ideally 16 GB RAM 

## Configuration
You'll need to change the parameterised values in JNCC_S1_GRD_configfile to paths on your system.

## Run the scripts
Run from command line like so:

For the EO Alpha version
```
./JNCC_S1_GRD_MAIN_v2.1.1.sh 1 1 1 1 2 1 2 1 1 1
```

For the JASMIN version
```
./JNCC_S1_GRD_MAIN_v2.1.1.sh 1 1 1 1 1 1 2 1 3 1
```

You can find a description of all the parameters in the comments at the top of the JNCC_S1_GRD_MAIN file. It takes around 8 hours to process one scene using a cut DEM.

## Versions
The master branch is the version that was used in the EO Alpha and uses the OSGB DEM. jasmin/workflow_v3 is the newer version currently running on JASMIN which uses the WGS84 DEM.
