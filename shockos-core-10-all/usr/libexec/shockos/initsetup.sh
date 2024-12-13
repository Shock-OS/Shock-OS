#!/bin/bash

if [[ "$(cat /usr/share/shockos/initsetup/setupvalue)" != "0" ]]
then
    echo "Your system has already been set up."
    exit
fi

IFS=$'\n'

source /usr/lib/shockos/dist-info.sh
setup_todo_list=(choose_language \
                    choose_dialect \
                    apply_locale_settings \
                    choose_kb_model_and_layout \
                    apply_keyboard_settings \
                    choose_timezone \
                    apply_timezone_settings \
                    create_user \
                    choose_hostname \
                    apply_user_settings)
username=""
full_name=""

if [[ "$SHOCKOS_DE_EDITION" == "MATE" ]]
then
    #if [[ ! -f /home/shockos/.config/gtk-3.0/settings.ini ]]
    #then
        #mkdir -p /home/shockos/.config/gtk-3.0
        #echo "[Settings]
#gtk-theme-name=Yaru-purple-dark
#gtk-icon-theme-name=Yaru-purple-dark
#gtk-font-name=Ubuntu 11" | tee /home/shockos/.config/gtk-3.0/settings.ini
    #fi
    if [[ "$(cat /proc/device-tree/model)" == "Raspberry Pi 4"* ]]
    then
        gsettings set org.mate.session.required-components windowmanager "marco-glx"
    fi
    #gsettings set org.mate.interface enable-animations "false"
    #gsettings set org.mate.peripherals-mouse cursor-theme "Yaru"
    #gsettings set org.mate.Marco.general button-layout ":minimize,maximize,close"
    #gsettings set org.mate.Marco.general theme "Yaru-dark"
    #gsettings set org.mate.Marco.general center-new-windows "true"
    #gsettings set org.mate.interface monospace-font-name "Monospace 13"
    #gsettings set org.mate.Marco.general titlebar-font "Ubuntu Bold 11"
    feh --bg-fill /usr/share/shockos/initsetup/bg.png
else #if GNOME Edition
    gsettings set org.gnome.mutter center-new-windows "true"
    gsettings set org.gnome.desktop.interface gtk-theme "Yaru-purple-dark"
    gsettings set org.gnome.desktop.interface icon-theme "Yaru-purple-dark"
    gsettings set org.gnome.desktop.interface cursor-theme "Yaru"
    #THE DEFAULT FONT PATCH BEGINS
    gsettings set org.gnome.desktop.interface font-name "Ubuntu 11"
    gsettings set org.gnome.desktop.interface document-font-name "Ubuntu 11"
    gsettings set org.gnome.desktop.interface monospace-font-name "Monospace 13"
    gsettings set org.gnome.desktop.wm.preferences titlebar-font "Ubuntu Bold 11"
    #THE DEFAULT FONT PATCH ENDS
    gnome-extensions enable no-overview@fthx
    gsettings set org.gnome.desktop.notifications show-banners "false"
    gsettings set org.gnome.mutter overlay-key ""
    gsettings set org.gnome.desktop.background picture-uri "file:///usr/share/shockos/initsetup/bg.png"
    dconf write /org/gnome/shell/extensions/hidetopbar/enable-intellihide "false" #Using DConf because extension does not support GSettings
    gnome-extensions enable hidetopbar@mathieu.bidon.ca
    gnome-shell --wayland & sleep 10
fi

/usr/libexec/shockos/set-audio-out-to-hdmi.sh
amixer -D pulse sset Master 100% #sets volume to 100% so the setup music can be heard
while true
do
    ffplay -nodisp -autoexit -loglevel panic /usr/share/shockos/initsetup/bgm.opus
done &
#LOCALE CONFIGURATION
function convert_unicode() {
    local input="$1"
    local output=""
    while [[ $input =~ (<U[0-9A-F]+>) ]]
    do
        local unicode="${BASH_REMATCH[1]}"
        local unicode_hex="${unicode:2:-1}" # Remove <U...> tags
        local unicode_char=$(printf "\\U$unicode_hex")
        output+="${input%%$unicode*}$unicode_char" # Append converted character
        input="${input#*$unicode}" # Remove processed part from input
    done
    output+="$input" # Append remaining input after processing all Unicode escape sequences
    echo "$output"
}

#PRELOADING THE LANG_ABS, LANG_NAMES, AND LANG_NAMES_UNICODE ARRAYS
lang_abs=()
for locale in /usr/share/i18n/locales/*
do
    lang_name="$(grep '^lang_name' "$locale" | sed 's/^lang_name\s*"\(.*\)"/\1/')"
    if [[ "$lang_name" =~ "<" ]]
    then
        lang_name_unicode="$(convert_unicode "$lang_name")"
    else
        lang_name_unicode="$lang_name"
    fi
    lang_ab="$(grep '^lang_ab' "$locale" | sed 's/^lang_ab\s*"\(.*\)"/\1/')"
    if [[ ! " ${lang_abs[@]} " =~ " $lang_ab " ]] && [[ "$yad_cb_languages" != "$lang_name!"* ]] && [[ ! "$yad_cb_languages" =~ "!$lang_name!" ]] && [[ -n "$lang_ab" ]] && [[ -n "$lang_name" ]]
    then
        lang_abs+=("$lang_ab")
        lang_names+=("$lang_name")
        lang_names_unicode+=("$lang_name_unicode")
    fi
done
echo "LANG_ABS: ${lang_abs[@]}" #DEBUG
#PRELOADING ENDS

yad --undecorated --center --window-icon=/usr/share/shockos/shockos-logo.svg --width=400 --title="Welcome" --picture \
    --size=fit \
    --filename=/usr/share/shockos/initsetup/welcome-logo.png \
    --text="<span font_weight='bold' font_size='larger'>Welcome to Shock OS</span>\n\nLet's get your computer set up and ready to go. Click 'Next' to get started." \
    --text-align=center \
    --buttons-layout=center \
    --button="Next"\!go-next-symbolic

function choose_language() {
current_lang_ab="$(echo "$LANG" | awk -F'_' '{print $1}')"
counter=0
yad_cb_languages=""
for lang_name_unicode in "${lang_names_unicode[@]}"
do
    if [[ "${lang_abs[counter]}" == "$current_lang_ab" ]]
    then
        yad_cb_languages+="^${lang_name_unicode}!"
    else
        yad_cb_languages+="${lang_name_unicode}!"
    fi
    counter=$((counter+1))
done
yad_cb_languages="${yad_cb_languages::-1}"
output="$(yad --undecorated --center --fixed --text="<span font_weight='bold' font_size='larger'>Choose Your Language</span>" --form \
            --field="Language:":CB "$yad_cb_languages" \
            --button="Next"\!go-next-symbolic:0)"

ex=$?
selected_lang_name_unicode=$(echo "$output" | awk -F'|' '{print $1}')
counter=0
until [[ "${lang_names_unicode[counter]}" == "$selected_lang_name_unicode" ]]
do
    counter=$((counter+1))
done
selected_lang_ab="${lang_abs[counter]}"
selected_lang_name="${lang_names[counter]}"
echo "SELECTED_LANG_NAME_UNICODE: $selected_lang_name_unicode" #DEBUG
echo "SELECTED_LANG_NAME: $selected_lang_name" #DEBUG
echo "SELECTED_LANG_AB: $selected_lang_ab" #DEBUG
}

#LANGUAGE DIALECT CONFIGURATION
function choose_dialect() {
yad_cb_languages=""
counter=0
country_names=()
country_names_unicode=()
locales=()
for locale in /usr/share/i18n/locales/*
do
    lang_ab="$(grep '^lang_ab' "$locale" | sed 's/^lang_ab\s*"\(.*\)"/\1/')"
    if [[ "$lang_ab" == "$selected_lang_ab" ]]
    then
        country_name="$(grep '^country_name' "$locale" | sed 's/^country_name\s*"\(.*\)"/\1/')"
        country_names+=("$country_name")
        country_names_unicode+=("${selected_lang_name_unicode} ($(convert_unicode "$country_name"))")
        locales+=("$(basename "$locale")")
    fi
done
current_locale="$(echo "$LANG" | awk -F'.' '{print $1}')"
for country_name_unicode in "${country_names_unicode[@]}"
do
    if [[ "${locales[counter]}" == "$current_locale" ]]
    then
        yad_cb_languages+="^${country_name_unicode}!"
    else
        yad_cb_languages+="${country_name_unicode}!"
    fi
    counter=$((counter+1))
done
yad_cb_languages="${yad_cb_languages::-1}"
output="$(yad --undecorated --center --fixed --text="<span font_weight='bold' font_size='larger'>Choose Your Dailect</span>" --form \
            --field="Dialect:":CB "$yad_cb_languages" \
            --buttons-layout=edge \
            --button="Back"\!go-previous-symbolic:1 --button="Next"\!go-next-symbolic:0)"
ex=$?
selected_country_name_unicode=$(echo "$output" | awk -F'|' '{print $1}')
echo "SELECTED_COUNTRY_NAME_UNICODE: $selected_country_name_unicode"
counter=0
until [[ "${country_names_unicode[counter]}" == "$selected_country_name_unicode" ]]
do
    counter=$((counter+1))
done
selected_country_name="${country_names[counter]}"
echo "SELECTED_COUNTRY_NAME: $selected_country_name" #DEBUG
for locale in /usr/share/i18n/locales/*
do
    lang_ab="$(grep '^lang_ab' "$locale" | sed 's/^lang_ab\s*"\(.*\)"/\1/')"
    lang_name="$(grep '^lang_name' "$locale" | sed 's/^lang_name\s*"\(.*\)"/\1/')"
    country_name="$(grep '^country_name' "$locale" | sed 's/^country_name\s*"\(.*\)"/\1/')"
    if [[ "$lang_ab" == "$selected_lang_ab" ]] && [[ "$lang_name" == "$selected_lang_name" ]] && [[ "$country_name" == "$selected_country_name" ]]
    then
        echo "$locale" #DEBUG
        selected_locale="$(basename "$locale")"
        break
    fi
done
echo "SELECTED_LOCALE: $selected_locale" #DEBUG
}

function apply_locale_settings() {
sudo sed -i '/^en_GB.UTF-8/s/^/# /' /etc/locale.gen #de-selects the en_US.UTF-8 locale that comes by default (can be re-selected if it is chosen as the locale)
sudo sed -i "/^# *${selected_locale}.UTF-8/s/^# *//" /etc/locale.gen
export LANG="${selected_locale}.UTF-8"
sudo locale-gen || yad --undecorated --center --fixed --image=emblem-important-symbolic --text="ERROR: Locale setting failed." --button="Dismiss"\!gtk-cancel-symbolic
sudo update-locale LANG="${selected_locale}.UTF-8" || yad --undecorated --center --fixed --image=emblem-important-symbolic --text="ERROR: Locale setting failed." --button="Dismiss"\!gtk-cancel-symbolic
. /etc/default/locale
}

#KEYBOARD CONFIGURATION
function choose_kb_model_and_layout() {
kb_model_ids=($(awk '/^! model/ {p=1; next} p && NF==0 {exit} p' /usr/share/X11/xkb/rules/evdev.lst | awk '{print $1}'))
kb_model_names=($(awk '/^! model/ {p=1; next} p && NF==0 {exit} p' /usr/share/X11/xkb/rules/evdev.lst | awk '{print substr($0, index($0,$2))}'))
kb_layout_ids=($(awk '/^! layout/ {p=1; next} p && NF==0 {exit} p' /usr/share/X11/xkb/rules/evdev.lst | awk '{print $1}'))
kb_layout_names=($(awk '/^! layout/ {p=1; next} p && NF==0 {exit} p' /usr/share/X11/xkb/rules/evdev.lst | awk '{print substr($0, index($0,$2))}'))
current_model_id=$(localectl status | awk -F': ' '/X11 Model/ {print $2}') #Works on X11 and Wayland
current_layout_id=$(localectl status | awk -F': ' '/X11 Layout/ {print $2}') #Works on X11 and Wayland
#current_model_id=$(setxkbmap -print | awk -F"[()]" '/xkb_geometry/ {print $2}') #OLD
#current_layout_id=$(setxkbmap -print | awk -F"+" '/xkb_symbols/ {print $2}') #OLD
selected_variant_id=""
counter=0
yad_cb_kb_model=""
for name in "${kb_model_names[@]}"
do
    if [[ "${kb_model_ids[counter]}" == "$current_model_id" ]]
    then
        yad_cb_kb_model+="^${name}!"
    else
        yad_cb_kb_model+="${name}!"
    fi
    counter=$((counter+1))
done
yad_cb_kb_model="${yad_cb_kb_model::-1}"
counter=0
yad_cb_kb_layout=""
for name in "${kb_layout_names[@]}"
do
    if [[ "${kb_layout_ids[counter]}" == "$current_layout_id" ]]
    then
        yad_cb_kb_layout+="^${name}!"
    else
        yad_cb_kb_layout+="${name}!"
    fi
    counter=$((counter+1))
done
yad_cb_kb_layout="${yad_cb_kb_layout::-1}"
output="$(yad --undecorated --center --fixed --text="<span font_weight='bold' font_size='larger'>Configure Keyboard</span>" --form \
            --always-print-result \
            --field="Model:":CB "$yad_cb_kb_model" \
            --field="Layout:":CB "$yad_cb_kb_layout" \
            --buttons-layout=edge \
            --button="Back"\!go-previous-symbolic:1 --button="Choose Model Variant":2 --button="Next"\!go-next-symbolic:0)"
ex=$?
selected_model_name=$(echo "$output" | awk -F'|' '{print $1}')
selected_layout_name=$(echo "$output" | awk -F'|' '{print $2}')
counter=0
until [[ "${kb_model_names[counter]}" == "$selected_model_name" ]]
do
    counter=$((counter+1))
done
selected_model_id="${kb_model_ids[counter]}"
counter=0
until [[ "${kb_layout_names[counter]}" == "$selected_layout_name" ]]
do
    counter=$((counter+1))
done
selected_layout_id="${kb_layout_ids[counter]}"
if [[ "$ex" == "2" ]]
then
    choose_kb_variant
fi
echo "SELECTED_MODEL_ID: $selected_model_id" #DEBUG
echo "SELECTED_LAYOUT_ID: $selected_layout_id" #DEBUG
}

function choose_kb_variant() {
kb_variant_ids=($(awk -v selected_layout_id="$selected_layout_id" '/^! variant/ {p=1; next} p && NF==0 {exit} p' /usr/share/X11/xkb/rules/evdev.lst | awk -v selected_layout_id="$selected_layout_id" '$2 == selected_layout_id ":" {print $1}'))
kb_variant_names=($(awk -v selected_layout_id="$selected_layout_id" '/^! variant/ {p=1; next} p && NF==0 {exit} p' /usr/share/X11/xkb/rules/evdev.lst | awk -v selected_layout_id="$selected_layout_id" '$2 == selected_layout_id ":" { for (i=3; i<=NF; i++) printf "%s%s", $i, (i==NF ? "\n" : OFS) }'))
yad_cb_kb_variant=""
for name in "${kb_variant_names[@]}"
do
    yad_cb_kb_variant+="${name}!"
done
yad_cb_kb_variant="${yad_cb_kb_variant::-1}"
output=$(yad --undecorated --center --fixed --text="<span font_weight='bold' font_size='larger'>Choose Keyboard Variant</span>" --form \
            --always-print-result \
            --field="Variant:":CB "$yad_cb_kb_variant" \
            --buttons-layout=edge \
            --button="Cancel"\!gtk-cancel-symbolic:2 --button="Next"\!go-next-symbolic:0)
ex=$?
if [[ "$ex" == "0" ]]
then
    selected_variant_name=$(echo "$output" | awk -F'|' '{print $1}')
    counter=0
    until [[ "${kb_variant_names[counter]}" == "$selected_variant_name" ]]
    do
        counter=$((counter+1))
    done
    selected_variant_id="${kb_variant_ids[counter]}"
else
    selected_variant_id=""
fi
}

function apply_keyboard_settings() {
sudo sed -i "s/^XKBMODEL=.*/XKBMODEL=\"${selected_model_id}\"/" /etc/default/keyboard
sudo sed -i "s/^XKBLAYOUT=.*/XKBLAYOUT=\"${selected_layout_id}\"/" /etc/default/keyboard
sudo sed -i "s/^XKBVARIANT=.*/XKBVARIANT=\"${selected_variant_id}\"/" /etc/default/keyboard
if [[ -n "$selected_variant_id" ]]
then
    setxkbmap -model "$selected_model_id" -layout "$selected_layout_id" -variant "$selected_variant_id"
    gsettings set org.gnome.desktop.input-sources sources "[('xkb', '${selected_layout_id}'), ('xkb', '${selected_model_id}'), ('xkb', '${selected_variant_id}')]" #GNOME ON WAYLAND
else
    setxkbmap -model "$selected_model_id" -layout "$selected_layout_id"
    gsettings set org.gnome.desktop.input-sources sources "[('xkb', '${selected_layout_id}'), ('xkb', '${selected_model_id}')]" #GNOME ON WAYLAND
fi
}

#TIMEZONE CONFIGURATION
function choose_timezone() {
timezone_folders=("Africa" "America" "Antarctica" "Arctic Ocean" "Asia" "Atlantic Ocean" "Australia" "Brazil" "Canada" "Chile" "Cuba" "Egypt" "Eire" "Europe" "GB" "GB-Eire" "Greenwich" "Hongkong" "Iceland" "Indian Ocean" "Iran" "Israel" "Jamaica" "Japan" "Kwajalein" "Libya" "Mexico" "Navajo" "NZ" "NZ-CHAT" "Pacific Ocean" "Poland" "Portugal" "Singapore" "Turkey" "US" "W-SU" "Zulu" "None of the above")
cd /usr/share/zoneinfo
selected_timezone_folder=""
until [[ -f "$selected_timezone_folder" ]] #go until chosen locale is a FILE, not a directory containing more locales
do
    echo "CWD: $(pwd)" #DEBUG
    current_timezone_folder="$(readlink /etc/localtime)"
    current_timezone_folder="${current_timezone_folder//$(pwd)}"
    current_timezone_folder="$(echo "$current_timezone_folder" | cut -d'/' -f2)"
    current_timezone_folder="${current_timezone_folder//_/ }"
    echo "CURRENT_TIMEZONE_FOLDER: $current_timezone_folder" #DEBUG
    yad_cb_timezone_folders=""
    if [[ "$selected_timezone_folder" == "None of the above" ]]
    then
        for timezone_folder in /usr/share/zoneinfo/*
        do
            timezone_folder="$(basename "$timezone_folder")"
            timezone_folder="${timezone_folder//_/ }" #replaces underscores with spaces to make locale names look nicer
            if [[ ! " ${timezone_folders[@]} " =~ " $timezone_folder " ]]
            then
                if [[ "$timezone_folder" == "$current_timezone_folder" ]]
                then
                    yad_cb_timezone_folders+="^${timezone_folder}!"
                else
                    yad_cb_timezone_folders+="${timezone_folder}!"
                fi
            fi
        done
    elif [[ "$(pwd)" == "/usr/share/zoneinfo" ]]
    then
        for timezone_folder in "${timezone_folders[@]}"
        do
            timezone_folder="${timezone_folder//_/ }" #replaces underscores with spaces to make locale names look nicer
            if [[ "$timezone_folder" == "$current_timezone_folder" ]] || [[ "$timezone_folder" == "None of the above" && ! " ${timezone_folders[@]} " =~ " $current_timezone_folder " ]] 
            then
                yad_cb_timezone_folders+="^${timezone_folder}!"
            else
                yad_cb_timezone_folders+="${timezone_folder}!"
            fi
        done
    else
        for timezone_folder in *
        do
            timezone_folder="${timezone_folder//_/ }" #replaces underscores with spaces to make locale names look nicer
            if [[ "$timezone_folder" == "$current_timezone_folder" ]]
            then
                yad_cb_timezone_folders+="^${timezone_folder}!"
            else
                yad_cb_timezone_folders+="${timezone_folder}!"
            fi
        done
    fi
    yad_cb_timezone_folders="${yad_cb_timezone_folders::-1}"
    output="$(yad --undecorated --center --fixed --text="<span font_weight='bold' font_size='larger'>Choose Timezone</span>" --form \
                --field="Timezone:":CB "$yad_cb_timezone_folders" \
                --buttons-layout=edge \
                --button="Back"\!go-previous-symbolic:1 --button="Next"\!go-next-symbolic:0)"
    ex=$?
    if [[ "$ex" == "1" ]]
    then
        if [[ "$selected_timezone_folder" != "None of the above" ]]
        then
            cd ..
        fi
        selected_timezone_folder=""
        if [[ "$(pwd)" == "/usr/share" ]]
        then
            break
        fi
    else
        selected_timezone_folder=$(echo "$output" | awk -F'|' '{print $1}')
        if [[ "$selected_timezone_folder" != "None of the above" ]]
        then
            if [[ "$selected_timezone_folder" == *" Ocean" ]] #Removes ' Ocean' pretty name if present
            then
                selected_timezone_folder="${selected_timezone_folder::-6}"
            fi
            selected_timezone_folder="${selected_timezone_folder// /_}" #puts the underscores back
            if [[ -d "$selected_timezone_folder" ]]
            then
                cd "$selected_timezone_folder"
            fi
        fi
    fi
    echo "SELECTED_TIMEZONE_FOLDER: $selected_timezone_folder" #DEBUG
done
selected_timezone_folder="$(pwd)/$selected_timezone_folder"
selected_timezone_folder="${selected_timezone_folder:20}"
echo "SELECTED_TIMEZONE_FOLDER: $selected_timezone_folder" #DEBUG
}

function apply_timezone_settings() {
sudo timedatectl set-timezone "$selected_timezone_folder"
echo "$selected_timezone_folder" | sudo tee /etc/timezone
}

#USER CREATION
function create_user() {
ex="0"
focus_field=2
require_password="TRUE"
success="FALSE"
until [[ "$success" == "TRUE" ]] || [[ "$ex" == "1" ]]
do
    output="$(yad --undecorated --center --fixed --text="<span font_weight='bold' font_size='larger'>Create a User</span>" --form \
                --focus-field="$focus_field" \
                --field="Username:":LBL '' \
                --field="" "$username" \
                --field="Full Name:":LBL '' \
                --field="" "$full_name" \
                --field="":LBL '' \
                --field="For security reasons, passwords should:
    - be at least 8 characters long
    - include upper and lower case letters
    - include numbers and symbols
    - be random, not something guessable like a birth date, anniversary, etc.
Password:":LBL '' \
                --field="":H '' \
                --field="Verify Password:":LBL '' \
                --field="":H '' \
                --field="Require my password to log in":CHK "$require_password" \
                --separator=$'\n' \
                --buttons-layout=edge \
                --button="Back"\!go-previous-symbolic:1 --button="Next"\!go-next-symbolic:0)"
    ex=$?
    if [[ "$ex" == "0" ]]
    then
        username="$(echo "$output" | awk 'NR==2')"
        full_name="$(echo "$output" | awk 'NR==4')"
        pa1="$(echo "$output" | awk 'NR==7')"
        pa2="$(echo "$output" | awk 'NR==9')"
        require_password="$(echo "$output" | awk 'NR==10')"
        success="TRUE"
        if [[ -z "$username" ]]
        then
            yad --undecorated --center --fixed --image=emblem-important-symbolic --text="Your username cannot be empty." --button="Retry"\!edit-undo-symbolic
            focus_field=2
            success="FALSE"
        elif [[ "$username" =~ " " ]]
        then
            yad --undecorated --center --fixed --image=emblem-important-symbolic --text="Your username cannot contain spaces." --button="Retry"\!edit-undo-symbolic
            focus_field=2
            success="FALSE"
        elif [[ "$username" == "shock" ]]
        then
            yad --undecorated --center --fixed --image=emblem-important-symbolic --text="Your username cannot be 'shock'." --button="Retry"\!edit-undo-symbolic
            focus_field=2
            success="FALSE"
        elif (($(expr "$username" : "^[a-z][-a-z0-9_]*\$" )==0))
        then
            yad --undecorated --center --fixed --image=emblem-important-symbolic --text="Your username does not meet the necessary requirements. Usernames must start with a lowercase letter and can only contain lowercase letters, digits, hyphens and underscores." --button="Retry"\!edit-undo-symbolic
            focus_field=2
            success="FALSE"
        elif [[ -z "$full_name" ]]
        then
            yad --undecorated --center --fixed --image=emblem-important-symbolic --text="Your full name cannot be empty." --button="Retry"\!edit-undo-symbolic
            focus_field=4
            success="FALSE"
        elif [[ "$full_name" =~ ^[[:space:]]*$ ]]
        then
            yad --undecorated --center --fixed --image=emblem-important-symbolic --text="Your full name cannot only consist of spaces." --button="Retry"\!edit-undo-symbolic
            focus_field=4
            success="FALSE"
        elif [[ -z "$pa1" ]]
        then
            yad --undecorated --center --fixed --image=emblem-important-symbolic --text="Your password cannot be empty." --button="Retry"\!edit-undo-symbolic
            focus_field=7
            success="FALSE"
        elif [[ "$pa1" =~ " " ]]
        then
            yad --undecorated --center --fixed --image=emblem-important-symbolic --text="Your password cannot contain spaces." --button="Retry"\!edit-undo-symbolic
            focus_field=7
            success="FALSE"
        elif [[ "$pa1" != "$pa2" ]]
        then
            yad --undecorated --center --fixed --image=emblem-important-symbolic --text="Oops! The passwords don't match. Please try again." --button="Retry"\!edit-undo-symbolic
            focus_field=7
            success="FALSE"
        fi
    fi
done
}

function choose_hostname() {
hostname="$(yad --undecorated --entry \
                --text="<span font_weight='bold' font_size='larger'>Name this Machine</span>\nPlease choose a name for this machine:" \
                --entry-text="$(echo "$full_name" | awk '{print $1}')'s $(cat /proc/device-tree/model | awk '{print $1,$2,$3}')" \
                --buttons-layout=edge \
                --button="Back"\!go-previous-symbolic:1 --button="Next"\!go-next-symbolic:0)"
ex=$?
if [[ "$ex" == "0" ]]
then
    sudo hostnamectl set-hostname "$hostname"
fi
}

function apply_user_settings() {
yad --progress-text="Setting up your system..." --center --progress --pulsate --auto-close --undecorated --no-buttons --skip-taskbar & killpid=$!
sudo adduser --disabled-password --gecos "$full_name" "$username" || { deluser --remove-home "$username"; yad --undecorated --center --fixed --image=emblem-important-symbolic --text="ERROR: Something went wrong while creating the user. Please try again." --button="Retry"\!edit-undo-symbolic; setup_todo_item=$((setup_todo_item-4)); return; }
echo "$username:$pa1" | sudo chpasswd || { yad --undecorated --center --fixed --image=emblem-important-symbolic --text="ERROR: Failed to set the user password." --button="Dismiss"\!gtk-cancel-symbolic; setup_todo_item=$((setup_todo_item-3)); return; }
pa1=""
pa2=""
sudo usermod -a -G adm,dialout,cdrom,sudo,audio,video,plugdev,games,users,input,render,netdev,spi,i2c,gpio "$username" || yad --undecorated --center --fixed --image=emblem-important-symbolic --text="ERROR: Failed to add the user to the required groups." --button="Dismiss"\!gtk-cancel-symbolic
echo "%$username ALL=(ALL:ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/initsetup-rootpriv #enables the user to run all commands without a password (temporarily)
if [[ "$require_password" == "FALSE" ]]
then
    if [[ "$SHOCKOS_DE_EDITION" == "GNOME" ]]
    then
        sudo sed -i "s/#  AutomaticLoginEnable = true/  AutomaticLoginEnable = true/g" /etc/gdm3/daemon.conf
        sudo sed -i "s/#  AutomaticLogin = user1/  AutomaticLogin = $username/g" /etc/gdm3/daemon.conf
    else #MATE
        echo "autologin-user=$username" | tee -a /etc/lightdm/lightdm.conf #NEEDS TO BE REDONE
        echo "autologin-user-timeout=0" | tee -a /etc/lightdm/lightdm.conf #NEEDS TO BE REDONE
    fi
fi
#the setup finalizer temporary autologin patch begins
sed -i 's/#NAutoVTs=6/NAutoVTs=1/g' /etc/systemd/logind.conf
echo "[Service]
ExecStart=
ExecStart=-/usr/sbin/agetty --autologin $username --noclear %I \$TERM" | sudo tee -a /etc/systemd/system/getty@tty1.service.d/override.conf
sudo systemctl is-enabled getty@tty1.service
sudo systemctl enable getty@tty1.service
sudo systemctl daemon-reload
echo '/usr/libexec/shockos/finsetup.sh' | sudo tee -a "/home/$username/.bashrc"
#the setup finalizer temporary autologin patch ends
kill "$killpid"
}

setup_todo_item=0
until ((setup_todo_item==10))
do
    echo "EX: $ex" #DEBUG
    echo "SETUP_TODO_ITEM: ${setup_todo_list[setup_todo_item]}" #DEBUG
    eval "${setup_todo_list[setup_todo_item]}"
    if [[ "${setup_todo_list[setup_todo_item]}" == "apply"* ]]
    then
        setup_todo_item=$((setup_todo_item+1))
    else
        if [[ "$ex" == "0" ]]
        then
            setup_todo_item=$((setup_todo_item+1))
        elif [[ "$ex" == "1" ]]
        then
            setup_todo_item=$((setup_todo_item-1))
            until [[ "${setup_todo_list[setup_todo_item]}" != "apply"* ]]
            do
                setup_todo_item=$((setup_todo_item-1))
            done
        fi
    fi
done

echo "1" | sudo tee /usr/share/shockos/initsetup/setupvalue
yad --undecorated --center --fixed --text-align=center --text="<span font_weight='bold' font_size='larger'>All Done\!</span>\n\nYour Raspberry Pi is set up and ready to go. Please reboot to begin using your system.\n" --buttons-layout=center --button="Reboot Now"\!gtk-refresh-symbolic
sudo reboot

    
