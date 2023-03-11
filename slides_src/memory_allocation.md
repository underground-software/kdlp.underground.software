---
theme: white
---

# Allocating Memory
[Chapter 8](https://static.lwn.net/images/pdf/LDD3/ch08.pdf)

---

# Story of kmalloc
- Similar to malloc
- Allocates contiguous memory

---

# The Flags Argument
void \*kmalloc(size_t size, int flags);
- GFP_ATOMIC
  - Allocate memory outside of a process context. Never sleeps
- GFP_KERNEL
  - Normal allocation of kernel memory
- GFP_USER
  - Used to allocate memory for user-space pages. It may sleep

---

# Memory zones
- DMA-capable memory
  - Used for DMA access
- Normal memory
  - Normal allocation
- High memory
  - Used to allow access to large amounts of memory on 32 bit platforms
- __GFP_DMA (only the dma zone is searched)
- If no flags present, DMA and and normal memory are searched
- __GFP_HIGMEM (all 3 zones are searched)

---

# Size Argument
- Kernel memory available page sized chunks
- Kernel creates set pools of memory objects of fixed size
- Allocation is handled by returning a memory chunk from a sufficiently large pool back to the requester
- memory allocated is fixed size byte arrays and requester will likely get back more memory than asked up to twice as much

---

# Lookaside Caches
- Special memory pool for high volume objects  
- kmem_cache_t \*kmem_cache_create(...)
  - creates a new cache object that can host any number of memory areas all of the same size, specified by the size argument
- void \*kmem_cache_alloc(kmem_cache_t \*cache, flags)
  - Allocate objects from cache object 
  - cache ( cache created by kmem_cache_create )
- void kmem_cache_free(kmem_cache_t \*cache, void \*obj)
  - Free object memory into a cache
- kmem_cache_destroy(kmem_cache_t \*cache)
  - Frees cache data structure; no longer usable

---

# Memory pools
Form of lookaside cache in kernel where memory allocation is not allowed to fail

---

# get_free_page and friends
Used to allocate memory in page sized chunks
- for when driver needs big chunks of memory
- void \*get_zeroed_page(unsigned int flags);
  - Returns pointer to a new page and fills the page with zeros
- __get_free_page
  - Similar to get_zeroed_page, but doesn’t clear the page
- Flags argument works similarly to kmalloc
  - Usually GFP_KERNEL or GFP_ATOMIC is used
- free_page(...), free_pages(...)

---

# vmalloc
Allocates contiguous memory in virtual address space
- Pages not consecutive. Each page retrieved by a call to alloc_page
- Address range used by vmalloc is synthetic. Sets up page tables
- void *vamalloc(unsigned long size);
- void free(void * addr);

---

# Per-CPU Variables
- When a per-cpu variable is created, each processor gets a copy
- Used in networking subsystem. Require no locking and are fast
- DEFINE_PER_CPU(type, name)
- Dynamically allocated 
  - void \*alloc_percpu(type);
  - void \* __alloc_percpu(size_t size, size_t align);

---

# Obtaining Large Buffers
- Allocations of large contiguous memory buffers are prone to failure
- Best way of performing large I/O operations is through scatter/gather operations (chapter 15)

---

# Acquiring Dedicated Buffer at Boot Time
- If you need a huge buffer of physical contiguous memory, request memory at boot time.
- Dirty technique that bypasses memory management policies
- Modules can’t allocate memory at boot time, only drivers directly linked to the kernel
