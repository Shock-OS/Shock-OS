#!/usr/bin/env python3

import requests
import os
from pathlib import Path

def shocktools_download(url, dest, stream=True):
    path = Path(str(dest)).expanduser()
    if path.is_dir():
        filename = os.path.basename(url)
        dest = Path(f"{dest}/{filename}").expanduser()
    else:
        dest = path
    with requests.get(url, stream=stream) as response:
        with open(dest, "wb") as file:
            for chunk in response.iter_content(chunk_size=8192):
                file.write(chunk)
