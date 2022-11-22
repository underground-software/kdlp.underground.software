---
theme: white
---

# Hardware
## In Linux
[LDD3](https://www.amazon.com/Linux-Device-Drivers-Jonathan-Corbet/dp/0596005903): [Chapter](https://lwn.net/Kernel/LDD3/) [9](https://static.lwn.net/images/pdf/LDD3/ch09.pdf)

---

# Device Registers
- Peripheral devices are controlled by reading from and writing to their registers.
- The registers are accessed either through memory address space or I/O address space, both of which are equivalent interfaces in hardware, reading from and writing to the address bus, the control bus, and the data bus.

---

# Compiler Optimizations
- I/O registers have side effects, while memory registers do not.
- Because of this, developers need to be careful of compiler optimizations that can change the order of read/write I/O operations.
- To prevent this issue, use memory barriers

---

# Memory Barriers
- Read/write operations that appear before a relevant memory barrier execute before any read/write operations that appear after it
  - rmb() - Read memory barrier
  - wmb() - Write memory barrier
  - mb() - Memory barrier (for both)
  - read_barrier_depends() - weaker rmb
- read_barrier_depends() only blocks reordering reads when they have data dependencies upon one another 

---

# I/O Port Allocation
- To interact with device registers, the device is accessed through an I/O port
- To use the I/O port, one must first acquire exclusive access to it using:
```console
struct resource *request_region(unsigned long first, unsigned long n, const char *name);
```
- This requests <n> ports starting with <first>, for the device called <name>.
- When you’re done with the ports release them using:
```console
void release_region(unsigned long start, unsigned long n);
```

---

# Manipulating I/O Ports
- To read from and write to I/O ports, you must use the appropriate sized function:
  - unsigned inb(unsigned port) - read one byte from an 8-bit port
  - void outb(unsigned char byte, unsigned port) - write one byte to an 8-bit port
  - unsigned inw(unsigned port) - read one word from a 16-bit port
  - void outw(unsigned port) - write one word to a 16-bit port
  - unsigned inl(unsigned port) - read one long from a 32-bit port
  - unsigned outl(unsigned port) - write one long to a 32-bit port
- No 64 bit port operations are defined, 64-bit architectures use a maximum of 32-bit operations on I/O ports

---

# Manipulating I/O Ports in User Space
- inb(/w/l) and outb(/w/l) can be used in user-space as they’re defined in <sys/io.h>, to use them a program must be run as root, compiled with “-O” to force extension of inline functions, and acquire permissions using:
  - ioperm - to get permissions for individual ports
  - iopl - to get permissions for the entire I/O space
- Alternatively, user programs can access I/O ports using their device files in /dev/<device name>

---

# String Operations on Ports
- I/O ports can be read from and written to using C-strings using the following functions:
```console
void insb(unsigned port, void *addr, unsigned long count); 
void outsb(unsigned port, void *addr, unsigned long count);
void insw(unsigned port, void *addr, unsigned long count); 
void outsw(unsigned port, void *addr, unsigned long count);
void insl(unsigned port, void *addr, unsigned long count); 
void outsl(unsigned port, void *addr, unsigned long count);
```
- When using string operations, look out for mismatches between byte-ordering rules of the host system and the I/O device (little endian vs big endian)

---

# I/O Pausing
- If the device is slower than your processor, it can be overclocked and miss data, to solve for this, use pausing I/O functions which implement a wait in between I/O operations.

---

# Platform Dependencies
- I/O port operations are highly platform dependent
- For example, a port can be unsigned short in some architectures and unsigned long in others

---

# Using I/O Memory
- A popular alternative to I/O ports is I/O memory
- I/O memory is RAM regions that a device makes available to the processor through the bus
- Technically, it’s possible to access I/O memory using pointers, much like regular memory, but this is highly discouraged for security and stability concerns

---

# I/O Memory Allocation and Mapping
- I/O memory regions must be allocated prior to use, using:
```console
struct resource *request_mem_region(unsigned long start, unsigned long len, char *name);
```
- This allocated a <len> long memory region starting at <start> for device <name>
- When you’re done with a memory region, release it using:
```console
void release_mem_region(unsigned long start, unsigned long len);
```

---

# Accessing I/O Memory
- To access I/O memory regions, one must obtain their address using:
```console
void *ioremap(unsigned long phys_addr, unsigned long size); 
void *ioremap_nocache(unsigned long phys_addr, unsigned long size);
```
- The nocache version of ioremap gives a pointer to a read/write interface with no data caching, which drivers may sometimes need depending on the device

---

# Read/Write I/O Memory
- To read from and write to I/O memory, use the functions:
```console
unsigned int ioread8(void *addr); 
unsigned int ioread16(void *addr); 
unsigned int ioread32(void *addr);
void iowrite8(u8 value, void *addr); 
void iowrite16(u16 value, void *addr); 
void iowrite32(u32 value, void *addr);
```
- Where addr is the address obtained from ioremap.
- There are also versions of all of these functions that allow repeating read/write that look like:
```console
void ioread8_rep(void *addr, void *buf, unsigned long count);
```
- Note: count is expressed as number of relevant data units (8-bit/16-bit/32-bit)

---

# Read/Write I/O Memory
- You can also read from and write to I/O memory as a block using:
  - Fill a memory block with a repeating byte <value>
```console
void memset_io(void *addr, u8 value, unsigned int count); 
```
  - Copy from I/O memory <source> to regular memory <dest> <count> bytes
```console
void memcpy_fromio(void *dest, void *source, unsigned int count);
```
  - Copy from regular memory <source> to I/O memory <dest> <count> bytes
```console
void memcpy_toio(void *dest, void *source, unsigned int count);
```

---

# Read/Write I/O Memory
- There are also old functions discouraged from use to operate on I/O memory:
```console
unsigned readb(address); 
void writeb(unsigned value, address);
unsigned readw(address); 
void writew(unsigned value, address);
unsigned readl(address); 
void writel(unsigned value, address);
```

---

# Ports as I/O Memory
- The kernel provides functions to map I/O ports as I/O memory regardless of their actual implementation on the device:
```console
void *ioport_map(unsigned long port, unsigned int count);
```
- This converts <count> ports starting at <port> to appear as I/O memory
- Once you’re done with the ports, unmap the I/O memory using:
```console
void ioport_unmap(void *addr);
```
