---
layout: article
title: "Compilation Process Deep Dive: How a C Program Becomes an Executable"
---
Take this C source file `hello.c`:

```
#include <stdio.h>

int main(void)
{
	puts("Hello, world!");
	return 0;
}
```

You should be familiar with the following invocation:

	gcc hello.c -o hello

This is the most basic way to compile a C source file into an binary file you can execute.

Most of you are also familiar with breaking this process into two steps:

**Compilation**:

	gcc -c hello.c -o hello.o

**Linking**:

	gcc hello.o -o hello


This has advantages for large projects because the compilation can be done in parallel, and as you edit the code, only the files that you change need to be recompiled.

While *two* steps is enough for practical purposes (e.g. decreasing build time), it is not the full story.
In reality, the C compiler performs least _four_ distinct processes behind the scenes: preprocessing, compilation, assembly, and linking.

The command `gcc -c hello.c -o hello.o` encompasses the preprocessing, compilation, and assembly steps, while the command `gcc hello.o -o hello` encompasses the linking step.

We can invoke each step manually like so:

0. Preprocessing

		cpp hello.c -o hello.i

The
[C preprocessor](https://en.wikipedia.org/wiki/C_preprocessor)
removes comments, collapses whitespace, and resolves macros.

The output is traditionally given the suffix `.i` which stands for intermediate.

0. Compilation

		cc -S hello.i -o hello.s

This is where C language constructs like variables, types and control-flow are flattened into undifferentiated data and code.

After this point, we have no way to tell with certainty that this assembly output came from C program input. A compiler for a different language could plausibly generate identical assembly output.

0. Assembly

		as hello.s -o hello.o

The instructions are replaced with their machine code equivalents. This part is reversible, but
the assembler also rips out the last remnants of structure leftover from the original C program source. Static data and functions lose their names and are referred to by only their address, and any exported or imported variables and functions become generic entries in a symbol table. All other labels (e.g. the target of a jump within the same function) are gone without a trace.

After this step, the output is no longer human readable text.

0. Linking

		ld hello.o -l:crt1.o -lc -dynamic-linker /lib64/ld-linux-x86-64.so.2 -o hello

Even though _our_ functions have been compiled into machine code that our CPU could in theory execute,
there is still work do be done. The linker collects the dependencies of our program
(the C startup runtime `-l:crt1.o` that provides the `_start` symbol and the C standard library `-lc` which provides the `puts` symbol) and bundles them into one file.
The linker makes connections between object files, by cross-referencing their symbol tables
to resolve previously unresolved symbols with their now known locations.

In reality symbol resolution is an instance of
the classic engineering trade-off between
execution speed and memory footprint.
Our C program, like most, is at least partially
[dynamically](https://en.wikipedia.org/wiki/Dynamic_linker)
linked at runtime (`-dynamic-linker /lib64/ld-linux-x86-64.so.2`).

The output is an executable ELF file that the kernel loader can load into memory and execute on a CPU.
