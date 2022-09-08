#!/bin/bash 

#### Version log
#### v2: - added terrain flatteing TC for UTM WGS84 map projection
####     - added the FTC generation only for APGB (38-45, 65-72, 90-97)
#### v2.1 - added conversion from linear to dB for UTM-WGS84 
#### ==================
#### Polarisation VV
#### ==================
#### Terrain Flattening only with External DEM in SAR geometry
if [ "${SELDEM}" = "APGB" ]; then 
    echo "Terrain Flattening of beta0"
    SNAP_TF_EXTDEM "${SLICE_VV_OUTDIR}" "${SLICE_VV_OUTDIR}" "${SLICE_ROOTNAME}" "VV" "CAL" "Beta0" "${SLICE_LOG}"
fi
#### Creation of folder GEO for storing geocoded outputs 
export SLICE_VV_OUTDIR_GEO="${SLICE_VV_OUTDIR}/GEO" ## variable for output dir $SLICE_OUTDIR/VV
echo "SLICE_VV_OUTDIR_GEO = ${SLICE_VV_OUTDIR}/GEO" >> ${SLICE_LOG}
mkdir $(echo "${SLICE_VV_OUTDIR}/GEO") ## generation of directory /GEO	
#### Geocoding according to CRS selection
if [ "${CRS}" = "OSGB1936" ]; then 
   	echo "CRS=OSGB1936"
	#### OSGB 1936
	####=================================####
	### Absolute Sigma0 and Gamma0 Multilooked (optional) and Terrain Corrected (output as Geotiff) 		
	SNAP_ML_TC_OSGB1936 "${SLICE_VV_OUTDIR}" "${SLICE_VV_OUTDIR_GEO}" "${SLICE_ROOTNAME}" "VV" "CAL" "Sigma0" "TC" "${SLICE_LOG}"    
	SNAP_ML_TC_OSGB1936 "${SLICE_VV_OUTDIR}" "${SLICE_VV_OUTDIR_GEO}" "${SLICE_ROOTNAME}" "VV" "CAL" "Gamma0" "TC" "${SLICE_LOG}"    
	###=================================####
	### Radiometrically Normalised (Kellndorfer) Sigma0 and Gamma0 Multilooked (optional) and Terrain Corrected (output as Geotiff)
	SNAP_ML_TC_RNKELL_OSGB1936 "${SLICE_VV_OUTDIR}" "${SLICE_VV_OUTDIR_GEO}" "${SLICE_ROOTNAME}" "VV" "CAL" "Sigma0" "${SLICE_LOG}"
	SNAP_ML_TC_RNKELL_OSGB1936 "${SLICE_VV_OUTDIR}" "${SLICE_VV_OUTDIR_GEO}" "${SLICE_ROOTNAME}" "VV" "CAL" "Gamma0" "${SLICE_LOG}"
	### Speckle filtering
	SNAP_SpeckleFiltering "${SLICE_VV_OUTDIR_GEO}" "${SLICE_VV_OUTDIR_GEO}" "${SLICE_ROOTNAME}" "VV" "Sigma0" "RTC" "${SLICE_LOG}" 
	SNAP_SpeckleFiltering "${SLICE_VV_OUTDIR_GEO}" "${SLICE_VV_OUTDIR_GEO}" "${SLICE_ROOTNAME}" "VV" "Gamma0" "RTC" "${SLICE_LOG}"
	### Coversion from linear to dB
	SNAP_ConvLinToDb "${SLICE_VV_OUTDIR_GEO}" "${SLICE_VV_OUTDIR_GEO}" "${SLICE_ROOTNAME}" "VV" "Sigma0" "RTC_${Spk}" "${SLICE_LOG}" 
	SNAP_ConvLinToDb "${SLICE_VV_OUTDIR_GEO}" "${SLICE_VV_OUTDIR_GEO}" "${SLICE_ROOTNAME}" "VV" "Gamma0" "RTC_${Spk}" "${SLICE_LOG}" 
	####=================================####
elif [ "${CRS}" = "EPSG29902" ]; then 
    echo "CRS=EPSG29902"
	#### EPSG29902
	####=================================####
	#### Absolute Sigma0 and Gamma0 Multilooked (optional) and Terrain Corrected (output as Geotiff) 		
	SNAP_ML_TC_EPSG29902 "${SLICE_VV_OUTDIR}" "${SLICE_VV_OUTDIR_GEO}" "${SLICE_ROOTNAME}" "VV" "CAL" "Sigma0" "TC" "${SLICE_LOG}"    
	SNAP_ML_TC_EPSG29902 "${SLICE_VV_OUTDIR}" "${SLICE_VV_OUTDIR_GEO}" "${SLICE_ROOTNAME}" "VV" "CAL" "Gamma0" "TC" "${SLICE_LOG}"    
	###=================================####
	### Radiometrically Normalised (Kellndorfer) Sigma0 and Gamma0 Multilooked (optional) and Terrain Corrected (output as Geotiff)
	SNAP_ML_TC_RNKELL_EPSG29902 "${SLICE_VV_OUTDIR}" "${SLICE_VV_OUTDIR_GEO}" "${SLICE_ROOTNAME}" "VV" "CAL" "Sigma0" "${SLICE_LOG}"
	SNAP_ML_TC_RNKELL_EPSG29902 "${SLICE_VV_OUTDIR}" "${SLICE_VV_OUTDIR_GEO}" "${SLICE_ROOTNAME}" "VV" "CAL" "Gamma0" "${SLICE_LOG}"
	### Speckle filtering
	SNAP_SpeckleFiltering "${SLICE_VV_OUTDIR_GEO}" "${SLICE_VV_OUTDIR_GEO}" "${SLICE_ROOTNAME}" "VV" "Sigma0" "RTC" "${SLICE_LOG}" 
	SNAP_SpeckleFiltering "${SLICE_VV_OUTDIR_GEO}" "${SLICE_VV_OUTDIR_GEO}" "${SLICE_ROOTNAME}" "VV" "Gamma0" "RTC" "${SLICE_LOG}"
	### Coversion from linear to dB
	SNAP_ConvLinToDb "${SLICE_VV_OUTDIR_GEO}" "${SLICE_VV_OUTDIR_GEO}" "${SLICE_ROOTNAME}" "VV" "Sigma0" "RTC_${Spk}" "${SLICE_LOG}" 
	SNAP_ConvLinToDb "${SLICE_VV_OUTDIR_GEO}" "${SLICE_VV_OUTDIR_GEO}" "${SLICE_ROOTNAME}" "VV" "Gamma0" "RTC_${Spk}" "${SLICE_LOG}" 
	###=================================####
elif [ "${CRS}" = "UTMWGS84" ]; then 
    echo "UTM WGS84"
	####=================================####
	#### Absolute Sigma0 and Gamma0 Multilooked (optional) and Terrain Corrected (output as Geotiff) 	
	SNAP_ML_TC_UTMWGS84 "${SLICE_VV_OUTDIR}" "${SLICE_VV_OUTDIR_GEO}" "${SLICE_ROOTNAME}" "VV" "CAL" "Sigma0" "TC" "${SLICE_LOG}"  
	SNAP_ML_TC_UTMWGS84 "${SLICE_VV_OUTDIR}" "${SLICE_VV_OUTDIR_GEO}" "${SLICE_ROOTNAME}" "VV" "CAL" "Gamma0" "TC" "${SLICE_LOG}"
	####=================================####
	#### Radiometrically Normalised (Kellndorfer) Sigma0 and Gamma0 Multilooked (optional) and Terrain Corrected (output as Geotiff)
	SNAP_ML_TC_RNKELL_UTMWGS84 "${SLICE_VV_OUTDIR}" "${SLICE_VV_OUTDIR_GEO}" "${SLICE_ROOTNAME}" "VV" "CAL" "Sigma0" "${SLICE_LOG}"
	SNAP_ML_TC_RNKELL_UTMWGS84 "${SLICE_VV_OUTDIR}" "${SLICE_VV_OUTDIR_GEO}" "${SLICE_ROOTNAME}" "VV" "CAL" "Gamma0" "${SLICE_LOG}"
	#### Speckle filtering
	SNAP_SpeckleFiltering "${SLICE_VV_OUTDIR_GEO}" "${SLICE_VV_OUTDIR_GEO}" "${SLICE_ROOTNAME}" "VV" "Sigma0" "RTC" "${SLICE_LOG}" 
	SNAP_SpeckleFiltering "${SLICE_VV_OUTDIR_GEO}" "${SLICE_VV_OUTDIR_GEO}" "${SLICE_ROOTNAME}" "VV" "Gamma0" "RTC" "${SLICE_LOG}"
	### Coversion from linear to dB
	SNAP_ConvLinToDb "${SLICE_VV_OUTDIR_GEO}" "${SLICE_VV_OUTDIR_GEO}" "${SLICE_ROOTNAME}" "VV" "Sigma0" "RTC_${Spk}" "${SLICE_LOG}" 
	SNAP_ConvLinToDb "${SLICE_VV_OUTDIR_GEO}" "${SLICE_VV_OUTDIR_GEO}" "${SLICE_ROOTNAME}" "VV" "Gamma0" "RTC_${Spk}" "${SLICE_LOG}" 
	####=================================####
else 
    echo "Other CRS"
fi