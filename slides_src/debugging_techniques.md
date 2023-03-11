---
theme: white
---

# Debugging Techniques
## For the Linux Kernel
[LDD3](https://www.amazon.com/Linux-Device-Drivers-Jonathan-Corbet/dp/0596005903): [Chapter](https://lwn.net/Kernel/LDD3/) [4](https://static.lwn.net/images/pdf/LDD3/ch04.pdf)

---

# Printk: the elite printf
Log levels 
- KERN_EMERG 
- KERN_ALERT 
- ...
printk(KERN_XXXX "format string", ...); 
NOT: printk(KERN_XXX, "format string", ...); 
/proc/sys/kernel/printk

---

# Querying
Massive use of printk slows down the system, query system info instead 
Can also rate limit
Techniques for querying: 
- Using /proc filesystem
- ioctl 
- sysfs

---

# Using the /proc filesystem
Each file under /proc is tied to a kernel function that generates it’s contents 
- ps, top, uptime …, get info from /proc 
- Add/create files in /proc to export messages from drivers (discouraged)
- Use sysfs instead (covered in ch-14)

---

# ioctl

- System call that acts on a file descriptor 
- Implement ioctl commands tailored for debugging 
- Faster than /proc
- But more work compared to using /pro

---

# Watching
Watch behavior of driver in user space
- Call read() and watch it’s behavior 
- Run a debugger and step through function calls 
- strace

---

# More on strace
A command that shows all system calls issued by a user-space program
- Shows function calls, their arguments and return values
- -t (to display time call was made)
- -e (to limit type of calls traced)
- -o (to redirect output. Default is stderr)
Strace example next 

---

# strace ls /dev > /dev/scull0
open("/dev", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 3 
...
getdents64(3, /\* 141 entries \*/, 4096) = 4088 
…
fstat64(1, {st_mode=S_IFCHR|0664, st_rdev=makedev(254, 0), ...}) = 0
write(1, "MAKEDEV\nadmmidi0\nadmmidi1\nadmmid"..., 4096) = 4000 
write(1, "b\nptywc\nptywd\nptywe\nptywf\nptyx0\n"..., 96) = 96
…
close(1)
exit_group(0)

---

# System faults/Oops messages
- Caused by dereferencing NULL or invalid pointer
- When an invalid pointer is dereferenced, the paging mechanism cannot map the pointer to a physical address and the processor signals a page fault

---

# System Hangs
Sometimes there are no oops messages printed when bugs in the kernel hang the system
- Endless loop causes the kernel to stop scheduling aka hang

---

# Tools for Advanced Debugging and More
- BPF: more than just the Berkeley Packet Filter
- Ftrace: “function tracer” but much more
- Gdb and friends (such as crash)
- [Ptrace](https://man7.org/linux/man-pages/man2/ptrace.2.html): from one process to another
- [Perf](https://en.wikipedia.org/wiki/Perf_(Linux)): performance analysis tool

