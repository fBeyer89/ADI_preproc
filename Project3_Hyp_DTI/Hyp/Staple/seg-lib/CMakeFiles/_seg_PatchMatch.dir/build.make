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
include seg-lib/CMakeFiles/_seg_PatchMatch.dir/depend.make

# Include the progress variables for this target.
include seg-lib/CMakeFiles/_seg_PatchMatch.dir/progress.make

# Include the compile flags for this target's objects.
include seg-lib/CMakeFiles/_seg_PatchMatch.dir/flags.make

seg-lib/CMakeFiles/_seg_PatchMatch.dir/_seg_PatchMatch.cpp.o: seg-lib/CMakeFiles/_seg_PatchMatch.dir/flags.make
seg-lib/CMakeFiles/_seg_PatchMatch.dir/_seg_PatchMatch.cpp.o: niftyseg-git/seg-lib/_seg_PatchMatch.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object seg-lib/CMakeFiles/_seg_PatchMatch.dir/_seg_PatchMatch.cpp.o"
	cd /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/seg-lib && /usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/_seg_PatchMatch.dir/_seg_PatchMatch.cpp.o -c /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/niftyseg-git/seg-lib/_seg_PatchMatch.cpp

seg-lib/CMakeFiles/_seg_PatchMatch.dir/_seg_PatchMatch.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/_seg_PatchMatch.dir/_seg_PatchMatch.cpp.i"
	cd /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/seg-lib && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/niftyseg-git/seg-lib/_seg_PatchMatch.cpp > CMakeFiles/_seg_PatchMatch.dir/_seg_PatchMatch.cpp.i

seg-lib/CMakeFiles/_seg_PatchMatch.dir/_seg_PatchMatch.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/_seg_PatchMatch.dir/_seg_PatchMatch.cpp.s"
	cd /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/seg-lib && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/niftyseg-git/seg-lib/_seg_PatchMatch.cpp -o CMakeFiles/_seg_PatchMatch.dir/_seg_PatchMatch.cpp.s

seg-lib/CMakeFiles/_seg_PatchMatch.dir/_seg_PatchMatch.cpp.o.requires:

.PHONY : seg-lib/CMakeFiles/_seg_PatchMatch.dir/_seg_PatchMatch.cpp.o.requires

seg-lib/CMakeFiles/_seg_PatchMatch.dir/_seg_PatchMatch.cpp.o.provides: seg-lib/CMakeFiles/_seg_PatchMatch.dir/_seg_PatchMatch.cpp.o.requires
	$(MAKE) -f seg-lib/CMakeFiles/_seg_PatchMatch.dir/build.make seg-lib/CMakeFiles/_seg_PatchMatch.dir/_seg_PatchMatch.cpp.o.provides.build
.PHONY : seg-lib/CMakeFiles/_seg_PatchMatch.dir/_seg_PatchMatch.cpp.o.provides

seg-lib/CMakeFiles/_seg_PatchMatch.dir/_seg_PatchMatch.cpp.o.provides.build: seg-lib/CMakeFiles/_seg_PatchMatch.dir/_seg_PatchMatch.cpp.o


seg-lib/CMakeFiles/_seg_PatchMatch.dir/_seg_PatchMatchResult.cpp.o: seg-lib/CMakeFiles/_seg_PatchMatch.dir/flags.make
seg-lib/CMakeFiles/_seg_PatchMatch.dir/_seg_PatchMatchResult.cpp.o: niftyseg-git/seg-lib/_seg_PatchMatchResult.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object seg-lib/CMakeFiles/_seg_PatchMatch.dir/_seg_PatchMatchResult.cpp.o"
	cd /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/seg-lib && /usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/_seg_PatchMatch.dir/_seg_PatchMatchResult.cpp.o -c /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/niftyseg-git/seg-lib/_seg_PatchMatchResult.cpp

seg-lib/CMakeFiles/_seg_PatchMatch.dir/_seg_PatchMatchResult.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/_seg_PatchMatch.dir/_seg_PatchMatchResult.cpp.i"
	cd /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/seg-lib && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/niftyseg-git/seg-lib/_seg_PatchMatchResult.cpp > CMakeFiles/_seg_PatchMatch.dir/_seg_PatchMatchResult.cpp.i

seg-lib/CMakeFiles/_seg_PatchMatch.dir/_seg_PatchMatchResult.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/_seg_PatchMatch.dir/_seg_PatchMatchResult.cpp.s"
	cd /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/seg-lib && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/niftyseg-git/seg-lib/_seg_PatchMatchResult.cpp -o CMakeFiles/_seg_PatchMatch.dir/_seg_PatchMatchResult.cpp.s

seg-lib/CMakeFiles/_seg_PatchMatch.dir/_seg_PatchMatchResult.cpp.o.requires:

.PHONY : seg-lib/CMakeFiles/_seg_PatchMatch.dir/_seg_PatchMatchResult.cpp.o.requires

seg-lib/CMakeFiles/_seg_PatchMatch.dir/_seg_PatchMatchResult.cpp.o.provides: seg-lib/CMakeFiles/_seg_PatchMatch.dir/_seg_PatchMatchResult.cpp.o.requires
	$(MAKE) -f seg-lib/CMakeFiles/_seg_PatchMatch.dir/build.make seg-lib/CMakeFiles/_seg_PatchMatch.dir/_seg_PatchMatchResult.cpp.o.provides.build
.PHONY : seg-lib/CMakeFiles/_seg_PatchMatch.dir/_seg_PatchMatchResult.cpp.o.provides

seg-lib/CMakeFiles/_seg_PatchMatch.dir/_seg_PatchMatchResult.cpp.o.provides.build: seg-lib/CMakeFiles/_seg_PatchMatch.dir/_seg_PatchMatchResult.cpp.o


# Object files for target _seg_PatchMatch
_seg_PatchMatch_OBJECTS = \
"CMakeFiles/_seg_PatchMatch.dir/_seg_PatchMatch.cpp.o" \
"CMakeFiles/_seg_PatchMatch.dir/_seg_PatchMatchResult.cpp.o"

# External object files for target _seg_PatchMatch
_seg_PatchMatch_EXTERNAL_OBJECTS =

seg-lib/lib_seg_PatchMatch.a: seg-lib/CMakeFiles/_seg_PatchMatch.dir/_seg_PatchMatch.cpp.o
seg-lib/lib_seg_PatchMatch.a: seg-lib/CMakeFiles/_seg_PatchMatch.dir/_seg_PatchMatchResult.cpp.o
seg-lib/lib_seg_PatchMatch.a: seg-lib/CMakeFiles/_seg_PatchMatch.dir/build.make
seg-lib/lib_seg_PatchMatch.a: seg-lib/CMakeFiles/_seg_PatchMatch.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Linking CXX static library lib_seg_PatchMatch.a"
	cd /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/seg-lib && $(CMAKE_COMMAND) -P CMakeFiles/_seg_PatchMatch.dir/cmake_clean_target.cmake
	cd /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/seg-lib && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/_seg_PatchMatch.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
seg-lib/CMakeFiles/_seg_PatchMatch.dir/build: seg-lib/lib_seg_PatchMatch.a

.PHONY : seg-lib/CMakeFiles/_seg_PatchMatch.dir/build

seg-lib/CMakeFiles/_seg_PatchMatch.dir/requires: seg-lib/CMakeFiles/_seg_PatchMatch.dir/_seg_PatchMatch.cpp.o.requires
seg-lib/CMakeFiles/_seg_PatchMatch.dir/requires: seg-lib/CMakeFiles/_seg_PatchMatch.dir/_seg_PatchMatchResult.cpp.o.requires

.PHONY : seg-lib/CMakeFiles/_seg_PatchMatch.dir/requires

seg-lib/CMakeFiles/_seg_PatchMatch.dir/clean:
	cd /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/seg-lib && $(CMAKE_COMMAND) -P CMakeFiles/_seg_PatchMatch.dir/cmake_clean.cmake
.PHONY : seg-lib/CMakeFiles/_seg_PatchMatch.dir/clean

seg-lib/CMakeFiles/_seg_PatchMatch.dir/depend:
	cd /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/niftyseg-git /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/niftyseg-git/seg-lib /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/seg-lib /data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/seg-lib/CMakeFiles/_seg_PatchMatch.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : seg-lib/CMakeFiles/_seg_PatchMatch.dir/depend

