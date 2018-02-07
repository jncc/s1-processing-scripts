#!/bin/sh

##### Directories set up  
##### ==================
##### INPUT directories
export MAIN_DIR="/home/aminchella/JNCC/MAIN" ##== MAIN DIRECTORY with DEM, Input dataset and Outputs  
export BASKET_INDIR="${MAIN_DIR}/Basket" ##== directory containing  S1_GRDH.zip products to be processed
#####
export EXTDEMFILE="${MAIN_DIR}/EXT_DEM/APGB_Qgis.tif" ##== External APGB DEM
export EXTDEMNOVAL="-32768.0" ## External DEM No data value
##### OUTPUT directories
export MAIN_OUTDIR="${MAIN_DIR}/OUTPUT"  ##== MAIN OUTPUT DIRECTORY where products output folders will be created 
##### After Processing
export PROZIP_DIR="${MAIN_DIR}/ZIP_PROCESSED"  ##== directory where S1.zip data are moved after processing
##### SW and processing xml chains directories
export GRAPHSDIR="/home/aminchella/JNCC/script/xml" ##== DIRECTORY with snap xml graphs for the processing 
export SNAP_HOME="/opt/snap/bin" ##== SNAP (version 5) directory
export SCRIPT_DIR="/home/aminchella/JNCC/script"
#####============================================================
##### STATIC Variable for Log files   
#####============================================================
export logtime=$(date +"%F_%H%M%S")
export software="@Snap_version5"
#### LOG files
export MAINLOG=${MAIN_OUTDIR}/Mainlog_${logtime}_${software}.txt  ### Generation of logfile for the processing 
#####============================================================
##### Processing Parameters 
#####============================================================
##### UTM map projection parameters
export UTMPROJ="UTM Zone 31"   ### e.g. "UTM Zone 30" , "UTM Zone 22, South"
export centralmeridian="-3.0" ### e.g. "-3", "-51"
export false_northing="0.0"  ### e.g. "0.0"
