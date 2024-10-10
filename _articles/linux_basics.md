---
layout: article
title: Linux System Basics
---
### A time saver for vim users

Append these two lines to your `~/.vimrc` to auto-highlight whitespace errors in your editor:

```
:highlight ExtraWhitespace ctermbg=red guibg=red
:match ExtraWhitespace /\s\+$/
```

### Linux crash course and minimal distro

* We started with the [Linux Crash Course](/slides/linux_crash_course.html) slide deck.
* First, we gave the general what, where, why, and who of Linux
	* Free and open source operating system kernel and ecosystem
	* Running on many systems large and small, fast and slow, distributed and centralized
	* Many pre-packaged combinations of system components capable of running user applications are available
	* We call one of these a Linux distribution, or distro for short.
	* Some examples are Fedora, Ubuntu, Arch Linux, RHEL, Puppy, and TAILS
* Having motivated our discussion of system components, we proceeded to discuss each one briefly
	* We quickly went through the bootloader, kernel, C standard library, shared libraries, storage configuration, and filesystem hierarchy layout
	* As we were about to proceed to the demo, we didn't go into great detail
	* Take note of the availability of manpages: run `man man` and read through the description.
* After finishing the slide deck, we build a minimal Linux distribution live
	* Using a ruthlessly minimal `.config` file, we built the kernel in noticeably less time than it took to clone, even with the `--depth=1` option. Barely minutes.
	* Then, we tested this kernel with `qemu-system`, generating a kernel panic as expected
	* This is because the kernel attempts to start an initial userspace process and no such thing exists on the system
	* On many Linux systems, systemd is this first "init" process, and it is given PID `1`
	* We then created a root filesystem and a "hello world" init process
	* This native assembly simply prints hello world
	* Take note that the entry point is `_start` and not `main`
	* Normally this is hidden as `libc` does various init things between `_start` and the user-defined `main`
	* We used `strace` to see how our little app talks to the kernel
	* In order to pass the app binary into the kernel, we use `cpio` to create an archive usable as an initial ram disk for our system, which allows the kernel to run the app as an init process
	* This is generally referred to by the abbreviation `initrd`. 
	* `initrd` is an area of RAM that provides a storage device interface to the rest of the kernel.
* Since there were no questions, we attempted to make our minimal Linux distro interactive
	* We implemented a parameter allowing a user to specify a string to print after "hello" instead of "world"
	* The feature started working right in time for the end of class

