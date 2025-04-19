To avoid useless power draw, I want to disable all monitor outputs except an HDMI dummy plug when I am streaming with sunshine.
I created this script which automatically turns off all attached output except the desried one, an HDMI dummy plug in my case. The current configuration is used to generate a restore script which can then used by sunshine at the end of the streaming session as an Undo Command.

This script requires zsh since I couldn't persist array content outside loops with sh or bash.

Usage:
```
kscreen-startup.sh <screen width> <screen width> <screen fps>
kscreen-startup.sh 1920 1080 60
```

It can be paired with Sunshine Do and Undo Commands and dynamically take client requested resolution:

Do Command
```
sh -c "zsh /path/to/script/kscreen-startup.sh $SUNSHINE_CLIENT_WIDTH $SUNSHINE_CLIENT_HEIGHT $SUNSHINE_CLIENT_FPS"
```

Undo Command (this will be generated on kscreen-startup.sh execution)
```
sh -c "zsh /path/to/script/kscreen-restore.sh"
```
