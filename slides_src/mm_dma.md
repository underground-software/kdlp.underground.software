---
theme: white
---

# Memory Mapping and DMA
## Chapter 15

---

# Address Types
- vmlinux: Virtual Memory linux
- Programs can allocate far more memory than is physically available
- Address types :
  - User virtual addresses
  - Physical addresses
  - Bus addresses (on some arches: same as physical addresses)
  - Kernel logical addresses (often at constant offset from physical address)
  - Kernel virtual addresses (superset of logical addresses)
- Convert addresses using:
- __{p,v}a() from asm/page.h

---

# Physical Addresses and Pages
- Physical RAM divided into fixed-size “pages”
- PAGE_SIZE may vary between arches
  - On x86_64: usually 4K
- Page tables!
  - The processor uses page tables to translate virtual addresses into corresponding physical addresses
  - Multi-level memory

---

# Page table diagram
![page table](images/MM_DMA/page_table.png)
[source](https://0xax.gitbooks.io/linux-insides/content/Theory/linux-theory-1.html)

---

# High and Low Memory
- Low memory is memory for which logical address exists in kernel space
  - On most systems, all memory is low memory 
- High memory: address physical memory outside of virtual address space
  - E.g. x86: 32 bit pointer => 4G addressable memory
  - But what if we want more?
- Must set up mapping as needed
- Unnecessary on many systems (64-bit)

---

# Memory Map and struct Page
- Struct Page
  - Keeps track of info about physical memory
- There is one struct page for each physical page
- Some macros and functions that translate between struct page pointers and virtual addresses
  - struct page \*virt_to_page(void \*kaddr);
  - struct page \*pfn_to_page(int pfn);
  - void \*page_address(struct page \*page);
  - void \*kmap(struct page \*page);
  - ...
- Useful when dealing with high/low mem situations (x86)

---

# Virtual Memory Areas
- VMA is a kernel data structure used to manage distinct regions of a process’s address space
- Memory area of a process $PID can be seen by 
  - cat /proc/$PID/maps
- struct vm_area
  - A driver that supports mmap(2) needs to initialize a VMA
  - This structure corresponds to the memory userspace maps via mmap(2)

---

# The Process Memory Map
- struct mm_struct
  - Holds all the other data structures together
- Contains :
  - A process’s list of virtual memory areas
  - Page tables
  - A semaphore and a spinlock
  - …
- mm_struct can be shared between processes

---

# The mmap Device Operation
- Allows direct userspace access to device memory
- The mmap(2) ptr is part of struct file_operations
- System call: mmap(caddr_t addr, size_t len, int prot, int flags, int fd, off_t offset)
- File operation: int (\*mmap)(struct file \*filp, struct vm_area_struct \*vma);
- PAGE_SIZE granularity

---

# Using remap_pfn_range
- This function along with io_remap_page_range are used to map a range of physical addresses
- int remap_pfn_range(struct vm_area_struct \*vma, unsigned long virt_addr, unsigned long pfn, unsigned long size, pgprot_t prot);
- remap_pfn_range intended for use when pfn refers to RAM and io_remap_pfn is used phys_addr points to I/O memory

---

# Adding VMA operations
- open(2) and close(2)
  - Called whenever a process opens or closes the VMA
- Installation is like struct file_operations
```console
void my_vma_open(struct vm_area_struct \*vma) { … }
void my_vma_close(struct vm_area_struct \*vma) { … }
static struct vm_operations_struct my_vma_ops = {
    .open = my_vma_open,
    .close = my_vma_close, };
```
- Done in mmap method:
```console
vma->vm_ops = my_vma_ops;
```

---

# Mapping Memory with nopage
- Page not present in mapping (page fault)? Call nopage() to fix it
  - struct page \*(\*nopage)(struct vm_area_struct \*vma, unsigned long address, int \*type);
- mremap(2) can change the bounding addresses of a mapped region
  - Driver is not notified
- Called when user process tries to access a page that isn’t present in memory
- Returns appropriate struct page \*
- Different struct vma_operations for driver when using nopage

---

# Remapping Specific I/O Regions
- Most drivers only remap small range
- Done by calculating offsets
- User process can always use mremap to extend it’s mapping
  - Implement a simple nopage method that causes a bus signal to be sent to the faulting process to prevent extension of mapping

---

# Remapping RAM
- Reserved pages are the only ones that can safely be mapped to user space
  - Reserved pages are pages that aren’t available for memory management
  - E.g. 640KB to 1G on x86

---

# Remapping kernel Virtual Addresses
- Virtual address is an address returned by vmalloc
  - Mapped in kernel page tables, not user page tables
- No need to check the order parameter
  - Vmalloc allocates memory one page at a time. More likely to succeed

---

# Performing direct I/O
- Most I/O operations are buffered through the kernel
- Direct I/O from user space could potentially speed things up
  - setup overhead for direct I/O is potential bottleneck
- Not necessary for a char driver
- Done with function: get_user_pages()

---

# Asynchronous I/O
- Allows applications to to do other processing while I/O is in progress
  - almost always involves direct I/O
- Necessary struct file_operations entries:
  - ssize_t (\*aio_read)(...)
  - ssize_t (\*aio_write)(...)
  - int (\*aio_fsync)(...)

---

# Direct Memory Access
“DMA is the hardware mechanism that allows peripheral components to transfer their I/O data directly to and from main memory without the need to involve the system processor.” -- LDD3, page 440

---

# Overview of a DMA Data Transfer
- Synchronous DMA read
  - Driver allocates DMA buffer, the hardware transfers data to buffer, process sleeps
  - On completion of write, hardware raises interrupt
  - The interrupt handler awakens the process and the actual reading takes place
- Asynchronous DMA read
  - Hardware raises an interrupt
  - Interrupt handler allocates DMA buffer
  - Peripheral device writes to buffer and raises another interrupt when done
  - Second handler handles new data and wakes up relevant process

---

# Allocating the DMA Buffer
- Buffer Size > PAGE_SIZE:
  - Buffer must occupy contiguous pages in physical memory because ISA and PCI carry physical addresses
- Can reserve physical memory with mem= kernel param
  - Use ioremap to get a usable virtual address

---

# Bus Addresses
- Device driver using DMA talks to interface bus that carries a physical address
- DMA-based hardware actually uses bus addresses
  - Sometimes physical addresses
  - Sometimes special other addresses

---

# DMA mappings
A DMA mapping is a combination of allocating a DMA buffer and generating an address for that buffer that is accessible by the device
- Bounce buffers
  - Necessary when a device cannot access some area of physical memory, such as highmem
- Cache coherency
  - DMA mappings must account for this
  - dma_alloc_coherent()
- Other options
  - Streaming mappings
  - scatter/gather mappings

---

# DMA Pools
- For small, coherent DMA mappings
  - E.g. device needs DMA area smaller than one page
- Also used where dma is performed in areas embedded in a larger structure
- dma_pool_{create,destroy,alloc,free}()

---

# Registering DMA usage
- Similar to I/O ports and interrupt registry
- To obtain and release DMA channel:
  - int request_dma(unsigned int channel, const char \*name);
  - void free_dma(unsigned int channel);
- Take same care of DMA channels as interrupts and I/O ports
  - Request channel at open time
  - Delaying request allows sharing between drivers

---

# Talking to DMA controller
- Read asm/dma.h for details
- Driver is in charge of configuring the DMA controller
  - When read or write is called or for asynchronous transfers
- Asynchronous transfers happen at open(2) or ioctl(2) call
- DMA controller is a shared resource
  - Use: {claim,release}_dma_lock()
- Methods:
  - set_dma_mode() (read or write)
  - set_dma_addr() (set address of buffer)
  - set_dma_count() (how many bytes to transfer)
