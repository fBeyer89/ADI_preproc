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
include seg-apps/CMakeFiles/seg_maths.dir/depend.make

# Include the progress variables for this target.
include seg-apps/CMakeFiles/seg_maths.dir/progress.make

# Include the compile flags for this target's objects.
include seg-apps/CMakeFiles/seg_maths.dir/flags.make

seg-apps/CMakeFiles/seg_maths.dir/seg_maths.cpp.o: seg-apps/CMakeFiles/seg_maths.dir/flags.make
seg-apps/CMakeFiles/seg_maths.dir/seg_maths.cpp.o: niftyseg-git/seg-apps/seg_maths.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object seg-apps/CMakeFiles/seg_maths.dir/seg_maths.cpp.o"
	cd /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/seg-apps && /usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/seg_maths.dir/seg_maths.cpp.o -c /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/niftyseg-git/seg-apps/seg_maths.cpp

seg-apps/CMakeFiles/seg_maths.dir/seg_maths.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/seg_maths.dir/seg_maths.cpp.i"
	cd /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/seg-apps && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/niftyseg-git/seg-apps/seg_maths.cpp > CMakeFiles/seg_maths.dir/seg_maths.cpp.i

seg-apps/CMakeFiles/seg_maths.dir/seg_maths.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/seg_maths.dir/seg_maths.cpp.s"
	cd /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/seg-apps && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/niftyseg-git/seg-apps/seg_maths.cpp -o CMakeFiles/seg_maths.dir/seg_maths.cpp.s

seg-apps/CMakeFiles/seg_maths.dir/seg_maths.cpp.o.requires:

.PHONY : seg-apps/CMakeFiles/seg_maths.dir/seg_maths.cpp.o.requires

seg-apps/CMakeFiles/seg_maths.dir/seg_maths.cpp.o.provides: seg-apps/CMakeFiles/seg_maths.dir/seg_maths.cpp.o.requires
	$(MAKE) -f seg-apps/CMakeFiles/seg_maths.dir/build.make seg-apps/CMakeFiles/seg_maths.dir/seg_maths.cpp.o.provides.build
.PHONY : seg-apps/CMakeFiles/seg_maths.dir/seg_maths.cpp.o.provides

seg-apps/CMakeFiles/seg_maths.dir/seg_maths.cpp.o.provides.build: seg-apps/CMakeFiles/seg_maths.dir/seg_maths.cpp.o


# Object files for target seg_maths
seg_maths_OBJECTS = \
"CMakeFiles/seg_maths.dir/seg_maths.cpp.o"

# External object files for target seg_maths
seg_maths_EXTERNAL_OBJECTS =

seg-apps/seg_maths: seg-apps/CMakeFiles/seg_maths.dir/seg_maths.cpp.o
seg-apps/seg_maths: seg-apps/CMakeFiles/seg_maths.dir/build.make
seg-apps/seg_maths: seg-lib/lib_seg_tools.a
seg-apps/seg_maths: seg-lib/lib_seg_FMM.a
seg-apps/seg_maths: nifti/lib_seg_nifti.a
seg-apps/seg_maths: seg-apps/CMakeFiles/seg_maths.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable seg_maths"
	cd /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/seg-apps && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/seg_maths.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
seg-apps/CMakeFiles/seg_maths.dir/build: seg-apps/seg_maths

.PHONY : seg-apps/CMakeFiles/seg_maths.dir/build

seg-apps/CMakeFiles/seg_maths.dir/requires: seg-apps/CMakeFiles/seg_maths.dir/seg_maths.cpp.o.requires

.PHONY : seg-apps/CMakeFiles/seg_maths.dir/requires

seg-apps/CMakeFiles/seg_maths.dir/clean:
	cd /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/seg-apps && $(CMAKE_COMMAND) -P CMakeFiles/seg_maths.dir/cmake_clean.cmake
.PHONY : seg-apps/CMakeFiles/seg_maths.dir/clean

seg-apps/CMakeFiles/seg_maths.dir/depend:
	cd /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/niftyseg-git /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/niftyseg-git/seg-apps /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/seg-apps /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/seg-apps/CMakeFiles/seg_maths.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : seg-apps/CMakeFiles/seg_maths.dir/depend
