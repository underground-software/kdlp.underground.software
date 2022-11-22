---
theme: white
---

# Block Drivers
Chapter 16

---

# Block Drivers
- Accessed by fixed sized blocks
- Primarily used for disks drivers
- Performance is more important than with char devices
- Need to include in the driver:
```console
#include <linux/genhd.h>
#include <linux/blkdev.h>
#include <linux/fs.h>
```

---

# Data types
- Blocks are fixed size chunks of data, with size determined by the Kernel - usually 4096 bytes
- Sectors are smaller fixed size chunks of data, with size determined by the attached hardware (i.e. disk) - usually 512 bytes

---

# Registration
- Block devices are registered and unregistered using the following functions included from linux/fs.h
```console
int register_blkdev(unsigned int major, const char *name);
int unregister_blkdev(unsigned int major, const char *name);
```
- As with char devices, passing 0 as the major number will make the kernel assign an available major number

---

# Block Drivers Operations
- Some of the operations work exactly like they do in char drivers:
```console
int (*open)(struct inode *inode, struct file *filp);
int (*release)(struct inode *inode, struct file *filp);
int (*ioctl)(struct inode *inode, struct file *filp, unsigned int cmd, unsigned long arg);
```

---

# Block Driver Operations
- Block driver specific methods:
```console
int (*media_changed) (struct gendisk *gd);
```
- Checks if the user made a change to the removable media: returns non-zero value on change 
```console
int (*revalidate_disk) (struct gendisk *gd);
```
- Called when a user makes a change in the media, performs required work according to the change.
- struct gendisk represents a single disk in the kernel

---

# struct gendisk
- See linux/genhd.h
- Initialized by the Block driver
- Arguments:
```console
int major; int first_minor; int minors; # each minor represents a partition
char disk_name[32]; # cat /proc/partitions
struct block_device_operations *fops;
struct request_queue *queue; # used by kernel to manage I/O requests
int flags; # bit fields flags describing the device (i.e. GENHD_FL_REMOVABLE)
sector_t capacity; # the capacity of the device in 512-byte long sectors unit
void *private_data; # to be used at the discretion of the block driver 
```

---

# struct gendisk
- To allocate a struct gendisk:
```console
struct gendisk *alloc_disk(int minors);
```
- Free using:
```console
void del_gendisk(struct gendisk *gd);
```
- Finally, add the gendisk to the system using:
```console
void add_disk(struct gendisk *gd);
```
- Set the capacity for the gendisk using:
```console
void set_capacity(struct gendisk *gd, sector_t sectors)
```
