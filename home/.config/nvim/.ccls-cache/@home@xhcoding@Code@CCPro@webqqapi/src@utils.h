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

#ifndef WEBQQAPI_UTILS_H
#define WEBQQAPI_UTILS_H
#include <string>
#include <vector>

namespace webqqapi {

std::string Trim(std::string s, std::string c);

std::vector<std::string> SplitString(const std::string &str,
                                     const std::string &delimiter);

std::vector<std::string> SplitString(const std::string &str,
                                     const std::string &delimiter, int n);

// 判断文件是否存在
bool FileIsExist(const std::string &filename);

// 把内容写入文件，返回写入成功的大小，写入失败返回-1
// mode = 0，文件存在时写入失败
// mode = 1, 文件存在时删除文件内容再写入文件
// mode = 2, 文件存在时添加到文件
int WriteToFile(const std::string& content, const std::string& filename, int mode = 0);

}  // namespace webqqapi
#endif /* WEBQQAPI_UTILS_H */
