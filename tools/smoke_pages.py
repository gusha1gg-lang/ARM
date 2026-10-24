"""Дым-тест: все страницы сайта из меню отвечают 200 после входа.

Запуск (при работающем сервере):  python tools/smoke_pages.py
"""
from __future__ import annotations

import http.cookiejar
import re
import sys
import urllib.error
import urllib.parse
import urllib.request

BASE = "http://127.0.0.1:5000"
CSRF_RE = re.compile(r'name="_csrf" value="([^"]+)"')

PAGES = [
    "/main.aspx",
    "/IpaddrTBD.aspx",
    "/Addipt4.aspx",
    "/EditTBD.aspx",
    "/Otchet.aspx",
    "/IpaddrT5.aspx",
    "/Addipt5.aspx",
    "/Editipt5.aspx",
    "/IPaddrUch.aspx",
    "/Addipuch.aspx",
    "/EditUch.aspx",
    "/IPaddrALL.aspx",
    "/AddipALL.aspx",
    "/EditALL.aspx",
    "/VideoIP.aspx?VideoType=IP",
    "/VideoIP.aspx?VideoType=Analog",
    "/VideoAnalog.aspx",
    "/telefon.aspx",
    "/telefon.aspx?sort=fio&dir=asc",
    "/CISCO.aspx",
    "/CISCO2.aspx",
    "/admin/users/",
]


class NoRedirect(urllib.request.HTTPRedirectHandler):
    def redirect_request(self, req, fp, code, msg, headers, newurl):
        return None


def opener():
    return urllib.request.build_opener(
        urllib.request.HTTPCookieProcessor(http.cookiejar.CookieJar()), NoRedirect()
    )


def fetch(op, path, data=None):
    body = urllib.parse.urlencode(data).encode() if data is not None else None
    req = urllib.request.Request(BASE + path, data=body)
    try:
        with op.open(req) as resp:
            return resp.status, resp.read().decode("utf-8", "replace")
    except urllib.error.HTTPError as exc:
        return exc.code, exc.read().decode("utf-8", "replace")


def main() -> int:
    op = opener()
    status, html = fetch(op, "/Login.aspx")
    token = CSRF_RE.search(html)
    status, _ = fetch(op, "/Login.aspx",
                      {"_csrf": token.group(1) if token else "",
                       "Login": "admin", "Pass": "11111111"})
    if status not in (301, 302):
        print(f"FAIL вход admin: status={status}")
        return 1

    failed = 0
    for path in PAGES:
        status, html = fetch(op, path)
        ok = status == 200 and "Traceback" not in html and "Внутренняя ошибка" not in html
        if not ok:
            failed += 1
        print(f"{'OK  ' if ok else 'FAIL'} {status} {path} ({len(html)} символов)")

    print()
    print(f"ИТОГО: {len(PAGES) - failed}/{len(PAGES)} страниц открываются")
    return 0 if not failed else 1


if __name__ == "__main__":
    sys.exit(main())
