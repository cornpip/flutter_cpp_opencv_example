cmake_minimum_required(VERSION 3.10)
project(native_process)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# OpenCV SDK 경로 설정
set(OpenCV_DIR "${CMAKE_SOURCE_DIR}/opencv/sdk/native/jni")
find_package(OpenCV REQUIRED)

# 네이티브 라이브러리 생성
add_library(native_process SHARED native_process.cpp)

# OpenCV 포함
target_include_directories(native_process PRIVATE ${OpenCV_INCLUDE_DIRS})
target_link_libraries(native_process ${OpenCV_LIBS} log)
