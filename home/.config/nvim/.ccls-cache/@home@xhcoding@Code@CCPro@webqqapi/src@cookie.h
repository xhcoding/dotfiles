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

#ifndef WEBQQAPI_REQUEST_COOKIE_H
#define WEBQQAPI_REQUEST_COOKIE_H

#include <string>

namespace webqqapi {

class Cookie {
 public:
  Cookie() : Cookie("", "", "", "", "", ""){};

  Cookie(std::string name, std::string value, std::string domain,
         std::string expires, std::string path, std::string secure)
      : name_(name),
        value_(value),
        domain_(domain),
        path_(path),
        secure_(secure) {
    if (expires.empty()) {
      expires_ = "1969-12-31T23:59:59.000Z";
    } else {
      expires_ = expires;
    }
  }

  // 解析Set-Cookie头
  static Cookie ParseCookieStr(const std::string &cookie);

  // 转换成Set-Cookie头的值
  std::string ToString() const;

  std::string Name() const { return name_; }

  std::string Value() const { return value_; }

  std::string Domain() const { return domain_; }

  std::string Expires() const { return expires_; }

  std::string Path() const { return path_; }

  std::string Secure() const { return secure_; }

 private:
  // cookie名称
  std::string name_;
  // cookie值
  std::string value_;
  // cookie 域
  std::string domain_;
  // 过期时间
  std::string expires_;
  // 路径
  std::string path_;
  // 安全标识
  std::string secure_;
};

}  // namespace webqqapi

#endif /* WEBQQAPI_REQUEST_COOKIE_H */
