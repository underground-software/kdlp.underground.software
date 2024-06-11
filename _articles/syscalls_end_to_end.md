---
layout: article
title: "Syscalls: End-to-End"
---
### Part I

All previously discussed exceptions were just that: exceptional.

The kernel handled them behind the scenes invisibly to the user or they were the result
of a bug in which case the kernel sent the program a fatal signal (e.g. `SIGILL`, `SIGSEGV`, and `SIGFPE`)

Today we demonstrate the mechanism by which your code can intentionally call a system function running in kernel mode; in other words, a system call.

We want to know how the userspace invocation ultimately connects back to the `SYSCALL_DEFINE` macro that you hunted down, traced, and wrote a history report on during
[E1](../course/fall2023/assignments/E1.md)

Let's follow the path of a syscall on x86.

First of all, a user program invokes the
[syscall](https://www.felixcloutier.com/x86/syscall)
instruction.

As described therein, the CPU immediately elevates
privilege level and jumps to the address in the LSTAR MSR register.

Who set the value of this `LSTAR` Model Specific Register?

In the
[syscall_init](https://elixir.bootlin.com/linux/v6.5/source/arch/x86/kernel/cpu/common.c#L2054)
function, we find this
[line](https://elixir.bootlin.com/linux/v6.5/source/arch/x86/kernel/cpu/common.c#L2057):

		wrmsrl(MSR_LSTAR, (unsigned long)entry_SYSCALL_64);

Which sets set the value of LSTAR to the address of the
[entry_SYSCALL_64](https://elixir.bootlin.com/linux/v6.5/source/arch/x86/entry/entry_64.S#L87)
function.

This is not C code :)

The `.S` suffix indicates this is not just regular assembly code, but code that must be run through `cpp` in order to resolve macros in the file. The kernel uses these macros to make it easier to write the code correctly and facilitate interoperability with the rest of the kernel.

At this time, the kernel is executing in a privileged mode, but all of the registers refer to userspace data.


### Part II

At the end of part I  we had discussed the syscall process up when the processor jumps to the
[entry_SYSCALL_64](https://elixir.bootlin.com/linux/v6.5/source/arch/x86/entry/entry_64.S#L87)
function within `entry_64.S` which is written in assembly. As documented [here](https://www.felixcloutier.com/x86/syscall),
for performance reasons the only actions taken by the `syscall` instruction besides elevating privilege to ring 0 are:

* Saving the return address before jumping to the kernel handler:
    * The current instruction pointer `rip` is copied into `rcx`
    * The address of the kernel handler is loaded from the `LSTAR` model specific register into `rip`
* Saving the current processor flags before reseting them to a known value
    * The current flags `RFLAGS` are copied into `r11`
    * The flags register is adjusted with a bitmask from the `FMASK` model specific register

Within the `entry_SYSCALL_64` handler function, it is the responsibility of the kernel to save any
other userspace state that it wishes to restore when the syscall returns.
In the case of the linux kernel, all normal CPU registers should be saved.

However, this presents a problem because essentially all cpu instructions involve manipulating the
values stored in the cpu registers. We want to save the data somewhere in memory, but we can't even
load a fixed pointer into a register to move data into that memory location because that would clobber
one of the values we need to save.

Fortunately the designers of the CPU built an escape hatch in for this exact problem: the `swapgs` instruction.

On x86 `gs` is a special type of register called a "segment" register. Segment registers were historically added to
facilitate easier access to more than 64K of memory on Intel's 16bit 8086 cpu (general purpose registers could store
16 bit pointers and segmentation could fill in the correct higher order bits to determine the full virtual address
depending on what your instruction was doing with the pointer (using it to access code, or data, or the stack, etc.).

Segmentation is no longer a concern on 64 bit systems where the registers can easily store pointers to orders of magnitude
more virtual addresses than any computer could have physical ram, but the segmentation registers still exist on modern CPUs
and they have picked up	a new function: storing a pointer for accessing thread local data. The `gs` register holds a pointer
to a block of memory reserved for thread specific data and any instruction can access this pointer by setting the `gs` prefix
on a memory access and providing the desired offset into the thread specific data as the "address". The CPU will add the base
address of the thread specific data from `gs` to the offset supplied in the instruction and the thread local data will be accessed.

The special `swapgs` instruction ([line 91](https://elixir.bootlin.com/linux/v6.5/source/arch/x86/entry/entry_64.S#L91)) allows
ring 0 (kernel) code to atomically swap the value of `gs` with a well known value previously established by the kernel in a model
specific register that will hold a pointer to per cpu data while saving the old `gs` value from userspace into a different MSR
so it can be restored later.

The handler code can then use scratch space allocated in the per cpu block to save the userspace stack pointer
([line 93](https://elixir.bootlin.com/linux/v6.5/source/arch/x86/entry/entry_64.S#L93)) and replace `rsp` with a pointer to
kernel stack ([line 95](https://elixir.bootlin.com/linux/v6.5/source/arch/x86/entry/entry_64.S#L95)). Once that has been completed,
 the rest of the registers can be saved by just pushing them onto the kernel stack. The values are pushed in a specific order
([lines 100-109](https://elixir.bootlin.com/linux/v6.5/source/arch/x86/entry/entry_64.S#L100)) to make the overall footprint of the
data on the stack match the layout of a [`struct pt_regs`](https://elixir.bootlin.com/linux/v6.5/source/arch/x86/include/asm/ptrace.h#L59).

This means that after all the pushing, `rsp` is a valid `struct pt_regs *` pointer. It can be copied into `rdi`
([line 112](https://elixir.bootlin.com/linux/v6.5/source/arch/x86/entry/entry_64.S#L112)) to be the first argument along with
the syscall number in `rax` into `rsi` ([line 114](https://elixir.bootlin.com/linux/v6.5/source/arch/x86/entry/entry_64.S#L114))
to become the second argument when it calls the C function [`do_syscall_64`](https://elixir.bootlin.com/linux/v6.5/source/arch/x86/entry/common.c#L73).

From this point things are more simple, the kernel attempts to interpret the syscall number as a 64 bit syscall by calling
[`do_syscall_x64`](https://elixir.bootlin.com/linux/v6.5/source/arch/x86/entry/common.c#L40) and we can assume this is successful
if we are calling from 64 bit code.

The meat of that function is verifying that the syscall number is in range ([line 48](https://elixir.bootlin.com/linux/v6.5/source/arch/x86/entry/common.c#L48))
and then looking up the function pointer for the corresponding syscall number in an array then calling it and saving the return value into the entry for the ax register in
the `struct pt_regs` that will be restored when the kernel code returns ([line 50](https://elixir.bootlin.com/linux/v6.5/source/arch/x86/entry/common.c#L50)).

The [`sys_call_table`](https://elixir.bootlin.com/linux/v6.5/source/arch/x86/entry/syscall_64.c#L16) array in generated using a technique called an
[X macro](https://en.wikipedia.org/wiki/X_macro). During the kernel build process, a header file is generated using
[the syscall table](https://elixir.bootlin.com/linux/v6.5/source/arch/x86/entry/syscalls/syscall_64.tbl)
that invokes a macro `__SYSCALL` (that is not defined within the header) once for each syscall with arguments of its number and entry point.

The `__SYSCALL` macro can be given whatever definition the user wants and then the header can be included to programmatically generate invocations
of that specific version of the macro for each syscall. Within [`arch/x86/entry/syscall_64.c`](https://elixir.bootlin.com/linux/v6.5/source/arch/x86/entry/syscall_64.c)
the `__SYSCALL` macro is defined twice, the first time ([lines 10-12](https://elixir.bootlin.com/linux/v6.5/source/arch/x86/entry/syscall_64.c#L10))
it uses the syscall name in the argument to form a declaration for a function named `__x64_sys_something` that takes a `const struct pt_regs *` argument,
and the second time ([lines 14-18](https://elixir.bootlin.com/linux/v6.5/source/arch/x86/entry/syscall_64.c#L14))
it fills the `sys_call_table` variable will pointers to each of those functions in the right order.

These wrapper functions are defined as part of the [`SYSCALL_DEFINE` macro](https://elixir.bootlin.com/linux/v6.5/source/arch/x86/include/asm/syscall_wrapper.h#L228).
The [`__X64_SYS_STUBx`](https://elixir.bootlin.com/linuxv/v6.5/source/arch/x86/include/asm/syscall_wrapper.h#L96) macro generates
a function named `__x64_sys_whatever` that takes a `struct pt_regs` whose body just calls another wrapper starting the `__se_` with the real syscall args.
These are obtained by the [`SC_X86_64_REGS_TO_ARGS`](https://elixir.bootlin.com/linux/v6.5/source/arch/x86/include/asm/syscall_wrapper.h#L56)
macro which converts the list of arguments into accessing `regs->register` for each register in the appropriate order.

The `__se_` wrapper (short for sign extension) has to do with 32 bit compatibility and is generated in place by the SYSCALL_DEFINE macro
([line 233](https://elixir.bootlin.com/linux/v6.5/source/arch/x86/include/asm/syscall_wrapper.h#L233)), and finally it calls into
a function with the prefix `__do_` that is the function whose header is right at the end of the wrapper ([line 240](https://elixir.bootlin.com/linux/v6.5/source/arch/x86/include/asm/syscall_wrapper.h#L240))
and whose body is supplied by the code within the curly braces that follows a given `SYSCALL_DEFINE` invocation.

At this point it is running the code in that block and the syscall has officially begun :)
