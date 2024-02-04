### How to submit a code review

* You will be assigned two students to peer review shortly after you complete your own initial submission.
* For each student, which you are assigned, you will do the following:
  * Locate their submissions and download all of the patches in the patchset (besides the cover letter).
  * Make a new branch off of master/main and switch over to that branch to apply the patches.
  * Make sure each patch applies cleanly IN ORDER (a.k.a no corrupt patches, whitespace errors, etc.)
    * You can run checkpatch.pl on the patches, ignore any errors pertaining to maintainers.
  * Make sure the code compiles without warnings or errors.
  * Make sure the program runs without crashing.
  * Make sure that the output is correct (passes all tests, if applicable).
  * If there are any problems with the submission, document said issues and report them in your email reply to the student who you are reviewing.
  * If you determine that there are no issues with the submission, inform the recipient.
    * If it turns out that there were issues with the submission that you missed, points will be deducted from your overall assignment grade.
  * Refer [here](course_policies.md) for the grading policy regarding peer reviewing.
