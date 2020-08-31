set(file "/data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/Eigen/download/3.3-beta1.tar.gz")
message(STATUS "verifying file...
     file='${file}'")
set(expect_value "4c46942dc67b48d69fd90f2fd10a4cf6")
set(attempt 0)
set(succeeded 0)
while(${attempt} LESS 3 OR ${attempt} EQUAL 3 AND NOT ${succeeded})
  file(MD5 "${file}" actual_value)
  if("${actual_value}" STREQUAL "${expect_value}")
    set(succeeded 1)
  elseif(${attempt} LESS 3)
    message(STATUS "MD5 hash of ${file}
does not match expected value
  expected: ${expect_value}
    actual: ${actual_value}
Retrying download.
")
    file(REMOVE "${file}")
    execute_process(COMMAND ${CMAKE_COMMAND} -P "/data/pt_life_hypothalamus_segmentation/segmentation/Scripts/Staple/Eigen/stamps/download-Eigen.cmake")
  endif()
  math(EXPR attempt "${attempt} + 1")
endwhile()

if(${succeeded})
  message(STATUS "verifying file... done")
else()
  message(FATAL_ERROR "error: MD5 hash of
  ${file}
does not match expected value
  expected: ${expect_value}
    actual: ${actual_value}
")
endif()
