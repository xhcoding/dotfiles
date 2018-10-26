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

#include "detailinfo.h"
namespace webqqapi {

DetailInfo::DetailInfo() {}

DetailInfo::DetailInfo(long account, long uin, std::string nick, int allow,
                       int year, int month, int day, int blood,
                       std::string city, std::string college, int constel,
                       std::string country, std::string email, int face,
                       std::string gender, std::string homepage,
                       std::string lnick, std::string mobile,
                       std::string occupation, std::string personal,
                       std::string phone, std::string province, int shengxiao,
                       int vipinfo)
    : account_(account),
      uin_(uin),
      nick_(nick),
      allow_(allow),
      year_(year),
      month_(month),
      day_(day),
      blood_(blood),
      city_(city),
      college_(college),
      constel_(constel),
      country_(country),
      email_(email),
      face_(face),
      gender_(gender),
      homepage_(homepage),
      lnick_(lnick),
      mobile_(mobile),
      occupation_(occupation),
      personal_(personal),
      phone_(phone),
      province_(province),
      shengxiao_(shengxiao),
      vip_info_(vipinfo)

{}

int DetailInfo::Year() { return year_; }
int DetailInfo::Month() { return month_; }
}  // namespace webqqapi
