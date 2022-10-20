### A5 - Building Character 2 🏋️

Following on from last week's assignment, add support for the two advanced character driver operations we discussed in class (ioctl and llseek).

Your implementations should be based on the implementations of the read and write operations.

You will be assigned another random sequence now including the additional operations and you should update your userspace program to generate this sequence instead. Your patch series should include one patch for your kernel driver and another for the userspace program.

<br></br>

What to submit:

- A patch to the assignment directory containing your directory from assignment 4

  - This first patch should add your Makefile and the code as it was from A4

  - Make sure to have compiler warnings enabled (at least -Wall but ideally -Wextra -Wpedantic or even -Weverything if you use clang) and that your code doesn’t have any warnings or errors.

- The second patch should implement the new file operations in the base driver.

- The second patch should implement the new file operations in the base driver.

- Don’t forget a cover letter.

[Submission Guidelines](submission_guidelines.html)
