#include <opencv2/opencv.hpp>
#include <cstdint>
#include <cstdlib>
#include <android/log.h>

#define LOG_TAG "NativeDebug"
#define LOGD(...) __android_log_print(ANDROID_LOG_DEBUG, LOG_TAG, __VA_ARGS__)
#define LOGE(...) __android_log_print(ANDROID_LOG_ERROR, LOG_TAG, __VA_ARGS__)

extern "C" {
// Flutter와 연결될 함수
int
convert_to_grayscale(unsigned char *input_data, unsigned char *output_data, int width, int height) {
    try {
        cv::Mat input_image(height, width, CV_8UC3, input_data);
        cv::Mat gray_image;
        cv::cvtColor(input_image, gray_image, cv::COLOR_BGR2GRAY);

        memcpy(output_data, gray_image.data, width * height);
        LOGD("convert_to_grayscale Success");
        return 0;
    } catch (...) {
        LOGE("convert_to_grayscale Err");
        return -1;
    }
}
}