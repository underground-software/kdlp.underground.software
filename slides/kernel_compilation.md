---
theme: white
---

# How can I, a regular citizen, compile the Linux Kernel
- Start by getting the Kernel from its source, Linus Torvalds git repo
  - [https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git)
- You can download the source code as a zip from the website or by using the git clone command
  - git clone "https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git"

---

- Once you have the source code, you need to acquire all of the necessary tools to compile the kernel. A short list of most of them is available inside the Kernel repository in the file Documentation/Changes
- On fedora you can install them with the command:
  - sudo dnf -y install gcc flex make bison openssl openssl-devel elfutils-libelf-devel ncurses-devel bc git tar dwarves
- On other distributions you will need the same dependencies but the packages might have slightly different names

---

- The Kernel is extremely configurable, but most of the settings are not something you want to worry about. To make a kernel that will be compatible with your existing OS, you want to base the configuration on those from your current kernel.
  - Run the command cp /boot/config-$(uname -r)\* .config from within the linux folder
- Now generate a new config based on those options.
  - Run make olddefconfig to copy the existing settings, and automatically pick default values for new options
- You’re now ready to begin the actual build. Run this command:
  - make -j$(nproc) vmlinux modules

Expect this to take a few hours! And crash many times!

---

- During the compilation process, you will inevitably run into issues like missing dependencies. If make can’t find some command, try and install it using dnf. If that doesn’t work, try googling the error to see if someone else has encountered it. Send us a message on discord if you get stuck. This is tedious but to be expected.
- Once make finishes, you have officially compiled the Kernel. But… what good is a Kernel if you aren’t using it?
- To install the kernel, run this command:
  - sudo make modules_install install
- You now have built and installed the kernel! Congrats!

---

# Useful Resources
- Fedora has a guide on installing linux:
  - [https://docs.fedoraproject.org/en-US/quick-docs/creating-and-using-a-live-installation-image/](https://docs.fedoraproject.org/en-US/quick-docs/creating-and-using-a-live-installation-image/)
- They also have a guide on how to build your own kernel:
  - [https://docs.fedoraproject.org/en-US/quick-docs/kernel/build-custom-kernel/](https://docs.fedoraproject.org/en-US/quick-docs/kernel/build-custom-kernel/)
- Bootlin - browsable linux source code
  - [https://elixir.bootlin.com/linux/latest/source](https://elixir.bootlin.com/linux/latest/source)

