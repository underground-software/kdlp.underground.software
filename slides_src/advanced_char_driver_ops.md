---
theme: white
---

# Advanced Character Driver Operations
## In Linux
[LDD3](https://www.amazon.com/Linux-Device-Drivers-Jonathan-Corbet/dp/0596005903): [Chapter](https://lwn.net/Kernel/LDD3/) [6](https://static.lwn.net/images/pdf/LDD3/ch06.pdf)

---

# ioctl
- int (\*ioctl) (struct inode \*inode, struct file \*filp, unsigned int cmd, unsigned long arg);
- Control hardware
  - Lock door, eject media, error information
- Big switch statement that selects the correct behavior according to ‘cmd’ argument

---

# ioctl commands
- Make the numbers for commands unique 
  - 4 bit fields (type, number, direction, size)
  - IO_TYPEBITS, _IOC_NRBITS ...
- _IO macro for combining a type and number into one value
  - See sensehat.h in repo for example

---

# ioctl return value
- POSIX standard states to return -ENOTTY when ioctl command is not valid
- Although several kernel functions return -EINVAL

---

# Capabilities & Restricted Operations
- A capability based system breaks down privileged operations into separate subgroups 
- Capset, capget
- if (! capable (CAP_SYS_ADMIN))
return -EPERM;

---

# ioctl argument
- Is unsigned long but can be an integer or a pointer
  - Depends on the particular ioctl
- Do appropriate checking before access if ‘arg’ is pointer
  - access_ok(type, \*addr, size)
  - put_user(), __put_user(), get_user(), __get_user()

---

# Implementation
- Often just a big switch statement
switch(cmd) { 
case SCULL_IOCRESET: 
scull_quantum = SCULL_QUANTUM; 
scull_qset = SCULL_QSET; 
break; 

case SCULL_IOCSQUANTUM: 
…
}

---

# Non-ioctl device control
- By writing control sequences 
  - For example; running a remote tty session
  - Escape sequences are printed remotely but affect the local tty
- Controlling by write
  - For devices that just respond to commands

---

# Blocking I/O
Putting process to sleep until IO operation can happen

---

# Sleeping
- When a process is put to sleep, it is removed from the scheduler’s run queue and put into a special state
- Never sleep when running in an atomic context
  - Atomic context is where multiple steps must occur without any concurrent access ie while holding a spinlock, seqlock or RCU lock
  - When interrupts are disabled
  - No way to wake up
- Somebody has to wake up sleeping process
  - Wait queue

---

# Simple sleeping
- Wait_event(queue, condition);
- wake_up(wait_queue_head_t \*queue);

---

# Blocking vs nonblocking I/O
- Sometimes process does not want to block whether or not it’s I/O can make progress
- O_NONBLOCK flag for non blocking I/O
- If read is called and no data, block until data arrives. 
- Similarly if write is called and no space in buffer, block until buffer is free
- If O_NONBLOCK is used, read and write calls simply return -EAGAIN (“try again”) allowing the application to poll for data

---

# Blocking I/O Example
Page 153 in [LDD3](https://static.lwn.net/images/pdf/LDD3/ch06.pdf)

---

# Advanced Sleeping
- First step: allocation and initialization of wait_queue_t structure followed by it’s addition to proper wait queue
- Second step is to set the state of the process to mark it as being asleep
  - TASK_ITERRUPTIBLE and TASK_UNINTERRUPTIBLE indicate a process is asleep
- Final step is to give up the processor. 
  - Check the condition you are sleeping for first. Failure to do this may result into a race condition
if (!condition) 
schedule( );

---

# poll and select
- Poll, select and epoll used by apps that use nonblocking I/O
- They all essentially have the same functionality
  - Each allow a process to determine whether it can read from or write to one or more files without blocking
- (\*poll) (struct file \*filp, poll_table \*wait);
  - Called when user-space program performs poll, select or epoll

---

# Poll and select vs read and write
- Poll and select determine in advance if an I/O operation will block in that respect complementing read and write
- Poll returns POLLIN|POLLRDNORM if there is data in the read buffer
- Poll reports that device is unreadable if there is no data
- Poll reports POLLHUP if we are at EOF
- Poll returns POLLOUT|POLLWRNORM if writing won’t block
- Reports file is not writable if writing would block

---

# struct poll_table\*
- Holds ‘struct file’ and ‘wait_queue_head_t’ pointers passed to poll_wait
- A call to poll or select involves a handful of file descriptors so the cost of setting up the data structure is small
- epoll allows for scaling to many file descriptors by setting up this data structure exactly once and to use it many times

---

# Async Notifs
- Instead of calling poll to check for data, set async notifs for when data becomes available
- Step 1: Specify process as owner of file
- Step 2: Set FASYNC flag in device by means of the F_SETFL fcntl command
- Input file can now request delivery of a SIGIO signal whenever new data arrives
signal(SIGIO, &input_handler); /\* dummy sample; sigaction( ) is better \*/ 
fcntl(STDIN_FILENO, F_SETOWN, getpid( )); 
oflags = fcntl(STDIN_FILENO, F_GETFL); 
fcntl(STDIN_FILENO, F_SETFL, oflags | FASYNC);

---

# POV: You are the driver
- When F_SETOWN is invoked, a value is assigned to filp->f_owner
- When F_SETFL is executed to turn on FASYNC, the driver’s fasync method is called
- When data arrives, all the processes registered for ansync notis must be sent a SIGIO

---

# llseek
- Provide llseek method if seek operation corresponding to a physical operation on a device rather than using default
- Some devices offer a data flow rather than a data area so seeking makes no sense. For example: serial ports of a keyboard
- In this case, use ‘nonseekable_open’ for open
- Set llseek method in ‘file_operations’ to no_llseek

---

# Access control
- Sometimes only one authorized user should be allowed to open a device
- Similar to ttys problem. 
- brute force: permit device to be opened by only one process at a time(single openness). AVOID THIS
- Allow only one user to open device but can be opened by multiple processes
  - Same policy as ttys

---

# Cloning the Device on Open
- Create different private copies of the device depending on process opening it
- Possible if not bound to hardware object
- /dev/tty uses a similar technique
- Copies of the driver are called “virtual devices” just like “virtual consoles” use a single tty device
- Rarely needed

---

# Block open instead of EBUSY
- Implement blocking ‘open’ so that the operation is slightly delayed rather than fail
- Implementation is based on wait queue
- Release is in charge of awakening any pending process
- A blocking ‘open’ implementation is a problem for interactive user who has to keep guessing what’s going on
  - Would rather get a “resource busy” message
