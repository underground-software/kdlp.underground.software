### Mid1 - Specification 📐

Write a specification and userspace test program for a character device

You should come up with a simple but interesting and non-trivial character device that does something entertaining.

<br></br>

The test program should exercise the followinf system calls:

- read

- write

- ioctl/unlocked_ioctl

- llseek/lseek

- open

- close/release

<br></br>

What to submit:

- A patch to the assignment directory containing your directory named firstname_lastname.

  - The first patch should create this directory and add a Makefile to build your test program.

  - Make sure to have compiler warnings enabled (at least -Wall but ideally -Wextra -Wpedantic or even -Weverything if you use clang) and that your code doesn’t have any warnings or errors.

- The second patch should add your test program.

- The third patch should add your spec.

- Don’t forget a cover letter.

[Submission Guidelines](submission_guidelines.html)
