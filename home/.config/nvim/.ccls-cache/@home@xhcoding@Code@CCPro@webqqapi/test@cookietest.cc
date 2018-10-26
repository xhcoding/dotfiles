#include <gtest/gtest.h>
#include "cookie.h"

using namespace webqqapi;
TEST(TestCookie, TestCookieParse) {
  auto cookie = Cookie::ParseCookieStr("uin=o1678039912;Path=/;Domain=qq.com;");
  EXPECT_EQ("uin", cookie.Name());
  EXPECT_EQ("o1678039912", cookie.Value());
  EXPECT_EQ("/", cookie.Path());
  EXPECT_EQ("qq.com", cookie.Domain());
  EXPECT_EQ("1969-12-31T23:59:59.000Z", cookie.Expires());
  EXPECT_EQ("", cookie.Secure());

  cookie = Cookie::ParseCookieStr("");
  EXPECT_EQ("", cookie.Name());
  EXPECT_EQ("", cookie.Value());
  EXPECT_EQ("", cookie.Path());
  EXPECT_EQ("", cookie.Domain());
  EXPECT_EQ("1969-12-31T23:59:59.000Z", cookie.Expires());
  EXPECT_EQ("", cookie.Secure());
  
  cookie = Cookie::ParseCookieStr("pt2gguin=o1678039912;Expires=Tue, 19 Jan 2038 03:14:07 GMT;Path=/;Domain=qq.com;");
  EXPECT_EQ("pt2gguin", cookie.Name());
  EXPECT_EQ("o1678039912", cookie.Value());
  EXPECT_EQ("/", cookie.Path());
  EXPECT_EQ("qq.com", cookie.Domain());
  EXPECT_EQ("Tue, 19 Jan 2038 03:14:07 GMT", cookie.Expires());
  EXPECT_EQ("", cookie.Secure());
  
  cookie = Cookie::ParseCookieStr("pt2gguin=o1678039912;Expires=Tue, 19 Jan 2038 03:14:07 GMT;Path=/;Domain=qq.com;secure");
  EXPECT_EQ("pt2gguin", cookie.Name());
  EXPECT_EQ("o1678039912", cookie.Value());
  EXPECT_EQ("/", cookie.Path());
  EXPECT_EQ("qq.com", cookie.Domain());
  EXPECT_EQ("Tue, 19 Jan 2038 03:14:07 GMT", cookie.Expires());
  EXPECT_EQ("secure", cookie.Secure());
  
  cookie = Cookie::ParseCookieStr("pt2gguin=;Expires=Tue, 19 Jan 2038 03:14:07 GMT;Path=/;Domain=qq.com;secure");
  EXPECT_EQ("pt2gguin", cookie.Name());
  EXPECT_EQ("", cookie.Value());
  EXPECT_EQ("/", cookie.Path());
  EXPECT_EQ("qq.com", cookie.Domain());
  EXPECT_EQ("Tue, 19 Jan 2038 03:14:07 GMT", cookie.Expires());
  EXPECT_EQ("secure", cookie.Secure());
  
  cookie = Cookie::ParseCookieStr("pt2gguin=;Expires=;Path=;Domain=;secure");
  EXPECT_EQ("pt2gguin", cookie.Name());
  EXPECT_EQ("", cookie.Value());
  EXPECT_EQ("", cookie.Path());
  EXPECT_EQ("", cookie.Domain());
  EXPECT_EQ("1969-12-31T23:59:59.000Z", cookie.Expires());
  EXPECT_EQ("secure", cookie.Secure());
}
