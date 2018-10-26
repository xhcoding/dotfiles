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
#include "request.h"
#include "utils.h"
namespace webqqapi {

// TODO：加上日志
HttpSession::HttpSession() {
  // 初始化libcurl
  CURLcode res_code;
  res_code = curl_global_init(CURL_GLOBAL_SSL);
  if (CURLE_OK != res_code) {
    throw - 1;
  }
  // 获取easy_handle
  curl_ = curl_easy_init();
  if (NULL == curl_) {
    curl_global_cleanup();
    throw - 1;
  }
}

HttpSession &HttpSession::Request(std::string url, std::string data, int method,
                                  int optional) {
  // 清除上一次请求的一些数据
  ClearLastData();
  // 重设opt
  curl_easy_reset(curl_);
  if (method == GET) {
    url += "?" + data;
  }
  // NOTE:一个坑，不能把初始化的选项放在另一个函数中执行。
  // InitCurlOpt(url, data, method);
  curl_easy_setopt(curl_, CURLOPT_URL, url.c_str());
  // 设置一些不变的选项
  curl_easy_setopt(curl_, CURLOPT_WRITEFUNCTION, &write_callback);
  curl_easy_setopt(curl_, CURLOPT_WRITEDATA, (void *)this);
  curl_easy_setopt(curl_, CURLOPT_HEADERFUNCTION, &header_callback);
  curl_easy_setopt(curl_, CURLOPT_HEADERDATA, (void *)this);

  if ((optional & ACCEPT_GZIP) != 0) {
    curl_easy_setopt(curl_, CURLOPT_ACCEPT_ENCODING, "gzip, deflate, br");
  }
  if ((optional & KEEP_ALIVE) != 0) {
    /* 激活 TCP keep-alive  */
    curl_easy_setopt(curl_, CURLOPT_TCP_KEEPALIVE, 1L);
    curl_easy_setopt(curl_, CURLOPT_TCP_KEEPIDLE, 120L);
    curl_easy_setopt(curl_, CURLOPT_TCP_KEEPINTVL, 60L);
  }

  if ((optional & FOLLOW_LOCATION) != 0) {
    // 30x
    curl_easy_setopt(curl_, CURLOPT_FOLLOWLOCATION, 1L);
  }
  if ((optional & VERBOSE) != 0) {
    curl_easy_setopt(curl_, CURLOPT_VERBOSE, 1L);
  }

  // 设置请求头
  struct curl_slist *chunk = NULL;
  for (auto &header : req_headers_) {
    chunk = curl_slist_append(
        chunk, std::string(header.first + ": " + header.second).c_str());
  }
  curl_easy_setopt(curl_, CURLOPT_HTTPHEADER, chunk);
  if (method == POST) {
    curl_easy_setopt(curl_, CURLOPT_POST, 1L);
    curl_easy_setopt(curl_, CURLOPT_POSTFIELDS, data.c_str());
    curl_easy_setopt(curl_, CURLOPT_POSTFIELDSIZE, data.size());
  }

  CURLcode res_code;
  if ((res_code = curl_easy_perform(curl_)) != CURLE_OK) {
    exit(1);
  }
  return *this;
}

std::string HttpSession::Body() const { return resp_content_; }

std::string HttpSession::RespHeader(const std::string &name) {
  return resp_headers_[name];
}

Cookie HttpSession::Cookies(const std::string &name) const {
  auto iter = cookies_.find(name);
  if (iter != cookies_.end()) {
    return iter->second;
  }
  return Cookie();
}

void HttpSession::ReqHeader(const std::map<std::string, std::string> &headers) {
  req_headers_.clear();
  req_headers_.insert(headers.begin(), headers.end());
}

void HttpSession::ReqHeader(const std::string &name, const std::string &value) {
  req_headers_[name] = value;
}

std::string HttpSession::StatusCode() const { return status_code_; }

HttpSession::~HttpSession() {
  curl_easy_cleanup(curl_);
  curl_global_cleanup();
}

size_t HttpSession::ProcessBody(char *buffer, size_t size, size_t nmemb) {
  int i = 0;
  for (i = 0; i < nmemb; i++) {
    resp_content_.push_back(*(buffer + i));
  }
  return i;
}

size_t HttpSession::ProcessHeaders(char *buffer, size_t size, size_t nitems) {
  std::string s(buffer, buffer + nitems - 2);  // 去掉/r/n
  // 没有split的锅
  if (http_version_.empty()) {
    // 第一行
    auto v = SplitString(s, " ");
    http_version_ = v[0];
    status_code_ = v[1];
    status_str_ = v[2];
  } else {
    auto v = SplitString(s, ": ", 1);
    if (v[0] != s) {
      std::string name = v[0];
      std::string value = v[1];

      // 把cookie加到cookies
      if ("Set-Cookie" == name) {
        Cookie cookie = Cookie::ParseCookieStr(value);
        cookies_.insert(make_pair(cookie.Name(), cookie));
      } else {
        resp_headers_[name] = value;
      }
    }
  }
  return nitems;
}

void HttpSession::ClearLastData() {
  resp_headers_.clear();
  http_version_.clear();
  status_code_.clear();
  status_str_.clear();
  resp_content_.clear();
}

std::string HttpSession::CookieHeader(const std::string &path) const {
  std::string cookie_header;
  for (auto &c : cookies_) {
    if (c.second.Value() != "" && c.second.Path() == path) {
      cookie_header.append(c.second.Name() + "=");
      cookie_header.append(c.second.Value() + "; ");
    }
  }
  return cookie_header.substr(0, cookie_header.size() - 2);
}

std::string HttpSession::ShowCookies() const {
  std::string s;
  for (auto c : cookies_) {
    s += c.second.ToString() + "\n";
  }
  return s;
}

void HttpSession::InitCurlOpt(std::string &url, std::string data,
                              HRM method) const {
  CURLcode res_code;
  // 设置请求选项
  if ((res_code = curl_easy_setopt(curl_, CURLOPT_URL, url.c_str())) !=
      CURLE_OK) {
    exit(1);
  }

  if ((res_code = curl_easy_setopt(curl_, CURLOPT_ACCEPT_ENCODING,
                                   "gzip, deflate, br")) != CURLE_OK) {
    exit(1);
  }
  if ((res_code = curl_easy_setopt(curl_, CURLOPT_VERBOSE, 1)) != CURLE_OK) {
    exit(1);
  }
  if ((res_code = curl_easy_setopt(curl_, CURLOPT_TCP_KEEPALIVE, 1L)) !=
      CURLE_OK) {
    exit(1);
  }
  // 设置请求头
  struct curl_slist *chunk = NULL;
  for (auto &header : req_headers_) {
    chunk = curl_slist_append(
        chunk, std::string(header.first + ": " + header.second).c_str());
  }
  if ((res_code = curl_easy_setopt(curl_, CURLOPT_HTTPHEADER, chunk)) !=
      CURLE_OK) {
    exit(1);
  }

  // 请求方法
  if (method == HRM::POST) {
    // POST请求选项
    if ((res_code = curl_easy_setopt(curl_, CURLOPT_POST, 1L)) != CURLE_OK) {
      exit(1);
    }
    if ((res_code = curl_easy_setopt(curl_, CURLOPT_POSTFIELDS,
                                     data.c_str())) != CURLE_OK) {
      exit(1);
    }
    if ((res_code = curl_easy_setopt(curl_, CURLOPT_POSTFIELDSIZE,
                                     data.size())) != CURLE_OK) {
      exit(1);
    }
  }
}

size_t write_callback(char *buffer, size_t size, size_t nmemb,
                      void *user_data) {
  return ((HttpSession *)user_data)->ProcessBody(buffer, size, nmemb);
}

size_t header_callback(char *buffer, size_t size, size_t nitems,
                       void *user_data) {
  return ((HttpSession *)user_data)->ProcessHeaders(buffer, size, nitems);
}

}  // namespace webqqapi
