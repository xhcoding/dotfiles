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

#ifndef WEBQQAPI_MESSAGE_H
#define WEBQQAPI_MESSAGE_H
#include <map>
#include <string>

namespace webqqapi {
class Message {
 public:
  Message(std::string type, long from_uin, long msg_id, int msg_type,
          long to_uin, long time)
      : type_(type),
        from_uin_(from_uin),
        msg_id_(msg_id),
        msg_type_(msg_type),
        to_uin_(to_uin),
        time_(time) {}

  void SetFont(std::string font_color, std::string font_name, int font_size,
               int style_1, int style_2, int style_3) {
    font_color_ = font_color;
    font_name_ = font_name;
    font_size_ = font_size;
    style_[0] = style_1;
    style_[1] = style_2;
    style_[2] = style_3;
  }

  void AddContent(int sort, std::string value) { words.insert({sort, value}); }

  void AddContent(int sort, int face) { faces.insert({sort, face}); }

  long FromUin() const { return from_uin_; }
  long ToUin() const { return to_uin_; }
  
  std::string GetWords(int sort) {
    return words[sort];
  }
  
 private:
  // 消息类型
  std::string type_;
  // 发送者
  long from_uin_;
  // 群code
  long group_code_;
  // 消息id
  long msg_id_;
  // 消息类型
  long msg_type_;
  // 发送者
  long send_uin_;
  // 时间
  long time_;
  // 接收者
  long to_uin_;

  // 消息内容
  // 字体
  // 字体颜色
  std::string font_color_;
  // 字体名字
  std::string font_name_;
  // 字体大小
  int font_size_;
  // 字体样式
  int style_[3];

  // 消息正文, 第一个int表示出现的次序，第二个为实际内容
  // 字符串
  std::map<int, std::string> words;
  // 表情
  std::map<int, int> faces;
};
}  // namespace webqqapi

#endif /* WEBQQAPI_MESSAGE_H */
