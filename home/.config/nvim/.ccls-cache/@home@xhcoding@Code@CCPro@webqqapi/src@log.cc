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

#include "log.h"

#ifdef STDOUT
#include <iostream>
#endif

namespace webqqapi {
namespace log {

Logger* Logger::instance_ = 0;

static void HandleSigint(int signo) {
  Logger::Instance()->Destroy();
  exit(1);
}

void Logger::InitLogger() {
  max_buffer_size_ = 1024 * 5;
  stdout_level_ = Level_INFO | Level_WARNING | Level_ERROR;
  buffer_.clear();
  // 异常中断时的日志处理
  signal(SIGINT, HandleSigint);
}

Logger* Logger::Instance() {
  if (instance_ == 0) {
    instance_ = new Logger();
  }
  return instance_;
}

Logger::Logger() {
  InitLogger();
  log_file_ = "webqqapi.log";
}

Logger::Logger(std::string log_file) {
  InitLogger();
  log_file_ = log_file;
}

int Logger::WriteLog(std::string log_msg, Level l) {
  // 第一行插入时间字符串
  log_msg = InsertHeader(log_msg, l);
#ifdef STDOUT
  if ((l & stdout_level_) != 0) {
    std::cout << log_msg << std::endl;
  }
#endif
  if (log_msg[log_msg.size() - 1] != '\n') {
    log_msg.append("\n");
  }

  if (log_msg.size() > max_buffer_size_) {
    // 如果信息比buffer大，直接把信息写入文件
    WriteToFile(log_msg);
    return log_msg.size();
  }
  if (max_buffer_size_ < buffer_.size() + log_msg.size()) {
    // 如果缓冲区不够，先写入文件
    // NOTE: 写入文件失败
    WriteToFile(buffer_);
    buffer_.clear();
  }
  buffer_.append(log_msg);
  return log_msg.size();
}

std::string& Logger::InsertHeader(std::string& log_msg, Level l) {
  std::string level_str;
  switch (l) {
    case Level_TRACE:
      level_str = "TRACE";
      break;
    case Level_DEBUG:
      level_str = "DEBUG";
      break;
    case Level_INFO:
      level_str = "INFO";
      break;
    case Level_WARNING:
      level_str = "WARNING";
      break;
    case Level_ERROR:
      level_str = "ERROR";
      break;
    default:
      break;
  }
  // 获取当前时间
  char time_str[100];
  time_t t = time(0);
  strftime(time_str, 100, "%Y-%m-%d:%H-%M-%S", localtime(&t));
  std::string header_str;
  header_str.append("[");
  header_str.append(time_str);
  header_str.append(" ");
  header_str.append(level_str + "]: ");
  log_msg.insert(0, header_str);
  return log_msg;
}

int Logger::WriteToFile(std::string& str) {
  std::ofstream fout(log_file_.c_str(), std::ios::out | std::ios::app);
  if (!fout) {
    // NOTE:不能打开日志文件
    return 0;
  }
  fout << str;
  if (!fout.good()) {
    return 0;
  }
  fout.close();
  return 1;
}

void Logger::Destroy(void) {
  // 把buffer还存在的内容写到文件中
  if (!buffer_.empty()) {
    WriteToFile(buffer_);
  }
  delete instance_;
  instance_ = 0;
}

}  // namespace log
}  // namespace webqqapi
