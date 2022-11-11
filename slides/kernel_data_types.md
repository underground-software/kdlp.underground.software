---
theme: white
---

# Data Types in the Kernel

---

# Use of Standard C Types
- Standard C data types aren’t the same  size on all architectures
  - Raises portability issues
  - e.g long:
    - x86: sizeof(long) == 4 
    - x86_64: sizeof(long) == 8 
- Example: in misc-progs
  - Program shows different data types and their sizes
- Unused by linux: {u,}intptr_t 

---

# Assigning an Explicit Size to Data Items
- Sometimes kernel code requires data items of a specific type
  - u8, u16, u32, u64 
  - Corresponding signed types exist but rarely used
- Double underscore used in user space
  - __u8, __u32, … 
- Compare to stdint.h in userspace

---

# Interface-Specific types
- Most of the commonly used data types in the kernel have their own typedef statements. Prevents portability problems
  - pid_t instead of int
- typedef defined types now less fashionable
  - devs would rather see the real type information
  - Hence things like: struct task_struct
  - Ambiguity: How to printf \*_t types?

---

# Other Portability Issues : Time Intervals
- Don’t assume that there are 1000 jiffies per second 
  - This is true for i386 platform
- Instead the time using HZ
- For example to check a against a time out of half a second :
  - HZ / 2

---

# Other portability Issues : Page Size
- Memory page is PAGE_SIZE bytes and not necessarily 4 KB
- Don’t hard code the value, might diff size depending on platform
- To (portably) get a 16 KB page for temporary data :
```console
#include <asm/page.h>
int order = get_order(16\*1024); 
buf = get_free_pages(GFP_KERNEL, order);
```

---

# other Portability Issues : Byte Order
- Don’t make assumptions about byte ordering 
  - Some are little-endian and others big-endian
  - Most PCs store multibyte values low-byte first and other platforms do this the other way around
- u32 cpu_to_le32(u32) and u32 le32_to_cpu(u32)
  - Above macros do conversions between little-endian and big-endian depending on the processor

---

# Other Portability Issues : Data Alignment
- Support for unaligned data access varies by platform
- Use: {get,put}_unaligned()
- Better to align your data
  - FYI: Compiler may rearrange and add padding

---

# Pointers and Error Values
- Returning a NULL pointer when a function fails doesn’t communicate what the problem is
- Return an error code
- Error code is encoded in a pointer 
  - void \*ERR_PTR(long error)
  - Use IS_ERROR to check if returned pointer is error code
    - long IS_ERR(const void \*ptr);
- long PTR_ERR(const void \*ptr);
  - Extract actual error code

---

# Linked Lists
- Kernel developers developed standard circular doubly linked list to prevent duplication of code
- struct list_head is used to maintain a list of data structures
  - Standard circular doubly linked list
- INIT_LIST_HEAD
  - Used to initialize list head prior to use
```console
struct list_head todo_list; 
INIT_LIST_HEAD(&todo_list);
```

---

# Linked Lists
![ll image](images/Kernel_Data_Types/ll.png)
[Source](https://static.lwn.net/images/pdf/LDD3/ch11.pdf)
