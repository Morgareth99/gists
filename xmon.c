/* gcc -o xmon xmon.c -lX11 -lXi */

#define _GNU_SOURCE
#include <X11/Xlib.h>
#include <X11/extensions/XInput2.h>
#include <err.h>
#include <stdlib.h>

int main(void) {
	Display *d;
	int scr;
	Window rw;
	int xinput_op, foo;
	XEvent ev;
	unsigned char mask[2] = {0};
	XIEventMask ximask;

	d = XOpenDisplay(NULL);
	if (!d)
		errx(1, "cannot open display");
	if (!XQueryExtension(d, "XInputExtension", &xinput_op, &foo, &foo))
		errx(1, "no XInput extension on display");
	scr = DefaultScreen(d);
	rw = RootWindow(d, scr);
	XISetMask(mask, XI_HierarchyChanged);
	ximask.mask = mask;
	ximask.mask_len = sizeof(mask);
	ximask.deviceid = XIAllDevices;
	XISelectEvents(d, rw, &ximask, 1);
	XFlush(d);
	for (;;) {
		XIHierarchyEvent *hev;
		XNextEvent(d, &ev);
		if (ev.type != GenericEvent)
			continue;
		if (ev.xcookie.extension != xinput_op)
			continue;
		if (!XGetEventData(d, &ev.xcookie))
			continue;
		if (ev.xcookie.evtype != XI_HierarchyChanged)
			continue;
		hev = ev.xcookie.data;
		if (!(hev->flags & XIDeviceEnabled))
			continue;
		warnx("device added");
		system("/home/armin/bin/desktopinit");
	}
}


