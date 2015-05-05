#!/bin/bash

case "$(pidof gmrun | wc -w)" in
    0)  exec gmrun &
        ;;
    1)  killall -q gmrun
        # exec gmrun &
        ;;
esac
