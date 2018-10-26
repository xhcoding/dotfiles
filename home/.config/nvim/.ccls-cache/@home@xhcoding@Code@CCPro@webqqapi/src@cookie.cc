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

#include "cookie.h"
#include "utils.h"

namespace webqqapi {

Cookie Cookie::ParseCookieStr(const std::string &cookie) {
  if (cookie.empty()) {
    return Cookie();
  }

  std::string name, value, domain, expires, path, secure;
  auto v1 = SplitString(cookie, ";");
  // 第一个是name=value
  auto v2 = SplitString(v1[0], "=");
  name = v2[0], value = v2[1];
  for (int i = 1; i < v1.size(); i++) {
    if (v1[i].empty()) {
      continue;
    }
    v2 = SplitString(v1[i], "=", 1);
    if (v2.size() == 2) {
      if (v2[0] == "Domain") {
        domain = v2[1];
      } else if (v2[0] == "Expires") {
        expires = v2[1];
      } else if (v2[0] == "Path") {
        path = v2[1];
      }
    } else {
      secure = v2[0];
    }
  }
  return Cookie(name, value, domain, expires, path, secure);
}

std::string Cookie::ToString() const {
  std::string cookie;
  cookie.append(name_ + "=");
  cookie.append(value_ + ";");
  cookie.append("Domain=");
  cookie.append(domain_ + ";");
  if (!expires_.empty()) {
    cookie.append("Expires=");
    cookie.append(expires_ + ";");
  }
  cookie.append("Path=");
  cookie.append(path_ + ";");
  cookie.append(secure_);
  return cookie;
}

}  // namespace webqqapi
