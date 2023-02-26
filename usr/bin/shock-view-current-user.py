#!/usr/bin/env python3

import subprocess
import re

res = subprocess.run( [ "loginctl", "--no-legend", "list-sessions" ],
  stdout=subprocess.PIPE )

for line in res.stdout.decode("utf-8").split("\n"):
  if len(line)==0: continue
  session, uid, user, rest = re.split( r"\s+", line, maxsplit=3 )
  info = subprocess.run( [ "loginctl", "show-session", session ],
     stdout=subprocess.PIPE )
  data = {}
  for infoline in info.stdout.decode("utf-8").split("\n"):
    if len(infoline)==0: continue
    key, value = re.split( "=", infoline, maxsplit=1 )
    data[key] = value
  if data.get("Active")=="yes" and data.get("Type")=="x11":
    print( user )
