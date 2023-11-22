#!/bin/bash

OPTS='--info=inline --print-query --bind=ctrl-space:print-query,tab:replace-query'

exec i3-msg -q "exec --no-startup-id $(compgen -c | /home/veli-v/.fzf/bin/fzf $OPTS | tail -1)"
