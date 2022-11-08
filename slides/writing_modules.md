---
theme: white
---

# How to Write Kernel Modules
- Kernel documentation
  - Hacking index
  - Driver API
  - Module building
  - https://elixir.bootlin.com
- Source analysis & books
  - e.g. LDD3
  - The master documentation is the code
- Practice!

---

# Versions & symbols & parameters
- Module has to be recompiled for each version of the kernel that it is linked to
- The Kernel symbol table
  - Contains address of global kernel items (functions and variables)
  - New modules can use symbols exported by your module
  - Module stacking
- Parameters 
  - Parameters can be assigned to modules at load time 
  - Passed by insmod or /etc/modprobe.conf 
  - Declared in module by module_param macro
  - module_param_array for array parameters

---

# Platform independence
- Module has to be built with same understanding of target processor as kernel
- Easier to distribute driver for general distribution by contributing to the mainline kernel

---

# Why not stick with userspace?
- Context switches makes response time slower
- DMA hassles 
- IO ports only accessible through system calls
- The most important drivers can’t be handled in user space

---

# Hello World Kernel Module
```console
[jsavitz@jsavitz hello] cat hello.c
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

# Hello World Kernel Module continued
```console
[jsavitz@jsavitz hello] cat Makefile
obj-m += hello.o

.PHONY: build clean load unload

build:
    make -C /lib/modules/$(shell uname -r)/build modules M=$(PWD)

clean:
    make -C /lib/modules/$(shell uname -r)/build clean M=$(PWD)

load:
    sudo insmod hello.ko
unload:
    -sudo rmmod hello
-------------------------------------------------
[jsavitz@jsavitz] dmesg | tail -3
[1070922.342530] hello: loading out-of-tree module taints kernel.
[1070922.342635] hello: module verification failed: signature and/or required key missing - tainting kernel
[1070922.343518] Hello, world
```

---

# Compiling Modules (out-of-tree)
- Develop your code in own folder
- Reference kernel headers as needed
  - You can install them with sudo dnf install kernel-headers-`uname -r` 
- Your Makefile should use the kernel makefile
  - You can install it using sudo dnf install kernel-devel-`uname -r`

---

# Loading and Unloading Modules
- Modules can be added/removed at runtime using insmod and rmmod
- Adding a module calls its init function, and removing it calls its destroy function.

---

# Compiling Modules (in-tree)
- Add your code directly to the kernel, and add them to the Makefile(s)
  - Don’t forget to add yourself to MAINTAINERS 
- Create configuration options
- Enable your module
- Compile the kernel

---

# The End
