---
theme: white
---

# Kernel Modules and Device Drivers
## In Linux
[LDD3](https://www.amazon.com/dp/0596005903): [Chapters](https://lwn.net/Kernel/LDD3/) [1](https://static.lwn.net/images/pdf/LDD3/ch01.pdf) & [2](https://static.lwn.net/images/pdf/LDD3/ch02.pdf)

---

# Questions to answer
- What are devices and drivers?
- What are Linux kernel modules?
- How are these concepts related?

---

# What is a device?
- Examples: screen, keyboard, mouse, network interface, printer
- The "organs" of the computer
- A component of the computer that the cpu can interact with electronically

---

# What is a device driver?
- Bridge OS/Hardware gap
- Allow users to talk to device
- OS &harr; driver &harr; CPU &harr; devices

---

# Overview
![height:500px](images/Modules_Drivers/modules_drivers_slide9.png)
<http://haifux.org/lectures/86-sil/kernel-modules-drivers/kernel-modules-drivers.html>

---

# What is a Kernel Module
- Snippet of code that can be added to a running kernel

---

# Why Kernel Modules for Device Drivers?
- Keep kernel text/data minimal
    - Less error surface
- More customization
    - Can add hardware at runtime
- Easier to develop
    - Change text/data without reboot

---

# The End
