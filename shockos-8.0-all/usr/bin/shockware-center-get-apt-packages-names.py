import glob
import gzip
import yaml
import os
import fnmatch

# Define the path to the .gz archives containing AppStream YAML files
archive_files = glob.glob('/var/lib/app-info/yaml/*.yml.gz')

# Retrieve the current locale
current_locale = os.environ.get('LANG', '')
if "_" in current_locale:
    current_locale = current_locale.split("_")[0]
else:
    current_locale = current_locale.split(".")[0]

# Create the wildcard pattern for the current locale
locale_pattern = current_locale + "*"

# Define the fallback locale
fallback_locale = "C"

# Iterate over each archive file
for file_path in archive_files:
    with gzip.open(file_path, 'rt') as gz_file:
        for document in yaml.load_all(gz_file, Loader=yaml.CSafeLoader):
            if document.get("Type") == "desktop-application":
                package = document.get("Package", "")
                name_locale = document.get("Name", {})
                localized_name = None
                for locale_key in name_locale.keys():
                    if fnmatch.fnmatch(locale_key, locale_pattern):
                        localized_name = name_locale[locale_key]
                        break
                if localized_name is None:
                    localized_name = name_locale.get(fallback_locale)
                if localized_name:
                    print(f'"{localized_name} [APT]"')
                    print(f'"{package}"')

