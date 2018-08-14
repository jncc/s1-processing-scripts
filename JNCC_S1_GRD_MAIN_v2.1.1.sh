### Script name: JNCC_S1_GRD_MAIN
### Project: "JNCC Sentinel-1 Backscatter data provision service" 
### Reference Document: -
### Author: Andrea Minchella 	
### Copyright © 2017 Airbus 
### All rights reserved.
### ========================================================
### LOG history version
### 9-11-2017: version 1.0
### 29-11-2017: version 2.0   - modified /Processing_Polarisation_VV_v1.sh with /Processing_Polarisation_VV_v2.sh 
###                           - modified /Processing_Polarisation_VH_v1.sh with /Processing_Polarisation_VH_v2.sh
### 08-12-2017: version 2.1	  - modified /Processing_Polarisation_VV_v2.sh with /Processing_Polarisation_VV_v2.1.sh 
###                           - modified /Processing_Polarisation_VH_v2.sh with /Processing_Polarisation_VH_v2.1.sh
### 01-03-2018: version 2.1.1 - added SNAP_OPTS to configfile and SNAP functions
### ========================================================
## Generated OUTPUTS: 
## 1) Geocoded Absolute Gamma0 and Sigma0 VV and VH
## 2) Geocoded Radiometric Normalised Gamma0 VV and VH 
## Features: 
## - read directely the Sentinel-1 (A/B) GRD data in ZIP
## - use of precise orbit RESORB
## 
##	Aux Data: DEM=STRM 3 sec; Precise Orbit = RESORB
## Output CRS: UTM WGS84 
## Output format: geotiff format
## Toolbox: ESA Sentinel Application Platform (SNAP) version 5
##  
## ACRONYMS
## ========
## CRS = Coordinate Reference System
## T0 = Acquisition Time 0 (master)
## TN = Acquisition Time N
## =========================================================
 
###===============================================================
### HOW TO LAUNCH THE SCRIPT: name_script.sh $1 $2 $3 $4 $5 $6
### e.g.: JNCC_S1_GRD_MAIN_v2.1.1 1 1 1 1 1 1 2 1 1 
### This script uses POSITIONAL parameters value offering different processing combination 
### 
### 1st parameter ($1) determines the type of product to be processed: 1 (=GRD); 2 (=SLC); N.B.: a value must chosen
### 2nd parameter ($2) determines the number of slices for processing up to three: =1 (one slice); =2 (two slices); =3 (three slices)
### 3rd parameter ($3) determines the polarisations to be processed: 1 (=VV+VH); 2 (=VV); 3(=VH)
### 4th parameter ($4) determines which DEM is used: 1 (=APGB); 2 (=SRTM 3sec) 
### 5th parameter ($5) determines the used precise orbits: 1 (=RESORB); 2 (=POEORB) 
### 6th parameter ($6) determines the Multilooking factor to be used: 1 (Az=1 Rg=1) 2 (Az=2 Rg=2) and so forth
### 7th parameter ($7) determines the Image Interpolation during TC: 1 (=Nearest Neighboor); 2 (=Bilinear); 3 (=bisinc_21_point-inter)
### 8th parameter ($8) determines the DEM Interpolation during TC: 1 (=Bilinear); 2 (=Bicubic INTERPOLATION)
### 9th parameter ($9) determines the CRS for Terrain Corrected outputs; =1 (OSGB 1936 - EPSG:27700); =2 (TM 65-EPSG:29902); =3 (UTM WGS 84)
### 10th parameter ($10) determines the type of applied speckle filter: 1 (=Refined Lee); 2 (=GammaMap) 
##############################################################

#!/bin/bash 
### Configuration file and libraries
. ./JNCC_S1_GRD_configfile_v.1.1.sh  ### configuration file with directories and procssing paramenters 
. ./JNCC_S1_VARS_OUTPRDIR_v1.0.lib ### Library to generate variables from name of the S1.zip 
. ./JNCC_SNAP_functions_v1.1.lib ### Library containing processing modules with SNAP

##############################################################
#### Processing start 
echo "Processing starts at $(date +"%F_%H%M%S")" >> ${MAINLOG}
echo "=========================================" >> ${MAINLOG}

### POSITIONAL PARAMETERS DEFINITION
### ================================
echo "========================================="
echo "PROCESSING PARAMETERS"
### 1st POSITIONAL parameter input ($1) determines the type of product to be processed: 1 (=GRD); 2 (=SLC); N.B.: a value must chosen
if [ -z "$1" ] 
 then
 echo "ERROR: 1 POSITIONAL PARAMETER MISSING. Provide one of the following values for product to be processed: 1 (GRD); 2 (SLC)"
 exit 
elif [ $1 -eq 1 ]
 then
 echo "Product Type processed: GRD" >> ${MAINLOG}
elif [ $1 -eq 2 ]
 then
 echo "Product Type: SLC" 
 echo "SLC processing not supported" >> ${MAINLOG}
 exit 
else
 echo "ERROR: 1 POSITIONAL PARAMETER OUT OF RANGE. Provide one of the following values for product type to be processed: 1 (GRD); 2 (SLC)"
 exit 
fi
######################################
### 2nd POSITIONAL parameter input ($2) determines the number of slices : =1 (one slice); =2 (two slices); =3 (three slices)
if [ -z "$2" ] 
  then
  echo "ERROR: 2 POSITIONAL PARAMETER MISSING"
  echo "Please provide the number of slices for processing (up to three): =1 (one slice); =2 (two slices); =3 (three slices)" 
  exit 
elif [ $2 -eq 1 ]
  then
  echo "Single slice processed" >> ${MAINLOG}
elif [ $2 -eq 2 ]
  then
  echo "Two slices are assembled (concatenated) and processed" >> ${MAINLOG}
elif [ $2 -eq 3 ]
  then
  echo "Three slices are assembled (concatenated) and processed" >> ${MAINLOG}
else
  echo "ERROR: 2nd POSITIONAL PARAMETER OUT OF RANGE"
  echo "Please provide one of the following value for number of slices for processing (up to three): =1 (one slice); =2 (two slices); =3 (three slices)"
  exit  
fi
######################################
### 3rd POSITIONAL parameter input ($3) determines the polarisation(s) to be processed: 0 (=VV+VH); 1 (=VV); 2(=VH)
if [ -z "$3" ] 
  then
  echo "ERROR: 3rd POSITIONAL PARAMETER MISSING. Please provide one of the following value for the polarisations to process: 1 (=VV+VH); 2 (=VV); 3 (=VH)"
  exit 
  elif [ $3 -eq 1 ]
  then
  echo "Both VV and VH polarisations are processed" >> ${MAINLOG}
  elif [ $3 -eq 2 ]
  then
  echo "Only VV polarisation is processed" >> ${MAINLOG}
  elif [ $3 -eq 3 ]
  then
  echo "Only VH polarisation is processed" >> ${MAINLOG}
else
  echo "ERROR: 3 POSITIONAL PARAMETER OUT OF RANGE" 
  echo "Please provide one of the following value for the polarisations to process: 1 (=VV+VH); 2 (=VV); 3 (=VH)"
  exit  
fi
######################################
### 4th POSITIONAL parameter input ($4) determines which DEM is used: 1 (=APGB); 2 (=SRTM 3sec) 
if [ -z "$4" ] 
 then
 echo "ERROR: 4th POSITIONAL PARAMETER MISSING"
 echo "Provide one of the following values for DEM: 1 (=APGB); 2 (=SRTM 3sec)" 
 exit 
elif [ $4 -eq 1 ]
 then
 echo "Employed DEM: APGB" >> ${MAINLOG}
 export SELDEM="APGB"
elif [ $4 -eq 2 ]
 then
 echo "Employed DEM: SRTM90" >> ${MAINLOG}
 export SELDEM="SRTM90" 
else
 echo "ERROR: 4th POSITIONAL PARAMETER OUT OF RANGE"
 echo "Provide one of the following values values for DEM: 1 (=APGB); 2 (=SRTM 3sec)"
 exit 
fi
######################################
### 5th POSITIONAL parameter input ($5) determines the used orbits: 1 (=RESORB); 2 (=POEORB) 
if [ -z "$5" ] 
 then
 echo "ERROR: 5th POSITIONAL PARAMETER MISSING"
 echo "Provide one of the following values for precise orbit: 1 (=RESORB); 2 (=POEORB)" 
 exit 
elif [ $5 -eq 1 ]
 then
 echo "Employed Orbit: RESORB"
 export ORBIT_TYPE="Sentinel Restituted (Auto Download)" >> ${MAINLOG}
elif [ $5 -eq 2 ]
 then
 echo "Employed Orbit: POEORB" 
 export ORBIT_TYPE="Sentinel Precise (Auto Download)" >> ${MAINLOG}
else
 echo "ERROR: 5th POSITIONAL PARAMETER OUT OF RANGE"
 echo "Provide one of the following values for precise orbit: 1 (=RESORB); 2 (=POEORB)"
 exit 
fi
######################################
### 6th POSITIONAL parameter input ($6) determines the Multilooking factor to be used: 1 (Az=1 Rg=1) 2 (Az=2 Rg=2) and so forth
if [ -z "$6" ] 
then
  echo "ERROR: 5th POSITIONAL PARAMETER MISSING"
  echo "Insert the Multilooking factor: 1 (Az=1 Rg=1) 2 (Az=2 Rg=2) and so forth"
  exit 
else
  export AZIMUTH_LOOK="$6"
  export RANGE_LOOK=$(echo "${AZIMUTH_LOOK}" | bc -l) ## Azimuth looks = Range looks
  echo "Azimuth Looks = ${AZIMUTH_LOOK}" >> ${MAINLOG}
  echo "Range Looks = ${RANGE_LOOK}" >> ${MAINLOG}
  #### DEFINITION OF PIXEL SPACING 
  pixelSpacingInMeter=$(echo 10*${AZIMUTH_LOOK} | bc -l)   ### 10m = (Az=1 Rg=1)
  export pixelSpacingInMeter
  echo "pixelSpacingInMeter = $pixelSpacingInMeter" >> ${MAINLOG}
  pixelSpacingInDegree=$(echo 0.00013474729261792824*${AZIMUTH_LOOK} | bc -l)
  export pixelSpacingInDegree
  echo "pixelSpacingInDegree = $pixelSpacingInDegree" >> ${MAINLOG}
fi
#####################################
### 7th POSITIONAL parameter input ($7) determines the used Image interpolator for TC: 1 (=Nearest Neighboor); 2 (=Bilinear); 3 (=bisinc_21_point-inter) 
if [ -z "$7" ] 
 then
 echo "ERROR: 7th POSITIONAL PARAMETER MISSING"
 echo "Provide one of the following values for Image interpolator for TC: 1 (=Nearest Neighboor); 2 (=Bilinear); 3 (=bisinc_21_point-inter)" 
 exit 
elif [ $7 -eq 1 ]
 then
 echo "Image interpolator for TC: NEAREST NEIGHBOUR" >> ${MAINLOG}
 export imgResamplingMethod="NEAREST_NEIGHBOUR" 
elif [ $7 -eq 2 ]
 then
 echo "Image interpolator for TC: BILINEAR INTERPOLATION" >> ${MAINLOG}
 export imgResamplingMethod="BILINEAR_INTERPOLATION"
elif [ $7 -eq 3 ]
 then
 echo "Image interpolator for TC: BISINC 21 POINT INTERPOLATION" >> ${MAINLOG}
 export imgResamplingMethod="BISINC_21_POINT_INTERPOLATION"  
else
 echo "ERROR: 7th POSITIONAL PARAMETER OUT OF RANGE"
 echo "Provide one of the following values for precise orbit: 1 (=Nearest Neighboor); 2 (=Bilinear); 3 (=BISINC 21 POINT INTERPOLATION)" 
 exit 
fi
#####################################
### 8th POSITIONAL parameter input ($8) determines the used DEM interpolator for TC: 1 (=Bilinear); 2 (=Bicubic INTERPOLATION) 
if [ -z "$8" ] 
 then
 echo "ERROR: 8th POSITIONAL PARAMETER MISSING"
 echo "Provide one of the following values for DEM interpolator for TC: 1 (=Bilinear); 2 (=Bicubic INTERPOLATION)" 
 exit 
elif [ $8 -eq 1 ]
 then
 echo "DEM interpolator for TC: BILINEAR_INTERPOLATION" >> ${MAINLOG}
 export demResamplingMethod="BILINEAR_INTERPOLATION" 
elif [ $8 -eq 2 ]
 then
 echo "DEM interpolator for TC: Bicubic INTERPOLATION" >> ${MAINLOG} 
 export demResamplingMethod="BICUBIC_INTERPOLATION" 
else
 echo "ERROR: 8th POSITIONAL PARAMETER OUT OF RANGE"
 echo "Provide one of the following values for DEM interpolator for TC: 1 (=Bilinear); 2 (=Bicubic INTERPOLATION)"  
 exit 
fi
#####################################
### 9th POSITIONAL parameter input ($9) determines the CRS for TC output: 1 (=OSGB 1936 - EPSG: 27700); 2 (TM65 - EPSG:29902); 3 (=UTM WGS84) 
if [ -z "$9" ] 
 then
 echo "ERROR: 9th POSITIONAL PARAMETER MISSING"
 echo "Provide one of the following values for the CRS of TC output: 1 (=OSGB 1936 - EPSG: 27700); 2 (TM65 - EPSG:29902); 3 (=UTM WGS84)" 
 exit 
elif [ $9 -eq 1 ]
 then
 echo "CRS for TC output: OSGB 1936 - EPSG: 27700" >> ${MAINLOG}
 export CRS="OSGB1936" ## FOR UK
elif [ $9 -eq 2 ]
 then
 echo "CRS for TC output: TM65 - EPSG: 29902" >> ${MAINLOG}
 export CRS="EPSG29902" ## FOR Irland
elif [ $9 -eq 3 ]
 then
 echo "CRS for TC output: UTM WGS84" >> ${MAINLOG}
 export CRS="UTMWGS84" 
else
 echo "ERROR: 9th POSITIONAL PARAMETER OUT OF RANGE"
 echo "Provide one of the following values for the CRS of TC output: 1 (=OSGB 1936 - EPSG: 27700); 2 (TM65 - EPSG:29902); 3 (=UTM WGS84)" 
 exit 
fi
#####################################
### 10th POSITIONAL parameter input ($10) determines the type of speckle filter used: 1 (=Refined Lee); 2 (=GammaMap) 
if [ -z "${10}" ] 
 then
 echo "ERROR: 10th POSITIONAL PARAMETER MISSING"
 echo "Provide one of the following values for Speckle filter: 1 (=Refined Lee); 2 (=GammaMap)" 
 exit 
elif [ "${10}" -eq "1" ]
 then
 echo "Speckle filter: Refined Lee" >> ${MAINLOG}
 export Specklefilter="Refined Lee" ## N.B.: SNAP does not allow the selection of any parameters
 export Spk="SpkRL"
elif [ "${10}" -eq "2" ]
 then
 echo "Speckle filter: Gamma Map" >> ${MAINLOG} 
 export Specklefilter="Gamma Map" ## N.B.: Dimension of the filter size hardlocked in S1_Speckle_Filtering.xml
 export Spk="SpkGM"
else
 echo "ERROR: 10th POSITIONAL PARAMETER OUT OF RANGE"
 echo "Provide one of the following values for Speckle filter: 1 (=Refined Lee); 2 (=GammaMap)"  
 exit 
fi
###END POSITIONAL PARAMETERS
echo "========================================="

## START OF PROCESSING
## ============================ 
cd ${BASKET_INDIR} 
### 
ls | sort -k1.18
if [ "$(ls -A ${BASKET_INDIR})" ]; then
  ls | sort -k1.18 > "${MAIN_OUTDIR}/input.txt" ## 1 =key column and 18 is the substring position
  ls | sort -k1.18 | 
  while read p ## e.g.: S1A.zip
  do { 
    #################################################
    ### Processing one slice per time (NO Slices assembly)
    #################################################
    if [ "$2" = "1" ]; then
      echo "Single slice processed" 
      echo "Single slice processed" >> ${MAINLOG}
      SLICE_1_ZIP=$(sed -n 1,1p "${MAIN_OUTDIR}/input.txt") 
      export SLICE_1_ZIP
      echo ${SLICE_1_ZIP} >> ${MAINLOG}
   	  #### Generation of variables and a logfile ${SLICE_1_LOG} 
	    S1PROD_VARS "SLICE_1" "${SLICE_1_ZIP}" "${MAIN_OUTDIR}"
	    echo "Single slice processed" >> ${SLICE_1_LOG}
	    #### Generation of the PRODUCT OUTPUT folder
      export SLICE_ROOTNAME="${SLICE_1_ROOTNAME}"
      echo ${SLICE_ROOTNAME}
	    export SLICE_OUTDIR="${OUTPRDIR}/${SLICE_1_ROOTNAME}"
      mkdir ${SLICE_OUTDIR}
      #### Creation logfile image within the PRODUCT OUTPUT folder
      SLICE_LOG="${SLICE_OUTDIR}/log_${SLICE_ROOTNAME}_PROCESSING_$(date +"%F_%H%M%S").txt"
      export SLICE_LOG
      echo "logfile = ${SLICE_LOG}"
      #### ==================
      #### Polarisation VV
      #### ==================
      if [ "$3" = "1" -o "$3" = "2" ]; then
        echo "Polarisation VV processed" >> ${SLICE_1_LOG}
        export SLICE_VV_OUTDIR="${SLICE_OUTDIR}/VV" ## variable for output dir $SLICE_OUTDIR/VV 
        echo "SLICE_VV_OUTDIR = ${SLICE_OUTDIR}/VV" >> ${SLICE_LOG}
		    #### Remove Border Noise (RBN), Select polarisation, absolute calibration, apply precise orbit
	  	  SNAP_S1GRD_RBN_POLS_CAL_PO "${BASKET_INDIR}" "${SLICE_1_ZIP}" "${SLICE_ROOTNAME}" "${SLICE_VV_OUTDIR}" "VV" "${SLICE_LOG}"
	  	  #### Radiometric normalisation and terrain correction
        . ${SCRIPT_DIR}/Processing_Polarisation_VV_v2.1.sh
      fi
      #### ==================
      #### Polarisation VH
      #### ==================
      if [ "$3" = "1" -o "$3" = "3" ]; then
        echo "Polarisation VH processed" >> ${SLICE_1_LOG}
        export SLICE_VH_OUTDIR="${SLICE_OUTDIR}/VH" ## variable for output dir $SLICE_OUTDIR/VV 
        echo "SLICE_VH_OUTDIR = ${SLICE_OUTDIR}/VH" >> ${SLICE_LOG}
        #### Remove Border Noise (RBN), Select polarisation, absolute calibration, apply precise orbit
        SNAP_S1GRD_RBN_POLS_CAL_PO "${BASKET_INDIR}" "${SLICE_1_ZIP}" "${SLICE_ROOTNAME}" "${SLICE_VH_OUTDIR}" "VH" "${SLICE_LOG}"
        #### Radiometric normalisation and terrain correction
        . ${SCRIPT_DIR}/Processing_Polarisation_VH_v2.1.sh
      fi
      ### Moving S1.zip to $PROZIP_DIR
      mv -u "${BASKET_INDIR}/${SLICE_1_ZIP}" "${PROZIP_DIR}" 
      echo "${SLICE_1_ZIP} MOVED to ${PROZIP_DIR}" >> ${MAINLOG}
      $(ls ${BASKET_INDIR} | sort -k1.18 > ${MAIN_OUTDIR}/input.txt)
      if [ -s ${MAIN_OUTDIR}/input.txt ];
      then 
      echo "${MAIN_OUTDIR}/input.txt has data" >> ${MAINLOG}
      else 
      echo "Processing is completed at $(date +"%F_%H%M%S")" >> ${MAINLOG}
      exit
      fi
    fi
    #################################################
    ### Processing 2 slice per time (Slice assembly)
    #################################################
    if [ "$2" = "2" ]; then
      echo "Two slices assembled per time and processed" 
      echo "Two slices assembled per time and processed" >> ${MAINLOG}
      SLICE_1_ZIP=$(sed -n 1,1p "${MAIN_OUTDIR}/input.txt")
      SLICE_2_ZIP=$(sed -n 2,2p "${MAIN_OUTDIR}/input.txt")
      echo ${SLICE_1_ZIP} >> ${MAINLOG}
      echo ${SLICE_2_ZIP} >> ${MAINLOG}
      #### Generation of variables and logfiles for single frame
      S1PROD_VARS "SLICE_1" "${SLICE_1_ZIP}" "${MAIN_OUTDIR}"
      S1PROD_VARS "SLICE_2" "${SLICE_2_ZIP}" "${MAIN_OUTDIR}"
      #### Generation of the ROOT PRODUCT OUTPUT name after concatenation of the times
      export SLICE_ROOTNAME="${SLICE_1_MISSION}_${SLICE_1_DMY}_${SLICE_1_START_HHMMSS}_${SLICE_2_END_HHMMSS}"
      echo "Output product = ${SLICE_ROOTNAME}" >> ${MAINLOG}
      #### Generation of the PRODUCT OUTPUT folder
      export SLICE_OUTDIR="${OUTPRDIR}/${SLICE_ROOTNAME}"
      mkdir ${SLICE_OUTDIR}
      #### Creation logfile image within the PRODUCT OUTPUT folder
      SLICE_LOG="${SLICE_OUTDIR}/log_${SLICE_ROOTNAME}_PROCESSING_$(date +"%F_%H%M%S").txt"
      export SLICE_LOG
      echo "logfile = ${SLICE_LOG}"
      #### ==================
      #### Polarisation VV
      #### ==================
      if [ "$3" = "1" -o "$3" = "2" ]; then
        echo "Polarisation VV processed" >> ${SLICE_LOG}
        export SLICE_VV_OUTDIR="${SLICE_OUTDIR}/VV" ## variable for output dir $SLICE_OUTDIR/VV 
        echo "SLICE_VV_OUTDIR = ${SLICE_OUTDIR}/VV" >> ${SLICE_LOG}
        #### Slice Assembly 
        SNAP_S1GRD_SLICEASSEMBLY "${BASKET_INDIR}" "2" "${SLICE_VV_OUTDIR}" "${SLICE_ROOTNAME}" "VV" "${SLICE_LOG}"
        #### Remove Border Noise (RBN), Select polarisation, absolute calibration, apply precise orbit
        SNAP_S1GRD_RBN_POLS_CAL_PO "${SLICE_VV_OUTDIR}" "${SLICE_ROOTNAME}_VV.dim" "${SLICE_ROOTNAME}" "${SLICE_VV_OUTDIR}" "VV" "${SLICE_LOG}"
        #### Radiometric normalisation and terrain correction
        . ${SCRIPT_DIR}/Processing_Polarisation_VV_v2.1.sh
      fi
      #### ==================
      #### Polarisation VH
      #### ==================
      if [ "$3" = "1" -o "$3" = "3" ]; then
        echo "Polarisation VH processed" >> ${SLICE_LOG}
        export SLICE_VH_OUTDIR="${SLICE_OUTDIR}/VH" ## variable for output dir $SLICE_OUTDIR/VV 
        echo "SLICE_VH_OUTDIR = ${SLICE_OUTDIR}/VH" >> ${SLICE_LOG}
        #### Slice Assembly
        SNAP_S1GRD_SLICEASSEMBLY "${BASKET_INDIR}" "2" "${SLICE_VH_OUTDIR}" "${SLICE_ROOTNAME}" "VH" "${SLICE_LOG}"
        #### Remove Border Noise (RBN), Select polarisation, absolute calibration, apply precise orbit
        SNAP_S1GRD_RBN_POLS_CAL_PO "${SLICE_VH_OUTDIR}" "${SLICE_ROOTNAME}_VH.dim" "${SLICE_ROOTNAME}" "${SLICE_VH_OUTDIR}" "VH" "${SLICE_LOG}"
        #### Radiometric normalisation and terrain correction
        . ${SCRIPT_DIR}/Processing_Polarisation_VH_v2.1.sh
      fi
      #### Moving S1.zip to $PROZIP_DIR
      mv -u "${BASKET_INDIR}/${SLICE_1_ZIP}" "${PROZIP_DIR}" 
      echo "${SLICE_1_ZIP} MOVED to ${PROZIP_DIR}" >> ${MAINLOG}
      mv -u "${BASKET_INDIR}/${SLICE_2_ZIP}" "${PROZIP_DIR}"
      echo "${SLICE_2_ZIP} MOVED to ${PROZIP_DIR}" >> ${MAINLOG}
      $(ls ${BASKET_INDIR} | sort -k1.18 > ${MAIN_OUTDIR}/input.txt)
      if [ -s ${MAIN_OUTDIR}/input.txt ]; then 
        echo "$INDIR/input.txt has data" >> ${MAINLOG}
      else 
		    echo "Processing is completed at $(date +"%F_%H%M%S")" >> ${MAINLOG}
        exit
      fi
    fi
    #################################################
    ### Processing 3 slices per time (Slice assembly)
    #################################################
    if [ "$2" = "3" ]; then
      echo "Three slices assembled per time and processed" 
      echo "Three slices assembled per time and processed" >> ${MAINLOG} 
      SLICE_1_ZIP=$(sed -n 1,1p "${MAIN_OUTDIR}/input.txt")
      SLICE_2_ZIP=$(sed -n 2,2p "${MAIN_OUTDIR}/input.txt")
      SLICE_3_ZIP=$(sed -n 3,3p "${MAIN_OUTDIR}/input.txt")
      echo ${SLICE_1_ZIP} >> ${MAINLOG}
      echo ${SLICE_2_ZIP} >> ${MAINLOG}
      echo ${SLICE_3_ZIP} >> ${MAINLOG}
      #### Generation of variables and logfiles for single frame
      S1PROD_VARS "SLICE_1" "${SLICE_1_ZIP}" "${MAIN_OUTDIR}"
      S1PROD_VARS "SLICE_2" "${SLICE_2_ZIP}" "${MAIN_OUTDIR}"
      S1PROD_VARS "SLICE_3" "${SLICE_3_ZIP}" "${MAIN_OUTDIR}"
      #### Generation of the ROOT PRODUCT OUTPUT name after concatenation of the times
      export SLICE_ROOTNAME="${SLICE_1_MISSION}_${SLICE_1_DMY}_${SLICE_1_START_HHMMSS}_${SLICE_3_END_HHMMSS}"
      echo "Output product = ${SLICE_ROOTNAME}" >> ${MAINLOG}
      #### Generation of the PRODUCT OUTPUT folder
      export SLICE_OUTDIR="${OUTPRDIR}/${SLICE_ROOTNAME}"
      mkdir ${SLICE_OUTDIR}
      #### Creation logfile image within the PRODUCT OUTPUT folder
      SLICE_LOG="${SLICE_OUTDIR}/log_${SLICE_ROOTNAME}_PROCESSING_$(date +"%F_%H%M%S").txt"
      export SLICE_LOG
      echo "logfile = ${SLICE_LOG}" >> ${MAINLOG}
      #### ==================
      #### Polarisation VV
      #### ==================
      if [ "$3" = "1" -o "$3" = "2" ]; then
        echo "Polarisation VV processed" >> ${SLICE_LOG}
        export SLICE_VV_OUTDIR="${SLICE_OUTDIR}/VV" ## variable for output dir $SLICE_OUTDIR/VV 
        echo "SLICE_VV_OUTDIR = ${SLICE_OUTDIR}/VV" >> ${SLICE_LOG}
        #### Slice Assembly 
        SNAP_S1GRD_SLICEASSEMBLY "${BASKET_INDIR}" "3" "${SLICE_VV_OUTDIR}" "${SLICE_ROOTNAME}" "VV" "${SLICE_LOG}"
        #### Remove Border Noise (RBN), Select polarisation, absolute calibration, apply precise orbit
        SNAP_S1GRD_RBN_POLS_CAL_PO "${SLICE_VV_OUTDIR}" "${SLICE_ROOTNAME}_VV.dim" "${SLICE_ROOTNAME}" "${SLICE_VV_OUTDIR}" "VV" "${SLICE_LOG}"
        #### Radiometric normalisation and terrain correction
        . ${SCRIPT_DIR}/Processing_Polarisation_VV_v2.1.sh
      fi
      #### ==================
      #### Polarisation VH
      #### ==================
      if [ "$3" = "1" -o "$3" = "3" ]; then
        echo "Polarisation VH processed" >> ${SLICE_LOG}
        export SLICE_VH_OUTDIR="${SLICE_OUTDIR}/VH" ## variable for output dir $SLICE_OUTDIR/VV 
        echo "SLICE_VH_OUTDIR = ${SLICE_OUTDIR}/VH" >> ${SLICE_LOG}
        #### Slice Assembly
        SNAP_S1GRD_SLICEASSEMBLY "${BASKET_INDIR}" "3" "${SLICE_VH_OUTDIR}" "${SLICE_ROOTNAME}" "VH" "${SLICE_LOG}"
        #### Remove Border Noise (RBN), Select polarisation, absolute calibration, apply precise orbit
        SNAP_S1GRD_RBN_POLS_CAL_PO "${SLICE_VH_OUTDIR}" "${SLICE_ROOTNAME}_VH.dim" "${SLICE_ROOTNAME}" "${SLICE_VH_OUTDIR}" "VH" "${SLICE_LOG}"
        #### Radiometric normalisation and terrain correction
        . ${SCRIPT_DIR}/Processing_Polarisation_VH_v2.1.sh
      fi
      #### Moving S1.zip to $PROZIP_DIR
      mv -u "${BASKET_INDIR}/${SLICE_1_ZIP}" "${PROZIP_DIR}" 
      echo "${SLICE_ZIP_1} MOVED to ${PROZIP_DIR}" >> ${MAINLOG}
      mv -u "${BASKET_INDIR}/${SLICE_2_ZIP}" "${PROZIP_DIR}"
      echo "${SLICE_2_ZIP} MOVED to ${PROZIP_DIR}" >> ${MAINLOG}
      mv -u "${BASKET_INDIR}/${SLICE_3_ZIP}" "${PROZIP_DIR}"
      echo "${SLICE_3_ZIP} MOVED to ${PROZIP_DIR}" >> ${MAINLOG}
      $(ls ${BASKET_INDIR} | sort -k1.18 > ${MAIN_OUTDIR}/input.txt)
      if [ -s ${MAIN_OUTDIR}/input.txt ]; then 
        echo "${MAIN_OUTDIR}/input.txt has data" >> ${MAINLOG}
		    echo "========================================="
      else 
		    echo "Processing is completed at $(date +"%F_%H%M%S")" >> ${MAINLOG}
		    echo "=========================================" >> ${MAINLOG}
        exit
      fi
    fi  
  } done
else 
	echo "NO processing done: The basket folder is empty"
fi




