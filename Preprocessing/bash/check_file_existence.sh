for subj in ADI002 ADI003 ADI004 ADI005 ADI006 ADI007 ADI008 ADI009 ADI010 ADI011 ADI012 ADI013 ADI014 ADI015 ADI016 ADI017 ADI018 ADI019 ADI020 ADI021 ADI022 ADI023 ADI024 ADI025 ADI026 ADI027 ADI028 ADI029 ADI030 ADI031 ADI032 ADI033 ADI034 ADI035 ADI036 ADI037 ADI038 ADI039 ADI040 ADI041 ADI042 ADI043 ADI044 ADI045 ADI046 ADI047 ADI048 ADI049 ADI050 ADI051 ADI052 ADI053 ADI054 ADI055 ADI056 ADI057 ADI058 ADI059 ADI060 ADI061 ADI062 ADI063 ADI064 ADI065 ADI066 ADI067 ADI068 ADI069 ADI070 ADI071 ADI072 ADI073 ADI074 ADI075 ADI076 ADI077 ADI078 ADI079 ADI080 ADI081 ADI082 ADI083 ADI084 ADI085 ADI086 ADI087 ADI088 ADI089 ADI090 ADI091 ADI092 ADI093 ADI094 ADI095 ADI096 ADI097 ADI098 ADI099 ADI100 ADI101 ADI102 ADI103 ADI104 ADI105 ADI106 ADI107 ADI108 ADI109 ADI110 ADI111 ADI112 ADI113 ADI114 ADI115 ADI116 ADI117 ADI118 ADI119 ADI120 ADI121 ADI122 ADI123 ADI124 ADI125 ADI126 ADI127 ADI128 ADI129 ADI130 ADI131 ADI132 ADI133 ADI134 ADI135 ADI136 ADI137 ADI138 ADI139 ADI140 
do

echo ${subj}

if [ -d /data/p_02161/DICOM/${subj}_bl ];
then
echo ${subj} 1 >> BL.txt

if [ -f /data/p_02161/ADI_studie/Adipositas_BL/${subj}*/*BOLD_resting_state*/*.nii ];
then
echo ${subj} 1 >> BL_rs.txt
fi
if [ -f /data/p_02161/ADI_studie/Adipositas_BL/${subj}*/*_DTI_64dir*TRACEW*/*DTI_64dir_*.nii ];
then
echo ${subj} 1 >> BL_dwi.txt
fi
fi 

if [ -d /data/p_02161/DICOM/${subj}_fu ];
then
echo ${subj} 1 >> FU.txt

if [ -f /data/p_02161/ADI_studie/Adipositas_FU/${subj}*/*BOLD_resting_state*/*.nii ];
then
echo ${subj} 1 >> FU_rs.txt
fi
if [ -f /data/p_02161/ADI_studie/Adipositas_FU/${subj}*/*_DTI_64dir*TRACEW*/*DTI_64dir_*.nii ];
then
echo ${subj} 1 >> FU_dwi.txt
fi
fi


if [ -d /data/p_02161/DICOM/${subj}_fu2 ];
then
echo ${subj} 1 >> FU2.txt
if [ -f /data/p_02161/ADI_studie/Adipositas_FU2/${subj}*/*BOLD_resting_state*/*.nii ];
then
echo ${subj} 1 >> FU2_rs.txt
fi
if [ -f /data/p_02161/ADI_studie/Adipositas_FU2/${subj}*/*_DTI_64dir*TRACEW*/*DTI_64dir_*.nii ];
then
echo ${subj} 1 >> FU2_dwi.txt
fi
fi

done

