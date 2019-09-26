# Subjects for preprocessing

#### All subjects included into basic cross-sectional preprocessing

['ADI003_fu2','ADI003_fu','ADI004_fu2','ADI005_fu2','ADI006_bl','ADI006_fu2','ADI006_fu','ADI007_bl','ADI008_bl','ADI009_bl',\ 'ADI009_fu2','ADI009_fu','ADI013_bl','ADI013_fu','ADI013_fu2','ADI014_fu','ADI014_fu2','ADI016_bl','ADI016_fu','ADI016_fu2',\ 'ADI020_bl','ADI020_fu','ADI020_fu2','ADI025_bl','ADI025_fu','ADI026_bl','ADI029_fu','ADI029_fu2','ADI032_bl','ADI033_bl',\ 'ADI036_bl','ADI036_fu','ADI036_fu2','ADI041_bl','ADI041_fu','ADI045_bl','ADI045_fu','ADI045_fu2','ADI046_bl','ADI046_fu','ADI046_fu2',\ 'ADI047_fu','ADI047_fu2','ADI048_bl','ADI048_fu','ADI048_fu2','ADI049_bl','ADI049_fu','ADI049_fu2','ADI050_fu','ADI050_fu2','ADI053_fu',\ 'ADI053_fu2','ADI061_bl','ADI061_fu','ADI061_fu2','ADI062_bl','ADI062_fu','ADI062_fu2','ADI063_bl','ADI063_fu','ADI064_bl','ADI064_fu',\ 'ADI064_fu2','ADI068_bl','ADI068_fu','ADI068_fu2','ADI069_bl','ADI069_fu','ADI072_bl','ADI072_fu','ADI072_fu2','ADI080_bl','ADI082_fu',\ 'ADI082_fu2','ADI087_bl','ADI087_fu','ADI087_fu2','ADI088_fu','ADI088_fu2','ADI089_bl','ADI091_fu','ADI093_fu','ADI095_fu','ADI097_bl',\ 'ADI097_fu','ADI097_fu2','ADI102_bl','ADI102_fu','ADI107_bl','ADI107_fu','ADI111_bl','ADI111_fu','ADI111_fu2','ADI116_bl','ADI116_fu',\ 'ADI116_fu2','ADI118_bl','ADI124_bl','ADI124_fu','ADI124_fu2','ADI136_bl','ADI139_bl','ADI139_fu','ADI140_bl','ADI140_fu','ADI140_fu2],'

Solved "special" cases

- ADI041_bl, ADI088_fu2 > merged rs scans
- ADI049_bl > different acquisition names

Nonsolvable/Problem cases

- ADI014_bl > no T1 image
- ADI002_fu2 > non isotropic T1
- ADI091_fu2 > no usable sequences 

Excluded due to excessive head motion in anatomical/functional

- ADI116_bl, ADI116_fu, ADI116_fu2
- ADI009_fu2
- ADI063_bl, ADI063_fu

#### Preprocessing "long" (workflow_long.py)

###### those without any manual freesurfer edits:

['ADI005_fu2','ADI007_bl', 'ADI014_fu', 'ADI014_fu2','ADI016_fu','ADI016_fu2','ADI020_bl','ADI020_fu','ADI020_fu2','ADI036_fu','ADI046_bl',
'ADI046_fu','ADI046_fu2','ADI049_fu','ADI049_fu2','ADI050_fu2','ADI053_fu','ADI053_fu2',
'ADI061_bl','ADI061_fu','ADI061_fu2','ADI062_bl','ADI062_fu',,'ADI064_fu','ADI064_fu2',
'ADI082_fu2','ADI087_bl','ADI088_fu2','ADI093_fu','ADI095_fu','ADI111_bl','ADI111_fu','ADI111_fu2','ADI124_bl',
'ADI124_fu','ADI139_bl','ADI140_bl','ADI140_fu','ADI140_fu2']

###### those with manual freesurfer edits (long must be checked again)

'ADI003_fu2','ADI003_fu','ADI004_fu2','ADI006_bl','ADI006_fu2','ADI006_fu','ADI008_bl','ADI009_bl','ADI009_fu',
'ADI013_bl','ADI013_fu','ADI013_fu2','ADI025_bl','ADI025_fu','ADI026_bl','ADI029_fu','ADI029_fu2',
'ADI036_bl','ADI036_fu2','ADI041_fu','ADI045_bl','ADI045_fu','ADI045_fu2','ADI047_fu','ADI047_fu2',
'ADI048_bl','ADI048_fu','ADI048_fu2','ADI062_fu2','ADI064_bl','ADI068_bl','ADI068_fu','ADI068_fu2', 'ADI069_bl', 'ADI069_fu'


