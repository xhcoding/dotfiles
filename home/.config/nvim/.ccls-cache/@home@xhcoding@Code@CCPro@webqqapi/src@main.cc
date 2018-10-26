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

#include <rapidjson/document.h>
#include <rapidjson/stringbuffer.h>
#include <rapidjson/writer.h>
#include <iostream>
#include "client.h"
#include "log.h"

using namespace std;
using namespace webqqapi;
#define WEBQQAPI_DEBUG 1
int main() {
#ifdef WEBQQAPI_DEBUG
  log::Logger::Instance()->StdoutLevel(log::Level_DEBUG);
#endif
  Client client;
  client.QrLogin().GetFriends().GetGroupNames().GetDiscusNames().GetSelfInfo();
  LOG_I("初始请求完成");
  auto &u = client.GetUser();
  int year = u.GetDetailInfo().Year();
  auto d = client.GetFriendInfo(641862963);
  LOG_D(d.LNick());
  LOG_I("开始查询消息");
  while (1) {
	  // 阻塞查询
    client.SendPoll();
  }


  //  程序结束，销毁日志
  log::Logger::Instance()->Destroy();
  return 0;
}
