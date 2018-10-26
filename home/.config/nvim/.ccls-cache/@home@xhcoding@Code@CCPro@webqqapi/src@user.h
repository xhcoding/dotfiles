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

#ifndef WEBQQAPI_USER_H
#define WEBQQAPI_USER_H

// 用user表示登录用户
#include <map>
#include <queue>
#include <string>
#include <tuple>
#include <vector>

#include "category.h"
#include "detailinfo.h"
#include "discus.h"
#include "friend.h"
#include "group.h"
#include "message.h"
namespace webqqapi {

class User {
 public:
  User();

  void Add(Friend f);
  void Add(Category c);
  void Add(Group g);
  void Add(Discus d);
  void Add(DetailInfo detail_info);
  void Add(int type, long uin);
  void Add(Message m);

  // NOTE: 异常还是指针，这是一个问题
  Friend* GetFriend(long uin);
  Category GetCategory(int index);
  Group GetGroup(long gid);
  Discus GetDiscus(long did);
  std::pair<int, long> GetRecent(int i);

  DetailInfo& GetDetailInfo();

 private:
  // 详细信息
  DetailInfo detail_info_;
  // 好友
  std::map<long, Friend> friends_;
  // 好友的分组信息，组名能够重复
  std::map<int, Category> categories_;
  // 群
  std::map<long, Group> groups_;
  // 讨论组
  std::map<long, Discus> discus_;
  // 最近联系人
  std::vector<std::pair<int, long>> recent_list_;

  // 消息队列
  std::queue<Message> messages_;

};
}  // namespace webqqapi

#endif /* WEBQQAPI_USER_H */
