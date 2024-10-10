---
theme: white
---

# How to Write Kernel Modules
- Kernel documentation
    - Hacking index
    - Driver API
    - Module building
- Source analysis & books
    - https://elixir.bootlin.com
    - LDD3
    - The master documentation is the code
- Practice!

---

# Hello World Kernel Module
```console
$ cat hello.c
#include <linux/init.h>
#include <linux/module.h>

MODULE_LICENSE("GPL");

static int hello_init(void)
{
    printk(KERN_ALERT "Hello, world\n");
    return 0;
}

static void hello_exit(void)
{
    printk(KERN_ALERT "Goodbye, cruel world\n");
}

module_init(hello_init);
module_exit(hello_exit);
```

---

# We are not in Kansas anymore
- Goodbye main
- Goodbye C standard library
- Goodbye IEEE754
- Hello ring 0 ([x86_64](https://en.wikipedia.org/wiki/Protection_ring)) / EL1 ([aarch64](https://events.static.linuxfound.org/images/stories/pdf/lcna_co2012_marinas.pdf))
- Hello asynchronous execution
- Hello kernel API

---

# Kernelspace vs Userspace
- Small, fixed-size stack
- Each mode can have it’s own address space
- Kernel space handles access to hardware
- Execution is transferred to kernel space after a system call

---

# Reentrant code
- Potential confusion: What is called when?
- Kernel code must be able to run in more than one context
- Mutexes mandatory
![reentrant code](/images/Modules_Drivers/modules_drivers_slide14.png)
<https://www.cs.mcgill.ca/~cs573/fall2002/notes/lec273/lecture15/re-ent2.GIF>

---

# Why not stick with userspace?
- Context switches makes response time slower
- Access to hardware requires privileged instructions
    - The most important drivers can’t be handled in user space

---

# Symbols, Versions & Platform dependence
- Kernel symbol table
  - Contains address of global kernel items (functions and variables)
  - Changes every time the kernel is recompiled
  - Modules can access symbols already exported by other code
  - Modules can introduce their own exported symbols
- A Module must be recompiled for each version of the kernel that wants to link with
  - Module has to be built with same understanding of target processor as kernel
  - Easier to distribute driver for general distribution by contributing to the mainline kernel

---

# Compiling Modules (out-of-tree)
- Develop your code in own folder
- Compile by referencing the kernel makefile
- If you build your own kernel, the makefile will already be installed
- To get the makefile for a kernel from fedora run
```console
sudo dnf install kernel-devel-`uname -r`
````

---

# Hello World Kernel Module continued
```console
$ cat Makefile
obj-m += hello.o

.PHONY: build clean load unload

build:
    make -C /lib/modules/$(shell uname -r)/build modules M=$(shell pwd)

clean:
    make -C /lib/modules/$(shell uname -r)/build clean M=$(shell pwd)

load:
    sudo insmod hello.ko
unload:
    -sudo rmmod hello
```

---

# Loading and Unloading Modules
- Modules can be added/removed at runtime using insmod and rmmod
- Adding a module calls its init function, and removing it calls its exit function.
```console
$ make load
sudo insmod hello.ko
$ dmesg -t | tail -3
hello: loading out-of-tree module taints kernel.
hello: module verification failed: signature and/or required key missing - tainting kernel
Hello, world
$ make unload
sudo rmmod hello
$ dmesg | tail -1
Goodbye, cruel world
```

---

# Compiling Modules (in-tree)
- Add your code directly to the kernel, and add them to the Makefile(s)
- Compile the kernel
- Init is called at boot

---

# The End
