if(EXISTS "/data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/Eigen/download/3.3-beta1.tar.gz")
  file("MD5" "/data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/Eigen/download/3.3-beta1.tar.gz" hash_value)
  if("x${hash_value}" STREQUAL "x4c46942dc67b48d69fd90f2fd10a4cf6")
    return()
  endif()
endif()
message(STATUS "downloading...
     src='http://cmictig.cs.ucl.ac.uk/images/3.3-beta1.tar.gz'
     dst='/data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/Eigen/download/3.3-beta1.tar.gz'
     timeout='none'")




file(DOWNLOAD
  "http://cmictig.cs.ucl.ac.uk/images/3.3-beta1.tar.gz"
  "/data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/Eigen/download/3.3-beta1.tar.gz"
  SHOW_PROGRESS
  # no TIMEOUT
  STATUS status
  LOG log)

list(GET status 0 status_code)
list(GET status 1 status_string)

if(NOT status_code EQUAL 0)
  message(FATAL_ERROR "error: downloading 'http://cmictig.cs.ucl.ac.uk/images/3.3-beta1.tar.gz' failed
  status_code: ${status_code}
  status_string: ${status_string}
  log: ${log}
")
endif()

message(STATUS "downloading... done")
