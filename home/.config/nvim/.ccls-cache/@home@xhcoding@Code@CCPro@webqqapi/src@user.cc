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

#include "log.h"
#include "user.h"
namespace webqqapi {

User::User() {}

void User::Add(Friend f) { friends_.insert({f.Uin(), f}); }

void User::Add(Category c) { categories_.insert({c.Index(), c}); }

void User::Add(Group g) { groups_.insert({g.Gid(), g}); }

void User::Add(Discus d) { discus_.insert({d.Did(), d}); }

void User::Add(DetailInfo detail_info) { detail_info_ = detail_info; }

void User::Add(int type, long uin) {
  recent_list_.push_back(std::make_pair(type, uin));
}

void User::Add(Message m) {
  messages_.push(m);
}

Friend* User::GetFriend(long uin) {
  auto iter = friends_.find(uin);
  if (iter != friends_.end()) {
    return &iter->second;
  } else {
    return nullptr;
  }
}

Category User::GetCategory(int index) {
  auto iter = categories_.find(index);
  if (iter != categories_.end()) {
    return iter->second;
  } else {
    return {};
  }
}

Group User::GetGroup(long gid) {
  auto iter = groups_.find(gid);
  if (iter != groups_.end()) {
    return iter->second;
  } else {
    return {};
  }
}

Discus User::GetDiscus(long did) {
  auto iter = discus_.find(did);
  if (iter != discus_.end()) {
    return iter->second;
  } else {
    return {};
  }
}

std::pair<int, long> User::GetRecent(int i) { return recent_list_[i]; }

DetailInfo& User::GetDetailInfo() { return detail_info_; }
}  // namespace webqqapi
