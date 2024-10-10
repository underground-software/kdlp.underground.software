---
layout: article
title: "Intro to Kernel Development: The Topics"
---
Working in Linux as an engineer
--

- setting up development env
- using git
- using ./configure && make (autotools)
- commandline basics & tips, tricks
- awk & more cool stuff


What is a Unix-like Operating System?
--

- Linux vs Unix & history: where does Linux come from?
- building a distro, minimal distro ("apparatus")
- what is a Linux process, syscall basics, file descriptor intro
- e.g. grep in a child process (bill cs308 assignment 2)
- open read write fork exec dup pipe wait close exit
- character devices and their operations

Hardware meets software
--

- What is CPU privilege
  - trying to execute forbidden instructions (rdmsr_priv_demo)
  - kernel abilities vs userspace
- exceptions: traps, interrupts, aborts
- featured example: Syscalls end-to-end
  - tracing a syscall instruction from the invocation
  - ??? stuff happens ???
  - response back to userspace

Assembly and C for kernel development
--

- writing makefiles
- C compilation deep dive, object files
- assembly vs machine code
- writing assembly to interact with the kernel without libc

Debugging
--

- searching code: cscope, elixr, git grep
- raw ftrace vs library ftrace
- ptrace
- strace
- perf
- gdb with qemu-system
- bpftrace
- valgrind 

Pseudo-filesystems as kernel interfaces: a Linux specialty
--

- /proc
- /sys
- /dev
- cgroup & ftrace

Kernel Modules as a way to learn about writing kernel code
--

- hello world module
- data types
- concurrency & kernel locking API

Participating in open source communities
--

- public speaking
- technical writing
- sending patches in general
- upstream Linux mailing list tour
- code review
