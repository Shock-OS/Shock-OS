versions = ["9", "X", "11"]

editions = {
    "9": ["MATE"],
    "X": ["GNOME", "MATE"],
    "11": ["GNOME", "KDE", "MATE"]
}

arches = {
    "9": ["32-bit"],
    "X": ["64-bit", "32-bit"],
    "11": ["64-bit", "32-bit"]
}

img_urls = {
    ("9","MATE","32-bit"): "https://sourceforge.net/projects/shock-os-download-mirror/files/Stable/9.0%20Issac/ShockOS9Issac32-bit.img.xz/download"
}

sig_urls = {
    ("9", "MATE", "32-bit"): "
