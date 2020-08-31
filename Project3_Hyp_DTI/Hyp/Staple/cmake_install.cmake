# Install script for directory: /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/niftyseg-git

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr/local")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include" TYPE DIRECTORY FILES "/data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/Eigen/install//Eigen")
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "applications")
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/usr/local/bin/LoAd_brainonly.sh")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/usr/local/bin" TYPE PROGRAM FILES "/data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/LoAd_brainonly.sh")
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "applications")
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/usr/local/priors/ECSF_prior.nii.gz;/usr/local/priors/T1.nii.gz;/usr/local/priors/CGM_prior.nii.gz;/usr/local/priors/ICSF_prior.nii.gz;/usr/local/priors/DGM_prior.nii.gz;/usr/local/priors/WM_prior.nii.gz;/usr/local/priors/Cerebelum.nii.gz")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/usr/local/priors" TYPE PROGRAM FILES
    "/data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/niftyseg-git/priors/ECSF_prior.nii.gz"
    "/data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/niftyseg-git/priors/T1.nii.gz"
    "/data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/niftyseg-git/priors/CGM_prior.nii.gz"
    "/data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/niftyseg-git/priors/ICSF_prior.nii.gz"
    "/data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/niftyseg-git/priors/DGM_prior.nii.gz"
    "/data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/niftyseg-git/priors/WM_prior.nii.gz"
    "/data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/niftyseg-git/priors/Cerebelum.nii.gz"
    )
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("/data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/nifti/cmake_install.cmake")
  include("/data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/seg-lib/cmake_install.cmake")
  include("/data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/seg-apps/cmake_install.cmake")

endif()

if(CMAKE_INSTALL_COMPONENT)
  set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
file(WRITE "/data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/${CMAKE_INSTALL_MANIFEST}"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
