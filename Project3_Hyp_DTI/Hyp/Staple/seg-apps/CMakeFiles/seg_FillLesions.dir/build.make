# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.5

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/niftyseg-git

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple

# Include any dependencies generated for this target.
include seg-apps/CMakeFiles/seg_FillLesions.dir/depend.make

# Include the progress variables for this target.
include seg-apps/CMakeFiles/seg_FillLesions.dir/progress.make

# Include the compile flags for this target's objects.
include seg-apps/CMakeFiles/seg_FillLesions.dir/flags.make

seg-apps/CMakeFiles/seg_FillLesions.dir/seg_FillLesions.cpp.o: seg-apps/CMakeFiles/seg_FillLesions.dir/flags.make
seg-apps/CMakeFiles/seg_FillLesions.dir/seg_FillLesions.cpp.o: niftyseg-git/seg-apps/seg_FillLesions.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object seg-apps/CMakeFiles/seg_FillLesions.dir/seg_FillLesions.cpp.o"
	cd /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/seg-apps && /usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/seg_FillLesions.dir/seg_FillLesions.cpp.o -c /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/niftyseg-git/seg-apps/seg_FillLesions.cpp

seg-apps/CMakeFiles/seg_FillLesions.dir/seg_FillLesions.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/seg_FillLesions.dir/seg_FillLesions.cpp.i"
	cd /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/seg-apps && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/niftyseg-git/seg-apps/seg_FillLesions.cpp > CMakeFiles/seg_FillLesions.dir/seg_FillLesions.cpp.i

seg-apps/CMakeFiles/seg_FillLesions.dir/seg_FillLesions.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/seg_FillLesions.dir/seg_FillLesions.cpp.s"
	cd /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/seg-apps && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/niftyseg-git/seg-apps/seg_FillLesions.cpp -o CMakeFiles/seg_FillLesions.dir/seg_FillLesions.cpp.s

seg-apps/CMakeFiles/seg_FillLesions.dir/seg_FillLesions.cpp.o.requires:

.PHONY : seg-apps/CMakeFiles/seg_FillLesions.dir/seg_FillLesions.cpp.o.requires

seg-apps/CMakeFiles/seg_FillLesions.dir/seg_FillLesions.cpp.o.provides: seg-apps/CMakeFiles/seg_FillLesions.dir/seg_FillLesions.cpp.o.requires
	$(MAKE) -f seg-apps/CMakeFiles/seg_FillLesions.dir/build.make seg-apps/CMakeFiles/seg_FillLesions.dir/seg_FillLesions.cpp.o.provides.build
.PHONY : seg-apps/CMakeFiles/seg_FillLesions.dir/seg_FillLesions.cpp.o.provides

seg-apps/CMakeFiles/seg_FillLesions.dir/seg_FillLesions.cpp.o.provides.build: seg-apps/CMakeFiles/seg_FillLesions.dir/seg_FillLesions.cpp.o


# Object files for target seg_FillLesions
seg_FillLesions_OBJECTS = \
"CMakeFiles/seg_FillLesions.dir/seg_FillLesions.cpp.o"

# External object files for target seg_FillLesions
seg_FillLesions_EXTERNAL_OBJECTS =

seg-apps/seg_FillLesions: seg-apps/CMakeFiles/seg_FillLesions.dir/seg_FillLesions.cpp.o
seg-apps/seg_FillLesions: seg-apps/CMakeFiles/seg_FillLesions.dir/build.make
seg-apps/seg_FillLesions: seg-lib/lib_seg_fill_lesions.a
seg-apps/seg_FillLesions: seg-lib/lib_seg_fill_lesions_other.a
seg-apps/seg_FillLesions: seg-lib/lib_seg_tools.a
seg-apps/seg_FillLesions: seg-lib/lib_seg_FMM.a
seg-apps/seg_FillLesions: nifti/lib_seg_nifti.a
seg-apps/seg_FillLesions: seg-apps/CMakeFiles/seg_FillLesions.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable seg_FillLesions"
	cd /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/seg-apps && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/seg_FillLesions.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
seg-apps/CMakeFiles/seg_FillLesions.dir/build: seg-apps/seg_FillLesions

.PHONY : seg-apps/CMakeFiles/seg_FillLesions.dir/build

seg-apps/CMakeFiles/seg_FillLesions.dir/requires: seg-apps/CMakeFiles/seg_FillLesions.dir/seg_FillLesions.cpp.o.requires

.PHONY : seg-apps/CMakeFiles/seg_FillLesions.dir/requires

seg-apps/CMakeFiles/seg_FillLesions.dir/clean:
	cd /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/seg-apps && $(CMAKE_COMMAND) -P CMakeFiles/seg_FillLesions.dir/cmake_clean.cmake
.PHONY : seg-apps/CMakeFiles/seg_FillLesions.dir/clean

seg-apps/CMakeFiles/seg_FillLesions.dir/depend:
	cd /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/niftyseg-git /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/niftyseg-git/seg-apps /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/seg-apps /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/seg-apps/CMakeFiles/seg_FillLesions.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : seg-apps/CMakeFiles/seg_FillLesions.dir/depend

