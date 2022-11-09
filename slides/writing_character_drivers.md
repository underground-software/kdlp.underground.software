---
theme: white
---

# Character Drivers
## In Linux

---

# Live Coding
## Bare bones module

---

# Major and Minor
- Major: maps to driver associated with device 
- Minor: which device within the driver
  - typedef dev_t
  - MAJOR(dev_t)
  - MINOR(dev_t)
  - MKDEV(major, minor)
- ls -l /dev
  - Look for c in first column

---

# Allocating and Freeing Device numbers
- register_chrdev_region
  - N minors (static)
- alloc_chrdev_region
  - Allocates some minors and a major for a specified number of needed minors
- unregister_chrdev_region
  - Frees major and minor number
- /proc/devices

---

# Dynamic allocation
- alloc_chrdev_region vs register_chrdev_region
  - Dynamic vs Static
  - Affects creation of device nodes
  - Static: easy node creation
  - Dynamic: bit more complex

---

# Device registration
- Register char dev 
  - cdev_alloc
  - my_cdev->ops = &my_fops;
  - cdev_init
  - cdev_add
- Remove char dev 
  - cdev_del
- The (much) older way
  - register_chrdev
  - unregister_chrdev

---

# Live Coding
## Major + Minor, make it show up in /dev/

---

# Important data structures
- struct file_operations
  - Holds pointer to the kernel methods (read, write, ioctl etc)
- struct file
  - Represents an open file (similar to FILE * or a file number in user space)
- struct inode
  - Represents a unique file within the directory structure (one or more paths may point to a single inode)
  - Many to one (file:inode)

---

# file_operations struct
- owner = THIS_MODULE
The Methods to the Madness
- llseek(2)
- read(2)
- write(2) 
- ioctl(2)
- open(2)
- release(2)
- ...

---

# file struct
- NOT the same as C library FILE pointer
  - It is its equivalent within the kernel
- Represents an open file
- Important fields
  - f_mode (opened for reading, writing etc (what you passed to open()))
  - f_pos (current location in file)
  - f_flags (flags you passed to open())
  - f_op (pointer to file operations the kernel will use with this file)
  - private_data (driver can use this to hold info it needs)

---

# inode struct
- Used by kernel to represent files
- Two important fields 
  - i_rdev: Contains device number 
  - i_cdev: Contains pointer to char device

---

# Live Coding
## Stubs for driver functions

---

# Memory usage
- kmalloc (often devm_kmalloc)
  - Typically used in probe/init
- kfree (only needed if you aren’t using devm)
  - Typically used in remove/exit
- Kinda like malloc/free with extra steps
  - No glibc!
  - Need to tell the kernel memory zone
  - How long can you afford to wait?

---

# Open and Release
- Open
  - Initialize device if being used for the first time
  - Check for device specific errors 
  - Update f_op
  - Set private data if needed
- Release 
  - Deallocate anything allocated in open
- Kinda like kmalloc/kfree for the whole thing

---

# Read and Write
- How do we get access to memory in user space?
- Read (write from kernel side)
  - copy_to_user
- Write (read from kernel side)
  - copy_from _user
- __user to mark a userspace ptr
  - Don’t just dereference!

---

# Why not just dereference?
- In process context
  - Oops + death on a page fault
- Elsewhere, null ptr deref:
  = panic() (big death) (not from system call)
- Unchecked __\* versions of copy_\*_user

---

# Live Coding
## Make it do something! Echo user input

---

# Scull: Simple Character Utility for Loading Local Localities
- Example char driver used throughout LDD3
- RAM simulation of external storage
  - Platform/Hardware independent
- [scull/main.c at master · starpos/scull · GitHub](https://github.com/starpos/scull/blob/master/scull/main.c)

---

# Linux Driver Development with Raspberry Pi - ch4
- Chapter 4 has examples of complete char dev including miscellaneous character module 
- miscdevice
  - Simpler way to write char device driver 
  - Used for sense-hat display

---

# Discussion
