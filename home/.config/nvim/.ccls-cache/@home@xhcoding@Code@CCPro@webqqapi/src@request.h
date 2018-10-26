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

#ifndef WEBQQAPI_REQUEST_H
#define WEBQQAPI_REQUEST_H
#include <curl/curl.h>
#include <fstream>
#include <map>
#include <string>
#include <vector>
#include "cookie.h"

namespace webqqapi {
// libcurl的回调函数，处理body
size_t write_callback(char *buffer, size_t size, size_t nmemb, void *user_data);
// libcurl的回调函数，处理header
size_t header_callback(char *buffer, size_t size, size_t nitems,
                       void *user_data);

// http请求方法
enum HTTP_REQUEST_METHON {
  GET = 1,
  POST = 2,
  HEAD = 3,
  PUT = 4,
  DELETE = 5,
  OPTIONS = 6,
  CONNECT = 7,
  TRACE = 8
};

using HRM = HTTP_REQUEST_METHON;

// 一些请求选项
enum HTTP_REQUEST_EXTRA_OPTIONAL {
  FOLLOW_LOCATION = 1L << 1,
  KEEP_ALIVE = 1L << 2,
  ACCEPT_GZIP = 1L << 3,
  VERBOSE = 1L << 4
};

using HREO = HTTP_REQUEST_EXTRA_OPTIONAL;
constexpr int DEFAULT_EXTRA_OPTIONAL = (KEEP_ALIVE | ACCEPT_GZIP);

class HttpSession {
 public:
  HttpSession();
  HttpSession(const HttpSession &) = delete;
  HttpSession &operator=(const HttpSession &) = delete;
  ~HttpSession();

  // 请求url，返回HttpRequest对象
  HttpSession &Request(std::string url, std::string data = "", int method = GET,
                       int optional = DEFAULT_EXTRA_OPTIONAL);

  // 返回body
  std::string Body() const;

  // 返回对应name的响应头
  std::string RespHeader(const std::string &name);

  // 设置请求头
  void ReqHeader(const std::map<std::string, std::string> &headers);
  void ReqHeader(const std::string &name, const std::string &value);
  std::map<std::string, std::string> ReqHeader() { return req_headers_; }

  // 返回状态码
  std::string StatusCode() const;

  // 返回name对应的cookie对象
  Cookie Cookies(const std::string &name) const;

  // 指定Path下的cookie组装成一个cookie请求头
  std::string CookieHeader(const std::string &path) const;

  // 返回所有的cookie
  std::string ShowCookies() const;

 private:
  // 处理返回的body
  size_t ProcessBody(char *buffer, size_t size, size_t nmemb);

  // 处理返回的headers
  size_t ProcessHeaders(char *buffer, size_t size, size_t nitems);

  // 清除上一次请求的数据
  void ClearLastData();
  // 初始化请求选项
  void InitCurlOpt(std::string &url, std::string data = "",
                   HRM method = GET) const;

  // 访问ProcessBody
  friend size_t write_callback(char *ptr, size_t size, size_t nmemb,
                               void *userdata);
  // 访问ProcessHeaders
  friend size_t header_callback(char *buffer, size_t size, size_t nitems,
                                void *user_data);
  // 每次请求的url
  std::string url_;
  // 所有请求的cookie
  std::map<std::string, Cookie> cookies_;
  // 每次请求的参数
  std::map<std::string, std::string> params_;
  // 每次请求的头
  std::map<std::string, std::string> req_headers_;
  // 每次的响应头
  std::map<std::string, std::string> resp_headers_;
  // 每次响应的http版本
  std::string http_version_;
  // 返回的状态码
  std::string status_code_;
  // 返回的状态字符串
  std::string status_str_;
  // 返回的body
  std::string resp_content_;

  // libcurl的curl对象
  CURL *curl_;
};
}  // namespace webqqapi
#endif /* WEBQQAPI_REQUEST_H */
