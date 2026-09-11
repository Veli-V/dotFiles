#!/bin/zsh

PIDFILE="/tmp/autoclick.pid"

if [[ -f "$PIDFILE" ]]; then
    kill "$(cat "$PIDFILE")" 2>/dev/null
    rm "$PIDFILE"
    osascript -e 'display notification "AutoClick OFF" with title "Clicker"'
    exit
fi

(
while true; do
    cliclick c:.
    sleep 0.50      # muuta tähän väli sekunteina
done
) &

echo $! > "$PIDFILE"

osascript -e 'display notification "AutoClick ON" with title "Clicker"'
