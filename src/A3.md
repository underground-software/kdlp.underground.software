### A3 - Hello kernel 🐧

Write a kernel module that prints a message to the kernel ring buffer when the module is inserted and initialized and when the module is removed and exits.

Keep in mind that messages sent to the kernel ring buffer with printk (or its macro variants in the pr_* family) will not be shown in dmesg until a newline is sent or printk is called a second time. For that reason, we recommend using printk directly in this assignment and, of course, ending your format string with the ‘\\n’ newline escape character.

There are numerous examples online, including one in the slides that we showed in class. Feel free to start from any of these.

The string “hello world” is acceptable but boring. If you can make us laugh at your patch we will honor you in front of your peers.

Your submission must include the output of dmesg that is generated upon inserting and removing your module.

<br></br>

What to submit:

- The first patch should create a directory in A3/ titled firstname_lastname and add your Makefile.

  - Make sure to have compiler warnings enabled (at least -Wall but ideally -Wextra -Wpedantic or even -Weverything if you use clang) and that your code doesn’t have any warnings or errors.

- Within the firsname_lastname/ directory:

  - Feel free to name files, other than the Makefile, as you please.

  - The second patch should add your .c file containing the module code.

  - The third patch should contain the output of dmesg.

  - Remember to include a cover letter as an additional patch

[Submission Guidelines](submission_guidelines.html)
