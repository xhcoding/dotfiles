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

#include <fstream>
#include "utils.h"

namespace webqqapi {
std::string Trim(std::string s, std::string c) {
  if (s.empty()) {
    return s;
  }
  s.erase(0, s.find_first_not_of(c));
  s.erase(s.find_last_not_of(c) + 1);
  return s;
}

std::vector<std::string> SplitString(const std::string &str,
                                     const std::string &delimiter) {
  // http://stackoverflow.com/a/13172514
  std::vector<std::string> strings;

  std::string::size_type pos = 0;
  std::string::size_type prev = 0;
  while ((pos = str.find(delimiter, prev)) != std::string::npos) {
    strings.push_back(str.substr(prev, pos - prev));
    prev = pos + delimiter.size();
  }
  strings.push_back(str.substr(prev));
  return strings;
}

std::vector<std::string> SplitString(const std::string &str,
                                     const std::string &delimiter, int n) {
  std::vector<std::string> strings;

  std::string::size_type pos = 0;
  std::string::size_type prev = 0;
  while (n-- > 0 && (pos = str.find(delimiter, prev)) != std::string::npos) {
    strings.push_back(str.substr(prev, pos - prev));
    prev = pos + delimiter.size();
  }
  strings.push_back(str.substr(prev));
  return strings;
}

bool FileIsExist(const std::string &filename) {
  std::ifstream fin(filename.c_str(), std::ios::in);
  if (!fin) {
    return false;
  } else {
    fin.close();
    return true;
  }
}

int WriteToFile(const std::string &content, const std::string &filename,
                int mode) {
  if (FileIsExist(filename) && !mode) {
    return -1;
  }
  std::ofstream fout;
  if (mode == 1) {
    fout.open(filename.c_str(), std::ios::out);
  } else if (mode == 2) {
    fout.open(filename.c_str(), std::ios::out | std::ios::app);
  }
  if (!fout) {
    return -1;
  }
  fout << content;
  return content.size();
}

}  // namespace webqqapi
