#!/usr/bin/env bash

polybar-msg cmd quit

for monitor in $(polybar --list-monitors | cut --delimiter=":" --fields=1); do
  MONITOR=$monitor polybar --reload mybar & disown
done
