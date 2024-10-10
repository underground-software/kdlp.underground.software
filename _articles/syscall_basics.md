---
layout: article
title: Syscall Basics
---
### C system programming interactive demo

0. the most basic C program possible: `main(){}`

1. hello world

2. What is a system call?
  
    * Synchronously ask Linux to do something for you as a user program

    * Student examples: open, read, write, close

    * Use these with file descriptors to do file I/O without `FILE *`

    * Use `man 2 xxx` to learn about system call `xxx`

3. Working with processes

    * [execve](https://man7.org/linux/man-pages/man2/execve.2.html): transform one process into another

    * [fork](https://man7.org/linux/man-pages/man2/fork.2.html): split one process in two

    * [wait](https://man7.org/linux/man-pages/man2/wait.2.html): wait for a child process

### Continue Syscall Demo

* Charlie demonstrated several system calls needed to complete `P0`, with a focus on dealing with file descriptors

* Take note that the `struct stat` for a file contains a `mode` field that specifies file permissions

* Use the [`dup(2)`](https://man7.org/linux/man-pages/man2/dup.2.html) family to create unnamed pipes on your system

* When working with C strings in the kernel, we recommend passing around a pointer and a length pair rather than relying on null-termination

	* Once must take extra precaution to avoid buffer overflows in the kernel
	* While in userspace a buffer overflow is harmful, in the kernel it can be catastrophic to a system, and in a production environment, devastating to an organization

	* We will spend more time discussing security concerns later on

* Note that file descriptors are integers that index into a table of file descriptions.

* [`dup(2)`](https://man7.org/linux/man-pages/man2/dup.2.html) uses the file descriptor table to connect two file descriptors to each other.

* While `dup()` takes an fd to duplicate, `dup2()` takes a second existing fd to overwrite as the other end of the pipe.
