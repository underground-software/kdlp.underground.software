---
layout: article
title: The Process Filesystem
---
Unlike some of the more esoteric resources that
can be referred to by a file descriptor,
the entries found in the `/proc` directory on
any Linux system are in fact real files.

However, they are not entirely like other files:
they are transient.
That is to say, these files are not stored
on any long-term storage
media, e.g. a hard drive.
These files don't need long term storage because
they provide access to information that only
exists at runtime.

Instead of reading the directory
structure and contents from a storage medium,
the kernel creates the files in `/proc` at runtime
and synthesizes their contents on demand.

Specifically, the kernel creates a directory for each
running process on the system named after its pid.
In addition, the kernel provides a "magic" symlink
named `self`
whose target depends on which process is looking.
Any process that examines the symlink
sees it resolve to the folder that corresponds to
the calling process's pid.

This directory contains information about running processes.
For a complete list of the contents, refer to the kernel
[documentation](https://docs.kernel.org/filesystems/proc.html) and the
[manpage](https://man7.org/linux/man-pages/man5/proc.5.html).


Unfortunately,
`/proc` also contains many
miscellaneous files that were added
before the community developed `/sys`.
They are  still present to preserve
backwards compatibility.

### A `/proc`tical example

In bash, `$$` is a
[special variable](https://www.gnu.org/software/bash/manual/html_node/Special-Parameters.html)
that expands to the pid of the bash process.

For example:

		$ echo $$
		1337

This means we can use `$$` when building a path
to reference the `/proc` subdirectory corresponding
to the running bash process.
In P1, the systemcall used the
`get_task_comm` kernel macro to find the name
of the running program.
`/proc` also provides userspace access to this
information. Here is an example:

		$ cat /proc/$$/comm
		bash

We can also discover the absolute path of the
executable invoked to start the process by
traversing another "magic" symlink named `exe`:

		$ readlink /proc/$$/exe
		/usr/bin/bash

If we replace `$$` with `self`,
we are now referring to the child process
the shell created by `fork`ing itself
and `exec`ing the user command:

		$ cat /proc/self/comm
		cat

		$ readlink /proc/self/exe
		/usr/bin/readlink

Another useful entry in `/proc` for
a given process is the `fd` directory,
which contains magic symlinks to all file
descriptors owned by the process:

		$ ls -l /proc/self/fd
		... 0 -> /dev/pts/0
		... 1 -> /dev/pts/0
		... 2 -> /dev/pts/0
		... 3 -> /proc/128523/fd

As expected, the first three entries are
`stdin`, `stdout`, and `stderr`
which are connected to our terminal.
We can also see how the `ls` program opens
its own subdirectory in `/proc` by following
the "magic" `/proc/self` symlink.
