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

#ifndef WEBQQAPI_FRIEND_H
#define WEBQQAPI_FRIEND_H

#include <string>

namespace webqqapi {

class Friend {
 public:
  // uin_=0表示一个空对象
  Friend() : uin_(0) {}

  Friend(long uin) : uin_(uin) {}

  long Uin() const { return uin_; }
  void Uin(long uin) { uin_ = uin; }

  int Category() const { return category_; }
  void Category(int category) { category_ = category; }

  int FFlag() const { return f_flag_; }
  void FFlag(int fflag) { f_flag_ = fflag; }

  int Face() const { return face_; }
  void Face(int face) { face_ = face; }

  int IFlag() const { return i_flag_; }
  void IFlag(int iflag) { i_flag_ = iflag; }

  std::string Nick() const { return nick_; }
  void Nick(std::string nick) { nick_ = nick; }

  std::string MarkName() const { return mark_name_; }
  void MarkName(std::string mark_name) { mark_name_ = mark_name; }

  int MarkType() const { return mark_type_; }
  void MarkType(int mark_type) { mark_type_ = mark_type; }

  int IsVip() const { return is_vip_; }
  void IsVip(int is_vip) { is_vip_ = is_vip; }

  int VipLevel() const { return vip_level_; }
  void VipLevel(int vip_level) { vip_level_ = vip_level; }

  int ClientType() const { return client_type_; }
  void ClientType(int client_type) { client_type_ = client_type; }

  std::string Status() const { return status_; }
  void Status(std::string status) { status_ = status; }

 private:
  // uin,唯一
  long uin_;
  // 分类id
  int category_;
  // 暂时不知道
  int f_flag_;
  // 头像id
  int face_;
  // info里的flag
  int i_flag_;
  // 昵称
  std::string nick_;
  // 备注
  std::string mark_name_;
  // 备注类型
  int mark_type_;
  // 是否是vip
  int is_vip_;
  // vip等级
  int vip_level_;
  // 在线的客户端类型
  int client_type_;
  // 状态
  std::string status_;
};
}  // namespace webqqapi
#endif /* WEBQQAPI_FRIEND_H */
