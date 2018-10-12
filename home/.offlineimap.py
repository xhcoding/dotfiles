#!/usr/bin/env python

from subprocess import check_output
from re import sub

def get_pass(account):
    data = check_output("/usr/bin/pass email/" + account, shell=True).splitlines()
    data = data[0].decode('utf8').split(":")
    return {"password": data[1], "user": data[0]}

def folder_filter(name):
    return name in ['INBOX']
