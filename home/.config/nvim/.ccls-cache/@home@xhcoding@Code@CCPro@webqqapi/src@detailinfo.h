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

#ifndef WEBQQAPI_DETAILINFO_H
#define WEBQQAPI_DETAILINFO_H
#include <string>

namespace webqqapi {

class DetailInfo {
 public:
  DetailInfo();
  DetailInfo(long account, long uin, std::string nick, int allow, int year,
             int month, int day, int blood, std::string city,
             std::string college, int constel, std::string country,
             std::string email, int face, std::string gender,
             std::string homepage, std::string lnick, std::string mobile,
             std::string occupation, std::string personal, std::string phone,
             std::string province, int shengxiao, int vipinfo);

  int Year();
  int Month();
  std::string LNick() const {return lnick_;} 

 private:
  // QQ号
  long account_;
  // 用户uin
  long uin_;
  // 昵称
  std::string nick_;
  // 意义不明
  int allow_;
  // 生日
  int year_;
  int month_;
  int day_;
  // 血型
  int blood_;
  // 城市
  std::string city_;
  // 学校
  std::string college_;
  // 星座
  int constel_;
  // 国家
  std::string country_;
  // 邮箱
  std::string email_;
  // 头像
  int face_;
  // 性别
  std::string gender_;
  // 主页
  std::string homepage_;
  // 个性签名
  std::string lnick_;
  // 电话
  std::string mobile_;
  // 职业
  std::string occupation_;
  // 个人说明
  std::string personal_;
  // 手机
  std::string phone_;
  // 省份
  std::string province_;
  // 生肖
  int shengxiao_;
  // vip信息
  int vip_info_;
};

}  // namespace webqqapi

#endif /* WEBQQAPI_DETAILINFO_H */
