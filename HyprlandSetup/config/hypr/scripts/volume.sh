#!/usr/bin/env bash

iDIR="$HOME/.config/mako/icons"

# Get Volume (returns integer percentage)
get_volume() {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{printf "%.0f", $2 * 100}'
}

# Get Mute State (returns "true" or "false")
is_muted() {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q MUTED && echo "true" || echo "false"
}

# Get icons for volume level
get_icon() {
    local current
    current=$(get_volume)

    if [[ "$(is_muted)" == "true" || "$current" -eq 0 ]]; then
        echo "$iDIR/volume-mute.png"
    elif [[ "$current" -le 30 ]]; then
        echo "$iDIR/volume-low.png"
    elif [[ "$current" -le 60 ]]; then
        echo "$iDIR/volume-mid.png"
    else
        echo "$iDIR/volume-high.png"
    fi
}

# Notify user about volume change
notify_user() {
    notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$(get_icon)" "Volume: $(get_volume)%"
}

# Increase Volume
inc_volume() {
    wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+ && notify_user
}

# Decrease Volume
dec_volume() {
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && notify_user
}

# Toggle Mute
toggle_mute() {
    if [[ "$(is_muted)" == "true" ]]; then
        wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
        notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$(get_icon)" "Volume Switched ON"
    else
        wpctl set-mute @DEFAULT_AUDIO_SINK@ 1
        notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$iDIR/volume-mute.png" "Volume Switched OFF"
    fi
}

# --- Microphone section ---

get_mic_volume() {
    wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | awk '{printf "%.0f", $2 * 100}'
}

is_mic_muted() {
    wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q MUTED && echo "true" || echo "false"
}

get_mic_icon() {
    echo "$iDIR/microphone.png"
}

notify_mic_user() {
    notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$(get_mic_icon)" "Mic Level: $(get_mic_volume)%"
}

inc_mic_volume() {
    wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SOURCE@ 5%+ && notify_mic_user
}

dec_mic_volume() {
    wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%- && notify_mic_user
}

toggle_mic() {
    if [[ "$(is_mic_muted)" == "true" ]]; then
        wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 0
        notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$iDIR/microphone.png" "Microphone Switched ON"
    else
        wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 1
        notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$iDIR/microphone-mute.png" "Microphone Switched OFF"
    fi
}

# --- Command dispatcher ---

case "$1" in
    --get) get_volume ;;
    --inc) inc_volume ;;
    --dec) dec_volume ;;
    --toggle) toggle_mute ;;
    --toggle-mic) toggle_mic ;;
    --get-icon) get_icon ;;
    --get-mic-icon) get_mic_icon ;;
    --mic-inc) inc_mic_volume ;;
    --mic-dec) dec_mic_volume ;;
    *) get_volume ;;
esac
