---
theme: white
---

# Concurrency and Race Conditions
## In the Linux kernel

[LDD3](https://www.amazon.com/Linux-Device-Drivers-Jonathan-Corbet/dp/0596005903): [Chapter](https://lwn.net/Kernel/LDD3/) [5](https://static.lwn.net/images/pdf/LDD3/ch05.pdf)

---

# Review of Definitions

---

# Thread
- Thread of execution
- Stores execution state (registers + instruction pointer) and has its own stack
- Each process has at least one (but maybe more) of them
- Is the unit of program that actually is scheduled on to the CPU

---

# Concurrency
- Multiple threads of execution happening (or appearing to happen) at the same time
- Even with a single cpu core, task switching can give the same effects as true multiprocessing
- Up to the OS scheduler to decide who runs when

---

# Sleep
![penguins](/images/Concurrency/penguins.png)
- When a linux process reaches a point where it cannot make further progress until something else is finished (e.g. waiting for data from disk or user io)
- Scheduler yields the processor to another thread

---

# Interrupt
- A signal emitted by hardware or software when something needs immediate attention
- Scheduler gives the code responsible for handling these extremely high priority

---

# Critical Section
- Section of code where shared resources (data like global variables or state like i/o) are accessed by a thread of execution
- Cannot have multiple threads working on the same shared resources running their critical sections concurrently
  - That’s a race condition!

---

# Race Condition
- Multiple processes trying to access shared data at the same time
- “Race” to see which thread reads/writes data first
- Unexpected results when wrong access pattern happens
  - Memory leak
  - Corrupted data
  - System crash
- The asynchronous nature of interrupts means that code handling them must be extremely careful with global data. It also cannot block (sleeping)
  - Increased probability of race conditions 

---

# Mutual exclusion
- Maintain concurrency for independent parts of execution (so we can enjoy speed or responsiveness benefits of parallel execution)
- Stop multiple processes from running within a critical section simultaneously
- Ensured using locking data structures like spin locks, semaphores, mutexes, event counters, sequencers, etc.

---

![mutual exclusion 1](/images/Concurrency/slide10.png)
[image source](https://www.geeksforgeeks.org/mutual-exclusion-in-synchronization/)

---

![mutual exclusion 2](/images/Concurrency/slide11.png)
[image source](https://www.geeksforgeeks.org/mutual-exclusion-in-synchronization/)

---

![mutual exclusion 3](/images/Concurrency/slide12.png)
[image source](https://www.geeksforgeeks.org/mutual-exclusion-in-synchronization/)

---

# Deadlock
![deadlock](/images/Concurrency/slide13.png)
- Mutual exclusion gone wrong
- A situation where threads are holding some resources but also blocked waiting for others in a cycle preventing any forward progress.
[image source](https://www.geeksforgeeks.org/introduction-of-deadlock-in-operating-system/)

---

# Locking Data Structures
- spinlock
  - locking primitive that can be used to implement all other forms of mutual exclusion
- semaphore
  - Combination of integer value and two functions for increment and decrement (v,p)
- mutex
  - Special kind of semaphore with only two states locked/unlocked

---

# Concurrency Techniques within Linux

---

# Spinlocks
- spinlock_t in kernel
- Spinlocks must be held for minimum time possible 
Only acceptable in atomic contexts

---

# Spinlocks in Atomic Context
- Interrupts must be disabled on local cpu when a lock is used
  - Preemption disabled by locking implementation!
- Why? an interrupt might cause a different thread to be scheduled, which may require the lock you just took but haven’t yet released
  - Deadlock!
- Code must therefore be atomic (cannot sleep)

---

# Semaphores and Mutexes
- struct semaphore 
- struct mutex

---

# Reader/Write Semaphores
![semaphores](/images/Concurrency/slide19.png)
- Allows multiple concurrent readers
- rwsem 
  - One writer or unlimited number of readers
  - Writers get priority
  - Allowing multiple readers Optimizes performance
[image source](https://sungju.github.io/kernel/internals/synchronization.html)

---

# Completions
- Allow a thread to tell another that a job is done
- Better locking mechanism
  - Prevents performance issues when creation of user processes or new kernel threads are involved
- A: complete(xxx) 
- B: wait_for_completion(xxx) 
- B only proceeds when A had called complete

---

# Reader/Writer Spinlocks
- Allow any number of readers into critical section simultaneously
- Writers must have exclusive access 
- rwlock_t similar to rwsem semaphore

---

# Ambiguous rules
Be careful not to double lock!
e.g. foo() gets lock A, calls bar() which also gets lock A
Common solution: modified _bar() that assumes A is already held

---

# Lock Ordering Rules
![lock ordering](/images/Concurrency/slide23.png)
Total ordering!
if you lock A then B then C
You MUST unlock C then B then A
And never lock B then A (etc) somewhere else!
Otherwise, you get deadlock…

---

# Fine Versus Coarse-Grained Locking
- Old kernels had one big lock
  - Not scalable
- Modern kernels have thousands of locks each protecting smaller resources
- Can be too complex
- lock_kernel() lmao 😂

---

# Alternatives to locking
## 😳

---

# Lock-Free Algorithms
- Circular buffer
- Requires no locking in the absence of multiple consumers and producers
- Only Producer thread can modify the write index and array location it points to
- Only reader thread can access read index and value it points to
- If the two pointers don’t overrun each other, the producer and consumer can access the buffer concurrently with no race conditions
[https://stackoverflow.com/questions/871234/circular-lock-free-buffer](https://stackoverflow.com/questions/871234/circular-lock-free-buffer)

---

# Atomic Variables
- Used for simple shared resources like an int value
- o_op++;
  - Can be done in atomic manner
- Locking is overkill, use an atomic_t instead
  - atomic_inc(atomic_t \*v); 
  - atomic_dec(atomic_t \*v); 
  - atomic_add_return(int i, atomic_t \*v);

---

# Bit Operations
- Used for shared flags
- Manipulate individual bits in an atomic manner
- Example functions 
  - set_bit(nr, void \*addr); 
  - clear_bit(nr, void \*addr);

---

# seqlocks
- Used for a frequently accessed, small, and simple resource 
- Allows free access for readers but requires the readers to check for collisions with writers
- When a collision occurs, retry their access
[https://www.kernel.org/doc/html/latest/locking/seqlock.html](https://www.kernel.org/doc/html/latest/locking/seqlock.html)

---

# Read-Copy-Update (RCU)
- When a data structure needs to be changed, the writing thread makes a copy, changes the copy, then aims the relevant pointer at the new version
- Used for situations where, reads are common and writes are rare
- Very complex: many memory barriers used
