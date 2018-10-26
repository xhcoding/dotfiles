/* Copyright (c) 2018 xhcoding, <xhcoding@163.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
==============================================================================*/

#ifndef WEBQQAPI_LOG_H
#define WEBQQAPI_LOG_H

#include <signal.h>
#include <time.h>
#include <fstream>
#include <string>

// 标准输出日志
#define STDOUT 1

namespace webqqapi {

namespace log {

enum Level {
  Level_TRACE = 1L << 1,
  Level_DEBUG = 1L << 2,
  Level_INFO = 1L << 3,
  Level_WARNING = 1L << 4,
  Level_ERROR = 1L << 5
};
// TODO: 异常中断时日志不能正确写入
class Logger {
 public:
  static Logger* Instance();

  // 在每条信息前插入头部，包括时间和日志等级
  std::string& InsertHeader(std::string& log_msg, Level l);

  int WriteLog(std::string log_msg, Level l);

  std::string::size_type MaxBufferSize() const { return max_buffer_size_; }
  void MaxBufferSize(std::string::size_type max_buffer_size) {
    max_buffer_size_ = max_buffer_size;
  }

  void StdoutLevel(int stdout_level) { stdout_level_ = stdout_level | stdout_level_; }

  // 程序退出前必须调用此函数做清理工作
  void Destroy(void);

 protected:
  Logger();
  Logger(std::string log_file);

 private:
  // 初始化日志
  void InitLogger();
  // 把str写到文件中
  int WriteToFile(std::string& str);

  std::string buffer_;
  std::string::size_type max_buffer_size_;
  std::string log_file_;
  // 输出级别
  int stdout_level_;

  static Logger* instance_;
};

}  // namespace log

}  // namespace webqqapi

#define LOG_T(log_msg)                                 \
  webqqapi::log::Logger::Instance()->WriteLog(log_msg, \
                                              webqqapi::log::Level_TRACE)
#define LOG_D(log_msg)                                  \
  webqqapi::log::Logger::Instance()->WriteLog(          \
      "[" + std::string(__FUNCTION__) + "] " + log_msg, \
      webqqapi::log::Level_DEBUG)
#define LOG_I(log_msg)                                 \
  webqqapi::log::Logger::Instance()->WriteLog(log_msg, \
                                              webqqapi::log::Level_INFO)
#define LOG_W(log_msg)                                 \
  webqqapi::log::Logger::Instance()->WriteLog(log_msg, \
                                              webqqapi::log::Level_WARNING)
#define LOG_E(log_msg)                         \
  webqqapi::log::Logger::Instance()->WriteLog( \
      std::string(log_msg) + __FUNCTION__, webqqapi::log::Level_ERROR)

#endif /* WEBQQAPI_LOG_H */
