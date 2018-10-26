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

#ifndef WEBQQAPI_CLIENT_H
#define WEBQQAPI_CLIENT_H

#include <rapidjson/document.h>
#include <rapidjson/stringbuffer.h>
#include <rapidjson/writer.h>
#include <unistd.h>
#include <ctime>
#include <string>
#include "request.h"
#include "user.h"
#include "utils.h"

namespace webqqapi {

// 其他常量
const long CLIENT_ID = 53999199;

// URL常量
const std::string WEBQQ_MAIN_URL = "https://web2.qq.com/";
const std::string STATIC_CGI_URL = "https://s.web2.qq.com/";
const std::string DYNAMIC_CGI_URL = "https://d1.web2.qq.com/";
const std::string FILE_SERVER = "https://file1.web.qq.com/";

// CGI常量
const std::string LOGIN_CGI = DYNAMIC_CGI_URL + "channel/login2";
const std::string SEND_POLL_CGI = DYNAMIC_CGI_URL + "channel/poll2";
const std::string GET_VFWEBQQ_CGI = STATIC_CGI_URL + "api/getvfwebqq";
const std::string REFUSE_FILE_CGI = DYNAMIC_CGI_URL + "channel/refuse_file2";
const std::string REFUSE_OFFLINE_FILE_CGI =
    DYNAMIC_CGI_URL + "channel/notify_offfile2";
const std::string GET_USER_FRIENDS_CGI =
    STATIC_CGI_URL + "api/get_user_friends2";
const std::string GET_GROUP_CGI =
    STATIC_CGI_URL + "api/get_group_name_list_mask2";
const std::string GET_DISCUSS_CGI = STATIC_CGI_URL + "api/get_discus_list";
const std::string GET_RECENT_LIST_CGI =
    DYNAMIC_CGI_URL + "channel/get_recent_list2";
const std::string GET_SIGNATURE = STATIC_CGI_URL + "api/get_single_long_nick2";
const std::string GET_SELF_INFO = STATIC_CGI_URL + "api/get_self_info2";
const std::string GROUP_INFO_CGI_LIST =
    STATIC_CGI_URL + "api/get_group_info_ext2";
const std::string DISCUSS_INFO_CGI_LIST =
    DYNAMIC_CGI_URL + "channel/get_discu_info";
const std::string GET_FRIEND_INFO_CGI = STATIC_CGI_URL + "api/get_friend_info2";
const std::string GET_ONLINE_BUDDIES =
    DYNAMIC_CGI_URL + "channel/get_online_buddies2";
const std::string SEND_CHANGE_ONLINE_STATE =
    DYNAMIC_CGI_URL + "channel/change_status2";

class Client {
 public:
  Client();
  // 二维码登录
  Client &QrLogin();
  // 得到好友的信息
  Client &GetFriends();
  // 得到群信息
  Client &GetGroupNames();
  // 得到讨论组
  Client &GetDiscusNames();
  // 得到用户的信息
  Client &GetSelfInfo();
  // 得到用户头像, 并保存在文件中，群头像类型为4, size为大小,40 * 40 或100 * 100
  Client &GetAvatar(long uin, std::string filename, int type = 1,
                    int size = 40);
  // 得到在线好友
  Client &GetOnlineBuddy();
  // 获取最近联系人
  Client &GetRecentList();

  // 得到有个好友的个性签名
  std::string GetLongNick(long uin);
  // 得到一个好友的详细消息
  DetailInfo GetFriendInfo(long uin);

  // 发送poll请求
  Client &SendPoll();

  User &GetUser() { return user_; }

 private:
  std::string Hash33(std::string type);
  std::string Hash2(long uin, std::string ptvfwebqq);
  std::string Byte2Hex(std::vector<long> bytes);
  Client &JsonObject(std::string &object, const std::string &name,
                     const std::string &value);
  Client &JsonObject(std::string &object, const std::string &name,
                     const int &value);
  std::string Time();
  //==========登录逻辑====================
  // 根据类型构造请求url
  std::string GetSubmitUrl(std::string type);
  // 检查二维码是否被扫描
  std::string CheckQrCode();
  // 扫描二维码后，得到token和key,均在cookie中
  void CheckSig();
  // 得到vfwebqq
  void GetVfwebqq();
  // 得到psessionid
  void GetPsessionid();
  //====================================

  HttpSession session_;
  std::string check_sig_;
  // 鉴权参数
  long uin_;
  std::string ptwebqq_;
  std::string vfwebqq_;
  std::string psessionid_;

  // poll请求失败次数
  int poll_failed_;
  // 用户信息
  User user_;
};

}  // namespace webqqapi
#endif /* WEBQQAPI_CLIENT_H */
