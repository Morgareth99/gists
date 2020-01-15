syntax:~ gcc -o blub x11-device-monitor.c 
/usr/bin/ld: /tmp/ccIaY4dM.o: in function `main':
x11-device-monitor.c:(.text+0x1a): undefined reference to `XOpenDisplay'
/usr/bin/ld: x11-device-monitor.c:(.text+0x5d): undefined reference to `XQueryExtension'
/usr/bin/ld: x11-device-monitor.c:(.text+0xf2): undefined reference to `XISelectEvents'
/usr/bin/ld: x11-device-monitor.c:(.text+0xfe): undefined reference to `XFlush'
/usr/bin/ld: x11-device-monitor.c:(.text+0x114): undefined reference to `XNextEvent'
/usr/bin/ld: x11-device-monitor.c:(.text+0x142): undefined reference to `XGetEventData'
collect2: error: ld returned 1 exit status
syntax:~ 

