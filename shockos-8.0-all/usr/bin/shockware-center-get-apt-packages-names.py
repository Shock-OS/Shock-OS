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

# Define the list of preferred locales
preferred_locales = [current_locale, "en", "C"]

# Iterate over each archive file
for file_path in archive_files:
    with gzip.open(file_path, 'rt') as gz_file:
        for document in yaml.load_all(gz_file, Loader=yaml.CSafeLoader):
            if document.get("Type") == "desktop-application":
                package = document.get("Package", "")
                name_locale = document.get("Name", {})
                localized_name = None
                for locale in preferred_locales:
                    if locale in name_locale:
                        localized_name = name_locale[locale]
                        break
                if localized_name:
                    print(f'"{localized_name} [APT]"')
                    print(f'"{package}"')

