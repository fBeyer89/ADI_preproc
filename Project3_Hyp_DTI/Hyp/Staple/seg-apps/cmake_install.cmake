# Install script for directory: /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/niftyseg-git/seg-apps

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

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Runtime")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_LoAd" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_LoAd")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_LoAd"
         RPATH "")
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/bin" TYPE EXECUTABLE FILES "/data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/seg-apps/seg_LoAd")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_LoAd" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_LoAd")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_LoAd")
    endif()
  endif()
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Runtime")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_stats" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_stats")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_stats"
         RPATH "")
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/bin" TYPE EXECUTABLE FILES "/data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/seg-apps/seg_stats")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_stats" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_stats")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_stats")
    endif()
  endif()
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Runtime")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_EM" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_EM")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_EM"
         RPATH "")
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/bin" TYPE EXECUTABLE FILES "/data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/seg-apps/seg_EM")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_EM" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_EM")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_EM")
    endif()
  endif()
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Runtime")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_LabFusion" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_LabFusion")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_LabFusion"
         RPATH "")
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/bin" TYPE EXECUTABLE FILES "/data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/seg-apps/seg_LabFusion")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_LabFusion" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_LabFusion")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_LabFusion")
    endif()
  endif()
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Runtime")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_maths" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_maths")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_maths"
         RPATH "")
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/bin" TYPE EXECUTABLE FILES "/data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/seg-apps/seg_maths")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_maths" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_maths")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_maths")
    endif()
  endif()
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Runtime")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_CalcTopNCC" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_CalcTopNCC")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_CalcTopNCC"
         RPATH "")
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/bin" TYPE EXECUTABLE FILES "/data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/seg-apps/seg_CalcTopNCC")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_CalcTopNCC" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_CalcTopNCC")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_CalcTopNCC")
    endif()
  endif()
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Runtime")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_PatchMatch" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_PatchMatch")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_PatchMatch"
         RPATH "")
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/bin" TYPE EXECUTABLE FILES "/data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/seg-apps/seg_PatchMatch")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_PatchMatch" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_PatchMatch")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_PatchMatch")
    endif()
  endif()
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Runtime")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_FillLesions" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_FillLesions")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_FillLesions"
         RPATH "")
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/bin" TYPE EXECUTABLE FILES "/data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/seg-apps/seg_FillLesions")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_FillLesions" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_FillLesions")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_FillLesions")
    endif()
  endif()
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_LabFusion" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_LabFusion")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_LabFusion"
         RPATH "")
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/bin" TYPE EXECUTABLE FILES "/data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/seg-apps/seg_LabFusion")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_LabFusion" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_LabFusion")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_LabFusion")
    endif()
  endif()
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_PatchMatch" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_PatchMatch")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_PatchMatch"
         RPATH "")
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/bin" TYPE EXECUTABLE FILES "/data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/seg-apps/seg_PatchMatch")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_PatchMatch" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_PatchMatch")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_PatchMatch")
    endif()
  endif()
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_EM" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_EM")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_EM"
         RPATH "")
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/bin" TYPE EXECUTABLE FILES "/data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/seg-apps/seg_EM")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_EM" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_EM")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_EM")
    endif()
  endif()
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_stats" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_stats")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_stats"
         RPATH "")
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/bin" TYPE EXECUTABLE FILES "/data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/seg-apps/seg_stats")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_stats" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_stats")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_stats")
    endif()
  endif()
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_maths" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_maths")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_maths"
         RPATH "")
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/bin" TYPE EXECUTABLE FILES "/data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/seg-apps/seg_maths")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_maths" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_maths")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_maths")
    endif()
  endif()
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_LoAd" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_LoAd")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_LoAd"
         RPATH "")
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/bin" TYPE EXECUTABLE FILES "/data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/seg-apps/seg_LoAd")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_LoAd" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_LoAd")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_LoAd")
    endif()
  endif()
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_CalcTopNCC" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_CalcTopNCC")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_CalcTopNCC"
         RPATH "")
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/bin" TYPE EXECUTABLE FILES "/data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/seg-apps/seg_CalcTopNCC")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_CalcTopNCC" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_CalcTopNCC")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_CalcTopNCC")
    endif()
  endif()
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_FillLesions" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_FillLesions")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_FillLesions"
         RPATH "")
  endif()
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/bin" TYPE EXECUTABLE FILES "/data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/seg-apps/seg_FillLesions")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_FillLesions" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_FillLesions")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/seg_FillLesions")
    endif()
  endif()
endif()

