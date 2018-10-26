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

#ifndef WEBQQAPI_CATEGORY_H
#define WEBQQAPI_CATEGORY_H
#include <string>
namespace webqqapi {
class Category {
 public:
  Category() : index_(-1) {}

  Category(int index, int sort, std::string name)
      : index_(index), sort_(sort), name_(name) {}

  int Index() const { return index_; }

  int Sort() const { return sort_; }

  std::string Name() const { return name_; }

 private:
  // 序号
  int index_;
  // 排序号
  int sort_;
  // 分组名
  std::string name_;
};
}  // namespace webqqapi

#endif /* WEBQQAPI_CATEGORY_H */
