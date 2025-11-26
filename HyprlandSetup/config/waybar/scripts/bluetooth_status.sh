#!/usr/bin/env bash

# Controlla se bluetooth è acceso
power_status=$(bluetoothctl show | grep "Powered" | awk '{print $2}')
if [[ "$power_status" != "yes" ]]; then
    echo '{"text":"󰂲","tooltip":"Bluetooth spento"}'
    exit
fi

# Ottieni lista dei dispositivi associati e connessi
paired_devices=$(bluetoothctl paired-devices | awk '{print $2}')
connected_devices=$(bluetoothctl info | grep "Device" | awk '{print $2}')

icon="󰂯"
tooltip=""

if [[ -n "$connected_devices" ]]; then
    icon="󰂱"
    tooltip="Connesso a:"
    while IFS= read -r mac; do
        alias=$(bluetoothctl info "$mac" | grep "Alias" | awk '{print substr($0, index($0,$2))}')
        battery=$(bluetoothctl info "$mac" | grep "Battery Percentage" | awk '{print $3}' | tr -d '%')
        if [[ -n "$battery" ]]; then
            tooltip+="\n• ${alias} — ${battery}% 🔋"
        else
            tooltip+="\n• ${alias}"
        fi
    done <<< "$connected_devices"
else
    tooltip="Nessun dispositivo connesso"
fi

# Aggiunge anche i dispositivi associati non connessi
if [[ -n "$paired_devices" ]]; then
    tooltip+="\n\nDispositivi associati:"
    while IFS= read -r mac; do
        alias=$(bluetoothctl info "$mac" | grep "Alias" | awk '{print substr($0, index($0,$2))}')
        connected=$(bluetoothctl info "$mac" | grep "Connected" | awk '{print $2}')
        if [[ "$connected" != "yes" ]]; then
            tooltip+="\n• ${alias}"
        fi
    done <<< "$paired_devices"
fi

# Output finale JSON per Waybar
echo "{\"text\": \"$icon\", \"tooltip\": \"$tooltip\"}"
