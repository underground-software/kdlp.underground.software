### Fin1 - Specification 📐

Assignment Summary: You should come up with the specification for a simple but interesting and non-trivial character device that does something entertaining. This is intentionally open ended.

You will write a detailed specification that someone else could follow to successfully implement the driver and also write a userspace program that implements unit tests that a correct driver should pass to verify its compliance with the specification.

<br></br>

The specification should document and explain the following system calls:

- Open

- Read

- Write

- Close

- At least one of ioctl / lseek

The test program should exercise the behavior of all of the system calls in the specification to ensure the correctness of the driver.

However, since you won’t have a completed driver yet, you won’t be able to fully run the test program and have the tests pass. We recommend using strace or another similar program to ensure that your test program is at least making the right system calls with the intended arguments.

<br></br>

What to submit:

- A patch to the assignment directory containing your directory named firstname_lastname.

  - The first patch should create this directory and add your specification.

- The second patch should include your test program and a Makefile to build it..

  - Make sure to have compiler warnings enabled (at least -Wall but ideally -Wextra -Wpedantic or even -Weverything if you use clang) and that your code doesn’t have any warnings or errors.

- Don’t forget a cover letter.

[Submission Guidelines](../policies/submission_guidelines.md)
