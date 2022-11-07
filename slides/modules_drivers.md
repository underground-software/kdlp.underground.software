---
theme: white
---

# Kernel Modules and Device Drivers
## In Linux
[LDD3](https://www.amazon.com/Linux-Device-Drivers-Jonathan-Corbet/dp/0596005903): [Chapters](https://lwn.net/Kernel/LDD3/) [1](https://static.lwn.net/images/pdf/LDD3/ch01.pdf) & [2](https://static.lwn.net/images/pdf/LDD3/ch02.pdf)

---

# What?
![slide 2](images/Modules_Drivers/modules_drivers_slide2.png)

[http://haifux.org/lectures/86-sil/kernel-modules-drivers/kernel-modules-drivers.html](http://haifux.org/lectures/86-sil/kernel-modules-drivers/kernel-modules-drivers.html)

---

![slide 3](images/Modules_Drivers/modules_drivers_slide3.png)

[http://www.science.unitn.it/~fiorella/guidelinux/tlk/node125.html](http://www.science.unitn.it/~fiorella/guidelinux/tlk/node125.html)
[https://www.researchgate.net/figure/Initialization-of-a-kernel-module_fig8_261599172](https://www.researchgate.net/figure/Initialization-of-a-kernel-module_fig8_261599172)

---

![slide 4](images/Modules_Drivers/modules_drivers_slide4.png)

[https://en.wikipedia.org/wiki/File:Linux_kernel_diagram.svg](https://en.wikipedia.org/wiki/File:Linux_kernel_diagram.svg)
[https://ritcsec.wordpress.com/2017/05/17/modern-linux-rootkits/](https://ritcsec.wordpress.com/2017/05/17/modern-linux-rootkits/)
[https://www.linux.it/~rubini/docs/ksys/](https://www.linux.it/~rubini/docs/ksys/)
[https://www.servercake.blog/list-loaded-modules-kernel/](https://www.servercake.blog/list-loaded-modules-kernel/)
[https://en.wikipedia.org/wiki/Linux_kernel_interfaces](https://en.wikipedia.org/wiki/Linux_kernel_interfaces)
[https://stackoverflow.com/questions/7578582/who-calls-the-probe-of-driver](https://stackoverflow.com/questions/7578582/who-calls-the-probe-of-driver)

---

# Have no fear
![slide 5](images/Modules_Drivers/modules_drivers_slide5.png)

---

# Potential areas of confusion
- How does this all together?
- What is called when?

---

# What is a device?
- A physical component that is attached to the cpu
- The “organs” of the computer
- A replaceable component
  - Mostly 

---

# What is a device driver?
- Bridge OS/Hardware gap
- Allow users to talk to device
- OS <-> driver <-> CPU <--> devices

---

# Overview
![slide 9](images/Modules_Drivers/modules_drivers_slide9.png)
[http://haifux.org/lectures/86-sil/kernel-modules-drivers/kernel-modules-drivers.html](http://haifux.org/lectures/86-sil/kernel-modules-drivers/kernel-modules-drivers.html)

---

# What is a Kernel Module
- Snippet of code that can be added to a running kernel

---

# Why Kernel Modules for Device Drivers?
- Keep kernel text/data minimal
- Change text/data without reboot
- More customization
- Less error surface
- Easier to develop
- Can add hardware at runtime
  - (if you know it’s address)

---

# We are not in Kansas anymore
- Goodbye main
- Goodbye C standard library
- Goodbye IEEE754
- Hello ring 0 ([x86_64](https://en.wikipedia.org/wiki/Protection_ring))/EL1 ([aarch64](https://events.static.linuxfound.org/images/stories/pdf/lcna_co2012_marinas.pdf))
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
- Kernel code must be able to run in more than one context
- Mutexes mandatory
![reentrant code](images/Modules_Drivers/modules_drivers_slide14.png)
[https://www.cs.mcgill.ca/~cs573/fall2002/notes/lec273/lecture15/re-ent2.GIF](https://www.cs.mcgill.ca/~cs573/fall2002/notes/lec273/lecture15/re-ent2.GIF)
