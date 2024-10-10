---
layout: article
title: Linux Kernel Basics
---
#### Fundamental difference: CPU privilege level at a given time

* On a Linux system, when the CPU is executing code in a fully privileged mode, we say that the CPU is executing the code in kernelspace

* On a Linux system, When the CPU is executing code at a restricted privilege level, we say that the CPU is executing the code in userspace

#### What does CPU privilege enable?
* Set behavior on [trap](https://en.wikipedia.org/wiki/Interrupt#Terminology)
* Set behavior on [interrupt](https://en.wikipedia.org/wiki/Interrupt)
    * A quick explanation of [both](https://stackoverflow.com/questions/3149175/what-is-the-difference-between-trap-and-interrupt)
* Set virtual-physical address mappings, i.e. configure [page tables](https://en.wikipedia.org/wiki/Page_table)
* Execute privileged instructions
    * See [this table](https://www.felixcloutier.com/x86/) as an x86 instruction reference
    * We discussed [RDMSR](https://www.felixcloutier.com/x86/rdmsr) as an example
	* Unpriveleged execution of this instruction [raises](https://www.felixcloutier.com/x86/rdmsr#protected-mode-exceptions) the `#GP(0)` [CPU exception](https://wiki.osdev.org/Exceptions).
	* This is a [General Protection Exception](https://wiki.osdev.org/Exceptions#General_Protection_Fault)
	* There are three types of CPU exceptions: [faults](https://wiki.osdev.org/Exceptions#Faults),  [traps](https://wiki.osdev.org/Exceptions#Traps), and [aborts](https://wiki.osdev.org/Exceptions#Aborts).
	* The website linked in the previous bulled, wiki.osdev.org, has a huge about of information on this subject for the interested reader
* We experimented bit of assembly code to test out the exception handling codepaths of the Linux kernel.

#### Exceptions review

We've previously demonstrated how our attempts
to execute an invalid instruction or a privileged
instruction while in user mode causes a CPU
exception. At the hardware level, the CPU
immediately switches it's privilege mode to kernel mode
and jumps at corresponding kernel function installed
at boot to handle handle the exception. In this case,
the handler function prints an error message to the
kernel ring buffer and kills our program.


To give a couple more examples:
Software conditions such as dividing by zero or accessing an unaligned address trigger CPU exceptions. Hardware can of course also interrupt CPU execution by changing voltage on CPU pins. Finally, attempting to access a pointer
([virtual memory address](https://en.wikipedia.org/wiki/Virtual_memory)) for which the
[memory-mapping unit](https://en.wikipedia.org/wiki/Memory_management_unit) does not have a corresponding physical address triggers an
[page fault](https://wiki.osdev.org/Exceptions#Page_Fault)
exception which the kernel may resolve by setting up appropriate mapping (e.g. memory that was lazily allocated or swapped to disk), or by sending the program the `SIGSEV` signal otherwise known as a "Segmentation Fault".

#### Userspace Demo

Here's a short AT&T-style x86 assembly file we can use to generate a binary that will attempt to execute a privileged instruction:

```
global _start		; declare the _start symbol to have external linkage for visibility of linker
_start:				; the true entry point for an x86 executable program
	rdmsr			; execute the RDMSR instruction
```

Build the object file `rdmsr.o` from [`rdmsr.src`](https://kdlp.underground.software/cgit/priv_rdmsr_demo/tree/rdmsr.src) with:

`as -o rdmsr.o rdmsr.src`

Create the linked executable binary `rdmsr` from `rdmsr.o` with:

`ld -o rdmsr rdmsr.o`.

Invocation of this binary by `./rdmsr` should trigger a protection fault.

More information on the [`#UD` Invalid Opcode](https://wiki.osdev.org/Exceptions#Invalid_Opcode) exception.

#### Kernelspace Demo

With a small kernel module, we can get Linux to run the same instruction in kernelspace:

```
#include <linux/module.h>
#include <linux/init.h>
MODULE_LICENSE("GPL");
static int priv_demo_init(void) {
                /* arbitrary poison values */
                int result_lower_32 = -0xAF, result_upper_32 = -0xBF;
                pr_info("EDX:EAX := MSR[ECX];");
                asm ( "rdmsr"
                : "=r" (result_upper_32), "=r" (result_lower_32) : : );
                pr_info("rdmsr: EDX=0x%x, EAX=0x%x\n",
                                result_lower_32, result_upper_32);
                return 0;
}
static void priv_demo_exit(void) {
                pr_info("rdmsr exiting");
}
module_init(priv_demo_init);
module_exit(priv_demo_exit)
```

We can build this with the same Makefile as shown [here on the E2 page](../course/fall2023/assignments/E2.md).

#### Fully Automated demo

We created fully automated demo of privileged and unprivileged instruction execution.
To acquire and run this demo, enter your VM and run `git clone https://kdlp.underground.software/cgit/priv_rdmsr_demo/` and run `make` inside the directory.

### Further look at kernelspace vs userspace demo

We took another look at the demo we posted on [L05](../course/fall2023/lectures/L05.md) after class.

That demo can be found
[here](https://kdlp.underground.software/cgit/priv_rdmsr_demo/) and obtained by running:

    git clone https://kdlp.underground.software/cgit/priv_rdmsr_demo

Ensure that you are comfortable with some of the introductory details
we discussed in [L05](../course/fall2023/lectures/L05.md).

Recall from [L05](../course/fall2023/lectures/L05.md) that a trap is a type of CPU exception.

We browsed the source for the Linux implementation of trap handling to understand the codepath that executes when the user executes the "UD2" instruction and prints a message to the kernel ring buffer (`dmesg`).

Th address of the handler for this exception is defined  in
[arch/x86/kernel/traps.c](https://elixir.bootlin.com/linux/v6.5.5/source/arch/x86/kernel/traps.c), as
[`exc_invalid_op`](https://elixir.bootlin.com/linux/v6.5.5/source/arch/x86/kernel/traps.c#L336).
Elsewhere, the corresponding row of the
[IDT](https://wiki.osdev.org/IDT)
is set to this address, so when the exception is generated,
[`handle_invalid_op`](https://elixir.bootlin.com/linux/v6.5.5/source/arch/x86/kernel/traps.c#L292) is called.

If you are interested in the IDT then may also be interested in the
[GDT](https://wiki.osdev.org/GDT).

Linux implements a lot of x86-specific IDT related code in
[arch/x86/kernel/idt.c](https://elixir.bootlin.com/linux/v6.5.5/source/arch/x86/kernel/idt.c).

### Intro to kernelspace

To begin, we used parts of the [Kernel Modules and Device Drivers](/slides/modules_drivers.html) slide deck.

* The slides are a little bit out of sync with how we have re-arranged the course and we have not yet reached device driver development.

* The last three slides were the most relevant, however students may be interested in taking a look at the rest of it.

* The kernel uses a small, fixed-size stack, compared to the larger, extendable stack used by userspace programs.

* The C library, itself being a userspace program, is not available in kernelspace. Instead, many -- but importantly not all -- are implemented within the kernel.

* For example, the IEEE754 floating point storage type that we all know and love from userspace C programming is entirely banned from the kernel.

* The reason is that when CPU switches between kernelspace and userspace, it has to save and restore it's execution state to remember where it left off, and saving and restoring the floating point registers is considered to be too much overhead.

* The kernel uses a different range of the address space than userspace. On x86_64 systems, the virtual address space is generally split in half

#### The most important takeaway: kernel code is **reentrant**

* <u>Definition</u>: A computer program is considered **reentrant** if and only if multiple concurrent executions of the same program always run correctly.

* Further information can be found on the [reentrancy](https://en.wikipedia.org/wiki/Reentrancy_(computing)) Wikipedia page.

* Assume that *any* line of code in the kernel can be running at *any* time with *any* number of concurrent executions of the same code.
