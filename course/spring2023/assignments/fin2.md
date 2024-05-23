### Fin2 - Writing some actual kernel code at last 🕴️

You will be assigned someone else’s specification and tests. Your task is to implement the specification with a character device module. The existing tests should pass when run against your module.

If you have a problem with the spec you are given, communicate with its author to work out potential areas of ambiguity, bugs in the test file, or even to add new features that make sense to you. If the spec author is uncooperative, let us know and we can help. We encourage you to have your discussions about each other’s code as responses to the patch emails from the previous assignment.

<br></br>

What to submit:

- A patch to the assignment directory containing your directory named firstname_lastname.

  - The first patch should create this directory and add a Makefile to build your driver as well as the test program.

  - Make sure to have compiler warnings enabled (at least -Wall but ideally -Wextra -Wpedantic or even -Weverything if you use clang) and that your code doesn’t have any warnings or errors.

- The second patch should add your test program.

- The third patch should add your driver.

- Don’t forget a cover letter.

[Submission Guidelines](../policies/submission_guidelines.md)
