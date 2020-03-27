#!/bin/bash
/usr/lib/wine/wine /usr/lib/i386-linux-gnu/wine/fakedlls/wineboot.exe -u 2>/dev/null
exec /usr/lib/wine/wine /opt/winbox.exe
