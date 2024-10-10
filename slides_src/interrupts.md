---
theme: white
---

# Interrupt Handling
[Chapter 10](https://static.lwn.net/images/pdf/LDD3/ch10.pdf)

---

## An interrupt is simply a signal that the hardware can send when it wants the processor’s attention

---

# The /proc Interface
- Reported interrupts are shown in /proc/interrupts
root@montalcino:/bike/corbet/write/ldd3/src/short# m /proc/interrupts 
CPU0         CPU1 
0:         4848108     34             IO-APIC-edge     timer 
2:         0             0             XT-PIC             cascade
- First column shows IRQ number
- The last two columns give information on the programmable interrupt controller that handles the interrupt

---

# Installing an Interrupt
- Must tell kernel to expect an interrupt, if not, it simply acknowledges the interrupt and ignores it
- int request_threaded_irq(unsigned int irq, irq_handler_t handler, irq_handler_t thread_fn, unsigned long flags, const char \*name, void \*dev); 
- thread_fn can be NULL if you only need a top half
- Drivers can share handlers

---

# Top and Bottom Halves
- Top half runs asynchronously (not in process context) with interrupts disabled
- It has to make a snap judgement about the interrupt
- The bottom half is a regular function to be executed later when we have more time 
- interrupts are enabled during execution of the bottom half

---

# Implementing a Handler
- Can’t transfer data to and from user space. Doesn’t execute in context of a process
- Can’t sleep
- First step is often acknowledging the signal from the hardware
- Might awaken processes sleeping if the interrupt signals an event they are waiting for
- Should execute in a minimum amount of time
  - Use a bottom half for long computations

---

# Enabling and Disabling Interrupts
- void {disable_irq, disable_irq_nosync, enable_irq}(int irq);
  - Used to disable a single interrupt
- void local_irq_save(unsigned long flags);, void local_irq_disable(void);
  - Disable all interrupts
- void local_irq_restore(unsigned long flags);, void local_irq_enable(void);
  - Restores interrupts

---

# Interrupt Sharing
- Modern hardware has been designed to allow the sharing of interrupts; PCI bus requires it
- Linux supports interrupt sharing on all buses

---

# Installing a Shared Handler
- The SA_SHIRQ bit must be specified in the flags argument when requesting the interrupt 
- The dev_id argument must be unique. Any pointer into the module’s address space will do, but dev_id definitely cannot be set to NULL
- irq_request succeeds when one of the following is true:
  - The interrupt line is free
  - All handlers already registered for that line have also specified that the IRQ is to be shared

---

# Running the Handler
- use the dev_id argument to determine which, of possibly many, devices might be interrupting

---

# Handler Arguments and Return Value
- typedef irqreturn_t (\*irq_handler_t)(int irq, void \* dev_id); 
- Irq is the interrupt number, dev_id is a short of client data
- Interrupt handlers should return a value indicating whether there was an actual interrupt to handle
  - IRQ_HANDLED if the IRQ was able to be handled by the top half
  - IRQ_WAKE_THREAD if the bottom half should be scheduled
  - IRQ_NONE if there was nothing to handle (or IRQ wasn’t from device)

---

# Interrupt Driven I/O
- Buffer in case of read/write delay
- Improve performance by handling part of action asynchronously
- Read:
  - fill buffer from device during interrupt
  - copy to user from buffer on system call
- Write:
  - copy from user to buffer on system call
  - write from buffer to device on interrupt
