---
theme: white
---

# Kickoff
Linux crash course

---

# What is Linux
- Free and open source operating system
  - Licensed under the GNU GPL v2.0
- The focus of this class

---

# Where is Linux
- All top performing supercomputers
- Most embedded systems
- Android phones
- Almost all of the computers powering the internet
- Not many home computers
  - Unless you count chromebooks or the steam deck
- On kernel.org, freely available

---

# Who is Linux
- Linus Torvalds
  - Created the Linux Kernel in 1991 while studying CS at the University of Helsinki as a personal project
  - Originally he supported only his own hardware.
  - "it probably never will support anything other than AT-harddisks, as that's all I have" [[0]](https://www.cs.cmu.edu/~awb/linux.history.html)
  - Also eventually created git to act as the VCS for the kernel
- Open source community project
  - Thousands of individual contributors
  - Corporate sponsors (including Red Hat)
  - The Linux Foundation

---

# Why use Linux
- Free software (free as in free speech)
  - No spying, telemetry, adware etc in most mainstream distributions
  - Can inspect and change the code as you please
- Fully customizable
  - Different choices for things like desktop environments, GUI programs, etc
- Can run on less powerful computers

---

# Modularity
- An OS made from many interchangeable components
- Kernel a (relatively) small piece
- Distribution (Distro) comes with choices for some of these pieces
  - Desktop environment
  - Package manager
  - Default Applications

---

# Distro vs Distro
- Differences in package naming conventions
  - libfoo-dev (apt) vs libfoo-devel (dnf)
- Differences in target audience
  - Servers vs desktop computers
  - Gaming vs Software development
- Differences in philosophy
  - Easy to use with sane defaults vs configure it all yourself
  - FOSS only vs access to proprietary software

---

# Exclusively Open Source
![fedora logo](images/Linux_Crash_Course/Fedora-logo.png)
[source](https://upload.wikimedia.org/wikipedia/commons/thumb/b/bd/Fedora-logo.svg/2048px-Fedora-logo.svg.png)

---

# Beginner-friendlyish
![ubuntu logo](images/Linux_Crash_Course/ubuntu_logo.png)
[source](https://www.xilinx.com/content/xilinx/en/products/design-tools/embedded-software/ubuntu/_jcr_content/root/parsysFullWidth/xilinxflexibleslab/xilinxflexibleslab-parsys/xilinxcolumns_149128/childParsys-2/xilinximage.img.png/1629757312962.png)

---

# Do anything, but by hand
![archlinux logo](images/Linux_Crash_Course/arch_linux_logo.png)
[source](data:image/png;base64,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)

---

# Open Source Software as a Service
![rhel logo](images/Linux_Crash_Course/RHEL-logo-hat.png)
[source](https://fossforce.com/wp-content/uploads/2021/10/RHEL-logo-hat.png)

---

# System Stack Overview
![system stack diagram](images/Linux_Crash_Course/system_stack_diagram.png)

---

# Bootloader
- Grub
![grub menu](images/Linux_Crash_Course/grub_menu.png)

---

# Kernel
```
$ cat /home/rms/interjection.txt
I'd just like to interject for a moment.  What you're referring to as Linux,
is in fact, GNU/Linux, or as I've recently taken to calling it, GNU plus Linux.
Linux is not an operating system unto itself, but rather another free component
of a fully functioning GNU system made useful by the GNU corelibs, shell
utilities and vital system components comprising a full OS as defined by POSIX.

Many computer users run a modified version of the GNU system every day,
without realizing it.  Through a peculiar turn of events, the version of GNU
which is widely used today is often called "Linux", and many of its users are
not aware that it is basically the GNU system, developed by the GNU Project.

There really is a Linux, and these people are using it, but it is just a
part of the system they use.  Linux is the kernel: the program in the system
that allocates the machine's resources to the other programs that you run.
The kernel is an essential part of an operating system, but useless by itself;
it can only function in the context of a complete operating system.  Linux is
normally used in combination with the GNU operating system: the whole system
is basically GNU with Linux added, or GNU/Linux.  All the so-called "Linux"
distributions are really distributions of GNU/Linux.
```

---

# C Standard Library
- Syscall wrappers
  - man 2 vs man 3
```
$ cat /proc/$$/maps
561fa56c6000-561fa56f5000 r--p 00000000 00:1f 669281                     /usr/bin/bash
...
561fa6d44000-561fa705c000 rw-p 00000000 00:00 0                          [heap]
...
7f0275133000-7f0275135000 rw-p 001d1000 00:1f 669212                     /usr/lib64/libc.so.6
...
7fffe0211000-7fffe0232000 rw-p 00000000 00:00 0                          [stack]
```

---

# Shared Libraries
- Some examples
```
$ cat /proc/$$/maps
...
7f027513d000-7f027514b000 r--p 00000000 00:1f 669207                     /usr/lib64/libtinfo.so.6.3
...
7f02751ba000-7f02751bc000 rw-p 00033000 00:1f 669209                     /usr/lib64/ld-linux-x86-64.so.2
...
```

---

# Storage Layout
```
$ lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sr0     11:0    1 1024M  0 rom
zram0  251:0    0  7.7G  0 disk [SWAP]
vda    252:0    0   10G  0 disk
├─vda1 252:1    0    1M  0 part
├─vda2 252:2    0    1G  0 part /boot
└─vda3 252:3    0    9G  0 part /home
                                /
```

---

# File system layout (See [FHS](https://refspecs.linuxfoundation.org/FHS_3.0/fhs-3.0.pdf))
- `/` → root of file system
- `/root` → home folder for root account
- `/bin` → command binaries
- `/boot` → boot loader files
- `/dev` → device files
- `/proc` → information about running processes
- `/etc` → configuration files
- `/home` → location of users' home folders
- `/lib` → libraries

---

# System Stack Overview
![system stack diagram](images/Linux_Crash_Course/system_stack_diagram.png)

---

# The future
Where will linux go from here?
