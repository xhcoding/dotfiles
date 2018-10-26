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

#include <time.h>
#include <iostream>
#include "client.h"
#include "log.h"
namespace webqqapi {

std::string Client::Hash33(std::string type) {
  int e, i, n;
  for (e = 0, i = 0, n = type.length(); i < n; ++i) {
    e += (e << 5) + type[i];
  }
  return std::to_string(e & 2147483647);
}

std::string Client::Hash2(long uin, std::string ptvfwebqq) {
  std::vector<int> ptb(4);

  for (int i = 0; i < ptvfwebqq.size(); i++) {
    int ptbIndex = i % 4;
    ptb[ptbIndex] ^= ptvfwebqq[i];
  }
  std::vector<std::string> salt = {"EC", "OK"};
  std::vector<int> uinByte(4);
  uinByte[0] = (((uin >> 24) & 0xFF) ^ salt[0][0]);
  uinByte[1] = (((uin >> 16) & 0xFF) ^ salt[0][1]);
  uinByte[2] = (((uin >> 8) & 0xFF) ^ salt[1][0]);
  uinByte[3] = ((uin & 0xFF) ^ salt[1][1]);
  std::vector<long> result(8);
  for (int i = 0; i < 8; i++) {
    if (i % 2 == 0) {
      result[i] = ptb[i >> 1];
    } else {
      result[i] = uinByte[i >> 1];
    }
  }

  return Byte2Hex(result);
}

std::string Client::Byte2Hex(std::vector<long> bytes) {
  char hex[16] = {'0', '1', '2', '3', '4', '5', '6', '7',
                  '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'};
  std::string buf;
  for (int i = 0; i < bytes.size(); i++) {
    buf += (hex[(bytes[i] >> 4) & 0xF]);
    buf += (hex[bytes[i] & 0xF]);
  }
  return buf;
}

Client &Client::JsonObject(std::string &object, const std::string &name,
                           const std::string &value) {
  rapidjson::Document d;
  if (object.empty()) {
    d.Parse("{}");
  } else {
    d.Parse(object.c_str());
  }
  rapidjson::Document::AllocatorType &allocator = d.GetAllocator();
  d.AddMember(rapidjson::StringRef(name.c_str(), name.size()),
              rapidjson::StringRef(value.c_str(), value.size()), allocator);
  rapidjson::StringBuffer buffer;
  rapidjson::Writer<rapidjson::StringBuffer> writer(buffer);
  d.Accept(writer);
  object = buffer.GetString();
  return *this;
}

Client &Client::JsonObject(std::string &object, const std::string &name,
                           const int &value) {
  rapidjson::Document d;
  if (object.empty()) {
    d.Parse("{}");
  } else {
    d.Parse(object.c_str());
  }
  rapidjson::Document::AllocatorType &allocator = d.GetAllocator();

  rapidjson::Value v(value);
  d.AddMember(rapidjson::StringRef(name.c_str(), name.size()), v, allocator);
  rapidjson::StringBuffer buffer;
  rapidjson::Writer<rapidjson::StringBuffer> writer(buffer);
  d.Accept(writer);
  object = buffer.GetString();
  return *this;
}

std::string Client::Time() { return std::to_string(time(0)); }

Client::Client() {
  // 添加默认的request header
  std::map<std::string, std::string> req_headers;
  req_headers["accept"] = "*/*";
  req_headers["accept-language"] = "zh-CN,zh;q=0.9,en;q=0.8";
  req_headers["user-agent"] =
      "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like "
      "Gecko) Chrome/69.0.3497.100 Safari/537.36";
  session_.ReqHeader(req_headers);
}

std::string Client::GetSubmitUrl(std::string type) {
  std::string url("https://ssl.ptlogin2.qq.com/");
  url.append(type + "?");
  std::map<std::string, std::string> params;
  if (type == "ptqrlogin") {
    params["u1"] = "https://web2.qq.com/proxy.html";
    params["ptqrtoken"] = Hash33(session_.Cookies("qrsig").Value());
    params["ptredirect"] = "0";
    params["h"] = "1";
    params["t"] = "1";
    params["g"] = "1";
    params["from_ui"] = "1";
    params["ptlang"] = "2052";
    params["action"] = "0-0-" + std::to_string(time(NULL));
    params["js_ver"] = "10284";
    params["js_type"] = "1";
    params["login_sig"] = "";
    params["pt_uistyle"] = "40";
    params["aid"] = "501004106";
    params["daid"] = "164";
    params["mibao_css"] = "m_webqq";
  }
  for (auto &param : params) {
    url.append(param.first + "=");
    url.append(param.second + "&");
  }
  return url;
}

std::string Client::CheckQrCode() {
  std::string url = GetSubmitUrl("ptqrlogin");

  session_.ReqHeader(
      "referer",
      "https://xui.ptlogin2.qq.com/cgi-bin/"
      "xlogin?daid=164&target=self&style=40&pt_disable_pwd=1&mibao_css=m_"
      "webqq&appid=501004106&enable_qlogin=0&no_verifyimg=1&s_url=https%3A%"
      "2F%2Fweb2.qq.com%2Fproxy.html&f_url=loginerroralert&strong_login=1&"
      "login_state=10&t=20131024001");
  session_.ReqHeader("cookie", session_.CookieHeader("/"));
  return session_.Request(url).Body();
}

void Client::CheckSig() {
  session_.ReqHeader(
      "referer",
      "http://s.web2.qq.com/proxy.html?v=20130916001&callback=1&id=1");
  session_.ReqHeader("cookie", session_.CookieHeader("/"));
  session_.Request(check_sig_);
}

void Client::GetVfwebqq() {
  std::string data = "ptwebqq=";
  data += "&clientid=" + std::to_string(CLIENT_ID);
  data += "&psessionid=";
  data += "&t=" + Time();

  session_.ReqHeader("referer",
                     "https://s.web2.qq.com/"
                     "proxy.html?v=20130916001&callback=1&id=1");
  session_.ReqHeader("cookie", session_.CookieHeader("/"));
  std::string result = session_.Request(GET_VFWEBQQ_CGI, data, GET).Body();
  rapidjson::Document d;
  d.Parse(result.c_str());
  vfwebqq_ = d["result"].GetObject().FindMember("vfwebqq")->value.GetString();
};
// TODO 请求错误处理
void Client::GetPsessionid() {
  session_.ReqHeader("referer",
                     "https://d1.web2.qq.com/"
                     "proxy.html?v=20151105001&callback=1&id=2");
  session_.ReqHeader("Content-Type", "application/x-www-form-urlencoded");
  session_.ReqHeader("origin", "https://d1.web2.qq.com");
  session_.ReqHeader("cookie", session_.CookieHeader("/"));

  std::string json;
  JsonObject(json, "ptwebqq", "")
      .JsonObject(json, "clientid", 53999199)
      .JsonObject(json, "psessionid", "")
      .JsonObject(json, "status", "online");
  std::string data = "r=" + json;
  std::string result = session_.Request(LOGIN_CGI, data, POST).Body();
  rapidjson::Document d;
  d.Parse(result.c_str());
  if (d["retcode"].GetInt() == 0) {
    auto o = d["result"].GetObject();
    psessionid_ = o.FindMember("psessionid")->value.GetString();
    uin_ = o.FindMember("uin")->value.GetInt64();
  } else {
    LOG_E("请求失败");
  }
}

Client &Client::QrLogin() {
  // 第一步，请求二维码
  session_.Request(
      "https://ssl.ptlogin2.qq.com/"
      "ptqrshow?appid=501004106&e=2&l=M&s=3&d=72&v=4&t=0.4990129482872032&"
      "daid=164&pt_3rd_aid=0");
  // 把二维码写到文件中
  WriteToFile(session_.Body(), "login_qrcode.png", 1);
  LOG_I("请扫描二维码。");
  system("feh login_qrcode.png");
  // 等待扫描二维码
  while (1) {
    std::string resp = CheckQrCode();
    auto v = SplitString(resp, ",");
    if (v[4].find("二维码已失效") != -1) {
      LOG_W("二维码已失效");
      break;
    } else if (v[4].find("登录成功") != -1) {
      LOG_D("二维码扫描完成!");
      check_sig_ = Trim(v[2], "'");
      break;
    }
    sleep(2);
  }

  LOG_D("开始CheckSig");
  CheckSig();
  LOG_D("结束CheckSig");
  LOG_D("开始获取vfwebqq");
  GetVfwebqq();
  LOG_D("vfwebqq: " + vfwebqq_);
  LOG_D("开始获取psessionid");
  GetPsessionid();
  LOG_D("psessionid: " + psessionid_);
  LOG_D("uin: " + std::to_string(uin_));
  LOG_D("登录阶段完成！");
  LOG_I("登录成功！");
  return *this;
};

Client &Client::GetFriends() {
  session_.ReqHeader("referer",
                     "https://s.web2.qq.com/"
                     "proxy.html?v=20151105001&callback=1&id=1");
  session_.ReqHeader("Content-Type", "application/x-www-form-urlencoded");
  session_.ReqHeader("origin", "https://s.web2.qq.com");
  session_.ReqHeader("cookie", session_.CookieHeader("/"));

  std::string hash = Hash2(uin_, ptwebqq_);
  std::string json;
  JsonObject(json, "vfwebqq", vfwebqq_).JsonObject(json, "hash", hash);
  std::string data = "r=" + json;

  std::string resp = session_.Request(GET_USER_FRIENDS_CGI, data, POST).Body();
  rapidjson::Document d;
  d.Parse(resp.c_str());

  if (!resp.empty() && d["retcode"].GetInt() == 0) {
    auto &result = d["result"];
    auto &categories = result["categories"];
    auto &friends = result["friends"];
    auto &infos = result["info"];
    auto &marknames = result["marknames"];
    auto &vipinfos = result["vipinfo"];

    // 解析category数组
    if (!categories.Empty()) {
      for (auto &v : categories.GetArray()) {
        auto o = v.GetObject();
        user_.Add(Category(o["index"].GetInt(), o["sort"].GetInt(),
                           o["name"].GetString()));
      }
    }

    //解析friends数组
    if (!friends.Empty()) {
      for (auto &v : friends.GetArray()) {
        auto o = v.GetObject();
        auto uin = o["uin"].GetInt64();
        user_.Add(Friend(uin));
        user_.GetFriend(uin)->Category(o["categories"].GetInt());
        user_.GetFriend(uin)->FFlag(o["flag"].GetInt());
      }
    }

    // 解析infos数组
    if (!infos.Empty()) {
      for (auto &v : infos.GetArray()) {
        auto o = v.GetObject();
        auto uin = o["uin"].GetInt64();
        user_.GetFriend(uin)->Face(o["face"].GetInt());
        user_.GetFriend(uin)->IFlag(o["flag"].GetInt());
        user_.GetFriend(uin)->Nick(o["nick"].GetString());
      }
    }

    // 解析marknames数组
    if (!marknames.Empty()) {
      for (auto &v : marknames.GetArray()) {
        auto o = v.GetObject();
        auto uin = o["uin"].GetInt64();
        user_.GetFriend(uin)->MarkName(o["markname"].GetString());
        user_.GetFriend(uin)->MarkType(o["type"].GetInt());
      }
    }
    // 解vipinfos数组
    if (!vipinfos.Empty()) {
      for (auto &v : vipinfos.GetArray()) {
        auto o = v.GetObject();
        auto uin = o["u"].GetInt64();
        user_.GetFriend(uin)->VipLevel(o["vip_level"].GetInt());
        user_.GetFriend(uin)->IsVip(o["is_vip"].GetInt());
      }
    }
  } else {
    LOG_E("请求错误");
  }
  return *this;
}

Client &Client::GetGroupNames() {
  session_.ReqHeader("referer",
                     "https://s.web2.qq.com/"
                     "proxy.html?v=20151105001&callback=1&id=1");
  session_.ReqHeader("Content-Type", "application/x-www-form-urlencoded");
  session_.ReqHeader("origin", "https://s.web2.qq.com");
  session_.ReqHeader("cookie", session_.CookieHeader("/"));

  std::string hash = Hash2(uin_, ptwebqq_);
  std::string json;
  JsonObject(json, "vfwebqq", vfwebqq_).JsonObject(json, "hash", hash);
  std::string data = "r=" + json;

  std::string resp = session_.Request(GET_GROUP_CGI, data, POST).Body();
  rapidjson::Document d;
  d.Parse(resp.c_str());
  if (!resp.empty() && d["retcode"].GetInt() == 0) {
    auto &result = d["result"];
    // TODO: 还有两个对象没解析gmarklist,gmasklist
    auto &gnamelist = result["gnamelist"];
    if (!gnamelist.Empty()) {
      for (auto &v : gnamelist.GetArray()) {
        auto o = v.GetObject();

        user_.Add(Group(o["flag"].GetInt64(), o["name"].GetString(),
                        o["gid"].GetInt64(), o["code"].GetInt64()));
      }
    }
  } else {
    LOG_E("请求错误");
  }
  return *this;
}

Client &Client::GetDiscusNames() {
  std::string data = "clientid=" + std::to_string(CLIENT_ID);
  data += "&psessionid=" + psessionid_;
  data += "&vfwebqq=" + vfwebqq_;
  data += "&t=" + Time();
  session_.ReqHeader("referer",
                     "https://s.web2.qq.com/"
                     "proxy.html?v=20151105001&callback=1&id=1");
  session_.ReqHeader("content-type", "utf-8");
  session_.ReqHeader("cookie", session_.CookieHeader("/"));

  std::string resp = session_.Request(GET_DISCUSS_CGI, data, GET).Body();
  rapidjson::Document d;
  d.Parse(resp.c_str());

  if (!resp.empty() && d["retcode"].GetInt() == 0) {
    auto &result = d["result"];
    auto &dnamelist = result["dnamelist"];
    if (!dnamelist.Empty()) {
      for (auto &v : dnamelist.GetArray()) {
        auto o = v.GetObject();
        user_.Add(Discus(o["name"].GetString(), o["did"].GetInt64()));
      }
    }
  } else {
    LOG_E("请求错误");
  }
  return *this;
}

Client &Client::GetSelfInfo() {
  std::string data = "t=" + Time();
  session_.ReqHeader("referer",
                     "https://s.web2.qq.com/"
                     "proxy.html?v=20151105001&callback=1&id=1");
  session_.ReqHeader("content-type", "utf-8");
  session_.ReqHeader("cookie", session_.CookieHeader("/"));
  std::string resp = session_.Request(GET_SELF_INFO, data, GET).Body();
  rapidjson::Document d;
  d.Parse(resp.c_str());
  if (!resp.empty() && d["retcode"].GetInt() == 0) {
    auto o = d["result"].GetObject();
    user_.Add(DetailInfo(
        o["account"].GetInt64(), o["uin"].GetInt64(), o["nick"].GetString(),
        o["allow"].GetInt(), o["birthday"].GetObject()["year"].GetInt(),
        o["birthday"].GetObject()["month"].GetInt(),
        o["birthday"].GetObject()["day"].GetInt(), o["blood"].GetInt(),
        o["city"].GetString(), o["college"].GetString(), o["constel"].GetInt(),
        o["country"].GetString(), o["email"].GetString(), o["face"].GetInt(),
        o["gender"].GetString(), o["homepage"].GetString(),
        o["lnick"].GetString(), o["mobile"].GetString(),
        o["occupation"].GetString(), o["personal"].GetString(),
        o["phone"].GetString(), o["province"].GetString(),
        o["shengxiao"].GetInt(), o["vip_info"].GetInt()));
    LOG_D(std::to_string(user_.GetDetailInfo().Year()));
  } else {
    LOG_E("请求错误");
  }
  return *this;
}

Client &Client::GetAvatar(long uin, std::string filename, int type, int size) {
  std::string url = "https://face" + std::to_string(uin % 10) +
                    ".web.qq.com/cgi/svr/face/getface";
  std::string data = "cache=1";
  data += "&type=" + std::to_string(type);
  data += "&f=" + std::to_string(size);
  data += "&uin=" + std::to_string(uin);
  data += "&t=" + Time();
  data += "&vfwebqq=" + vfwebqq_;
  session_.ReqHeader("accept", "image/webp,image/apng,image/*,*/*;q=0.8");
  session_.ReqHeader("referer", "https://web2.qq.com/");
  session_.ReqHeader("cookie", session_.CookieHeader("/"));

  auto resp =
      session_.Request(url, data, GET, FOLLOW_LOCATION | DEFAULT_EXTRA_OPTIONAL)
          .Body();
  if (!resp.empty()) {
    WriteToFile(resp, filename, 1);
  } else {
    LOG_E("请求错误");
  };
  return *this;
}

Client &Client::GetOnlineBuddy() {
  std::string data = "vfwebqq=" + vfwebqq_;
  data += "&clientid=53999199";
  data += "&psessionid=" + psessionid_;
  data += "&t=" + Time();
  session_.ReqHeader(
      "referer",
      "https://d1.web2.qq.com/proxy.html?v=20151105001&callback=1&id=2");
  session_.ReqHeader("cookie", session_.CookieHeader("/"));
  auto resp = session_.Request(GET_ONLINE_BUDDIES, data, GET).Body();

  rapidjson::Document d;
  d.Parse(resp.c_str());
  if (!resp.empty() && d["retcode"].GetInt() == 0) {
    auto result = d["result"].GetArray();
    if (!result.Empty()) {
      for (auto &v : result) {
        auto o = v.GetObject();
        auto uin = o["uin"].GetInt();
        user_.GetFriend(uin)->ClientType(o["client_type"].GetInt());
        user_.GetFriend(uin)->Status(o["status"].GetString());
      }
    }
  } else {
    LOG_E("请求错误");
  }

  return *this;
}

Client &Client::GetRecentList() {
  session_.ReqHeader(
      "referer",
      "https://d1.web2.qq.com/proxy.html?v=20151105001&callback=1&id=2");
  session_.ReqHeader("Content-Type", "application/x-www-form-urlencoded");
  session_.ReqHeader("origin", "https://d1.web2.qq.com");
  session_.ReqHeader("cookie", session_.CookieHeader("/"));
  std::string json;
  JsonObject(json, "vfwebqq", vfwebqq_)
      .JsonObject(json, "clientid", 53999199)
      .JsonObject(json, "psessionid", psessionid_);
  std::string data = "r=" + json;
  std::string resp = session_.Request(GET_RECENT_LIST_CGI, data, POST).Body();

  rapidjson::Document d;
  d.Parse(resp.c_str());
  if (!resp.empty() && d["retcode"].GetInt() == 0) {
    auto result = d["result"].GetArray();
    if (!result.Empty()) {
      for (auto &v : result) {
        auto o = v.GetObject();
        user_.Add(o["type"].GetInt(), o["uin"].GetInt64());
      }
    }
  } else {
    LOG_E("请求错误");
  }

  return *this;
}

std::string Client::GetLongNick(long uin) {
  std::string data = "tuin=" + std::to_string(uin);
  data += "&vfwebqq=" + vfwebqq_;
  data += "&t=" + Time();
  session_.ReqHeader(
      "referer",
      "https://s.web2.qq.com/proxy.html?v=20130916001&callback=1&id=1");
  session_.ReqHeader("cookie", session_.CookieHeader("/"));
  auto resp = session_.Request(GET_SIGNATURE, data, GET).Body();
  rapidjson::Document d;
  d.Parse(resp.c_str());
  std::string lnick;
  if (!resp.empty() && d["retcode"].GetInt() == 0) {
    lnick = d["result"].GetArray()[0].GetObject()["lnick"].GetString();
  } else {
    LOG_E("请求错误");
  }
  return lnick;
}

DetailInfo Client::GetFriendInfo(long uin) {
  // 先请求lnick
  std::string lnick = GetLongNick(uin);

  std::string data = "tuin=" + std::to_string(uin);
  data += "&vfwebqq=" + vfwebqq_;
  data += "&clientid=53999199";
  data += "&psessionid=" + psessionid_;
  data += "&t=" + Time();

  session_.ReqHeader(
      "referer",
      "https://s.web2.qq.com/proxy.html?v=20130916001&callback=1&id=1");
  session_.ReqHeader("cookie", session_.CookieHeader("/"));
  auto resp = session_.Request(GET_FRIEND_INFO_CGI, data, GET).Body();
  rapidjson::Document d;
  d.Parse(resp.c_str());
  DetailInfo detail_info;
  if (!resp.empty() && d["retcode"].GetInt() == 0) {
    auto o = d["result"].GetObject();
    // TODO : stat没有解析
    detail_info = DetailInfo(
        o["uin"].GetInt64(), o["uin"].GetInt64(), o["nick"].GetString(),
        o["allow"].GetInt(), o["birthday"].GetObject()["year"].GetInt(),
        o["birthday"].GetObject()["month"].GetInt(),
        o["birthday"].GetObject()["day"].GetInt(), o["blood"].GetInt(),
        o["city"].GetString(), o["college"].GetString(), o["constel"].GetInt(),
        o["country"].GetString(), o["email"].GetString(), o["face"].GetInt(),
        o["gender"].GetString(), o["homepage"].GetString(), lnick,
        o["mobile"].GetString(), o["occupation"].GetString(),
        o["personal"].GetString(), o["phone"].GetString(),
        o["province"].GetString(), o["shengxiao"].GetInt(),
        o["vip_info"].GetInt());
  }
  return detail_info;
}

Client &Client::SendPoll() {
  session_.ReqHeader(
      "referer",
      "https://d1.web2.qq.com/proxy.html?v=20151105001&callback=1&id=2");
  session_.ReqHeader("Content-Type", "application/x-www-form-urlencoded");
  session_.ReqHeader("origin", "https://d1.web2.qq.com");
  session_.ReqHeader("cookie", session_.CookieHeader("/"));
  std::string json;
  JsonObject(json, "ptwebqq", "")
      .JsonObject(json, "clientid", 53999199)
      .JsonObject(json, "psessionid", "")
      .JsonObject(json, "key", "");
  std::string data = "r=" + json;
  std::string resp = session_.Request(SEND_POLL_CGI, data, POST).Body();

  rapidjson::Document d;
  d.Parse(resp.c_str());
  LOG_D(resp);
  // 暂不处理特殊情况
  if (!resp.empty() && d["retcode"].GetInt() == 0) {
    // errmsg
    auto errmsg = d.FindMember("errmsg");
    if (errmsg != d.MemberEnd()) {
      LOG_E("请求错误");
      return *this;
    }
    auto result = d["result"].GetArray();
    for (auto &v : result) {
      std::string poll_type = v["poll_type"].GetString();
      if (poll_type == "message") {
        auto value = v["value"].GetObject();
        Message m(poll_type, value["from_uin"].GetInt64(),
                  value["msg_id"].GetInt64(), value["msg_type"].GetInt(),
                  value["to_uin"].GetInt64(), value["time"].GetInt64());
        auto content = v["content"].GetArray();
        if (content.Size() > 1) {
          // 解析font
          auto font = content[0].GetArray()[1].GetObject();
          m.SetFont(font["color"].GetString(), font["name"].GetString(),
                    font["size"].GetInt(), font["style"].GetArray()[0].GetInt(),
                    font["style"].GetArray()[1].GetInt(),
                    font["style"].GetArray()[2].GetInt());
          // 解析消息内容
          for (int i = 1; i < content.Size(); i++) {
            auto &d = content[i];
            if (d.IsString()) {
              m.AddContent(i, d.GetString());
            } else if (d.IsArray()) {
              std::string other_type = d[0].GetString();
              if (other_type == "face") {
                m.AddContent(i, d[1].GetInt());
              }
            }
          }
        }
        user_.Add(m);
        std::string debug_info = user_.GetFriend(m.FromUin())->Nick() + " to " +
                                 user_.GetFriend(m.ToUin())->Nick();
        debug_info += ": " + m.GetWords(1);
        LOG_D(debug_info);
      }
    }
  }

  return *this;
}

}  // namespace webqqapi
